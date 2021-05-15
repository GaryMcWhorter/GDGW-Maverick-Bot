import command
import std/uri

command:
  name: search
  description: "Sends search URL"
  body:
    sendMessage("https://duckduckgo.com/" & encodeurl(msg, false))
