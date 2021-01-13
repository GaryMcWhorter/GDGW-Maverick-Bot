import command
import std/uri

command:
  name: search
  description: "Sends search URL"
  body:
    let res = "https://duckduckgo.com/" & encodeurl(msg, false)
    discard await discord.api.sendMessage(discordMsg.channel_id, res)