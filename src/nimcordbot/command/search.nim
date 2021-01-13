import command
import std/uri
proc search(dc: DiscordClient, s: string, dmsg: Message){.async.}= 
  let res = "https://duckduckgo.com/" & encodeurl(s, false)
  discard await dc.api.sendMessage(dmsg.channel_id, res)

addCommand:
  initCommand("search", search, "lmddgtfy")