import std/[
  asyncdispatch,
  times,
  options,
  os
]

# from strutils import startsWith

import dotenv, dimscord
import nimcordbot/[
  command,
  search,
  startsWith
]

# Has to be after all command imports
const commandTable = compTimeComTable

#Test case
commandTable["!srch"].invoke("hello world")

let env = initDotEnv()
env.load()

let discord = newDiscordClient(getEnv("BOT_TOKEN"))
let prefix: string = getEnv("BOT_PREFIX")
# on_ready event
proc onReady(s: Shard, r: Ready) {.event(discord).} =
    echo "Ready as " & $r.user

# message_create event
proc messageCreate(s: Shard, m: Message) {.event(discord).} =
    if not m.content.startsWith(prefix) or m.author.bot: return
    if m.content == prefix & "ping":
        let
            before = epochTime() * 1000
            msg = await discord.api.sendMessage(m.channel_id, "ping?")
            after = epochTime() * 1000

        discard await discord.api.editMessage(
            m.channel_id,
            msg.id,
            "Pong! took " & $int(after - before) & "ms | " & $s.latency() & "ms."
        )
    elif m.content == prefix & "embed":
        discard await discord.api.sendMessage(
            m.channel_id,
            embed = some Embed(
                title: some "Hello there!",
                description: some "This is description",
                color: some 0x7789ec
            )
        )

# Connect to Discord and run the bot
waitFor discord.startSession()
