# Load env's as early as possible
import dotenv
let env = initDotEnv()
env.load()

import std/[
  asyncdispatch,
  os,
]

import dimscord
import nimcordbot/[
  utils,
  harperdb
]

# Import all commands
importCommands()


# Has to be after all command imports
const commandTable = compTimeComTable

let discord = newDiscordClient(getEnv("BOT_TOKEN"))

let prefix: string = getEnv("BOT_PREFIX")
# on_ready event
proc onReady(s: Shard, r: Ready) {.event(discord).} =
    echo "Ready as " & $r.user

# message_create event
proc messageCreate(s: Shard, m: Message) {.event(discord).} =
    if not m.content.startsWith(prefix) or m.author.bot: return
    let (cmd, params) = getCommandInfo(m.content, prefix)
    if cmd in commandTable:
        await commandTable[cmd].invoke(discord, params, m)

# Connect to Discord and run the bot
waitFor discord.startSession()
