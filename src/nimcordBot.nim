import std/[
  asyncdispatch,
  json,
  options,
  os,
  sequtils,
  strformat,
  strutils,
  tables,
]

import
  dimscord,
  timestamp

import nimcordbot/[
  config,
  utils,
  harperdb,
  commands
]

# Users temporary store
type
  TempUser = object
    exp: int
    lastMessageTimeStamp: TimeStamp

var
  users = newTable[string, TempUser]()

let thankStrings = ["thank", "ty", "thx"]

# Import all commands
importCommands()
let discord = newDiscordClient(Config.bot.token)

template prefix(): string = Config.prefs.prefix
template expCooldown(): int = Config.prefs.expCooldown
template schema(): string = Config.database.schema

# on_ready event
proc onReady(s: Shard, r: Ready) {.event(discord).} =
  echo "Ready as " & $r.user

proc onEveryMessage(s: Shard, m: Message) {.async.} =
  # Check if user is in temporary store
  let uid = m.author.id.toUid()
  if users.hasKeyOrPut(m.author.id, TempUser()):
    echo "User found"
  else:
    # If not then upsert them to the db
    # echo "User put"
    let newRecord = %*[{"uid": uid, "name": m.author.username}]
    let res = await post(upsert(schema, "testUsers", $newRecord))
    if res.isSome:
      # discard await discord.api.sendMessage(m.channelID, res.get())
      discard
  if m.mention_users.len > 0:
    for thank in thankStrings:
      if m.content.toLowerAscii.contains(thank) and not m.content.contains(
          "no " & thank):
        var thankedUsers = ""
        for muser in m.mention_users:
          if muser.id == m.author.id or muser.bot:
            continue
          let muid = muser.id.toUid()
          let karma = await post(sql &"UPDATE {schema}.testUsers SET karma = COALESCE(karma + 1, 1) WHERE uid = '{muid}'")
          if karma.isSome():
            thankedUsers.add(muser.id.toMention() & ' ')
        if(thankedUsers.len > 0):
          discard await discord.api.sendMessage(m.channelID,
              &"{m.author.username} thanked {thankedUsers}")
        return

  # echo $users[m.author.id].lastMessageTimeStamp
  let newTimestamp = initTimestamp()
  # increment exp to the db
  if newTimestamp - users[m.author.id].lastMessageTimeStamp < expCooldown * SECOND:
    echo "TOO FAST"
  else:
    let exp = await post(sql &"UPDATE {schema}.testUsers SET exp = COALESCE(exp + 3, 3) WHERE uid = '{uid}'")
    if exp.isSome:
      # discard await discord.api.sendMessage(m.channelID, exp.get())
      discard
    users[m.author.id].lastMessageTimeStamp = newTimestamp


# message_create event
proc messageCreate(s: Shard, m: Message) {.event(discord).} =
  if m.author.bot: return # Always ignore bots, including self

  # Processing that must be done on every message received,
  # such as message parsing and exp systems
  await onEveryMessage(s, m)

  # Return if it's not a command
  if not m.content.myStartsWith(prefix): return
  let (cmd, params) = getCommandInfo(m.content, prefix)
  if cmd in commandTable:
    await commandTable[cmd].invoke(discord, params, m)

# Connect to Discord and run the bot
waitFor discord.startSession()
