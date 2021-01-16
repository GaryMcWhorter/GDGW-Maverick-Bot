import ../commands
import command
import std/[
  strscans,
  strutils
]
command:
  name: help
  description: "Prints out the command description of a given command."
  body:
    var cmd: string
    if msg.scanf("$+$s", cmd) and commandTable.hasKey(cmd.strip): 
      discard await discord.api.sendMessage(discordMsg.channelID, commandTable[cmd.strip].description)