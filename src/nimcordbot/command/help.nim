import ../commands
import command
import std/[
  strscans,
  strutils
]
command:
  name: help
  description: "Prints out the command description of a given command."
  args:
    cmd: string
  body:
    sendMessage(commandTable[cmd.strip].description)
