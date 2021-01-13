import command
import std/uri
proc search(s: string)= 
  echo "https://lmddgtfy.net/" & encodeurl(s, false)
static:
  initCommand("search", search, "lmddgtfy", @["!search", "!lmddgtfy", "!srch"]).addCommand