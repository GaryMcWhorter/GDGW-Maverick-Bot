import std/[
  asyncdispatch,
  json,
  options,
  os,
  strformat,
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
  User = object
    exp: int
    lastMessageTimeStamp: TimeStamp

var
  users = newTable[string, User]()

# Import all commands
importCommands()
let discord = newDiscordClient(Config.bot.token)

let prefix: string = Config.prefs.botPrefix
let expCooldown: int = Config.prefs.expCooldown
# on_ready event
proc onReady(s: Shard, r: Ready) {.event(discord).} =
  echo "Ready as " & $r.user

proc onEveryMessage(s: Shard, m: Message) {.async.} =
  # Check if user is in temporary store
  let uid = m.author.id.toUid()
  if users.hasKeyOrPut(m.author.id, User()):
    echo "User found"
  else:
    # If not then upsert them to the db
    # echo "User put"
    let newRecord = %*[{"uid": uid, "name": m.author.username}]
    let res = await post(upsert("dev", "testUsers", $newRecord))
    if res.isSome:
      discard await discord.api.sendMessage(m.channelID, res.get())

  # echo $users[m.author.id].lastMessageTimeStamp
  let newTimestamp = initTimestamp()
  # increment exp to the db
  if newTimestamp - users[m.author.id].lastMessageTimeStamp < expCooldown * SECOND:
    echo "TOO FAST"
  else:
    let exp = await post(sql &"UPDATE dev.testUsers SET exp = COALESCE(exp + 3, 3) WHERE uid = '{uid}'")
    if exp.isSome:
      discard await discord.api.sendMessage(m.channelID, exp.get())
    users[m.author.id].lastMessageTimeStamp = newTimestamp


# message_create event
proc messageCreate(s: Shard, m: Message) {.event(discord).} =
  if m.author.bot: return # Always ignore bots, including self

  # Processing that must be done on every message received,
  # such as message parsing and exp systems
  await onEveryMessage(s, m)

  # Return if it's not a command
  if not m.content.startsWith(prefix): return
  let (cmd, params) = getCommandInfo(m.content, prefix)
  if cmd in commandTable:
    await commandTable[cmd].invoke(discord, params, m)

# Connect to Discord and run the bot
waitFor discord.startSession()
