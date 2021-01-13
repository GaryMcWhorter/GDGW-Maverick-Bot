import command
import std/uri
proc search(s: string)= 
  echo "https://lmddgtfy.net/" & encodeurl(s, false)
addCommand:
  initCommand("search", search, "lmddgtfy", @["!search", "!lmddgtfy", "!srch"])