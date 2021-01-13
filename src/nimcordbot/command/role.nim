import command
import strscans
command:
  name: role
  description: "Adds or remove role from user"
  body:
    var operation, toModify: string
    if msg.scanf("$+ $+", operation, toModify):
      # Todo actually implement the adding/removing
      case operation:
      of "add":
        discard await discord.api.sendMessage(discordMsg.channelID, toModify & " Added")
      of "remove":
        discard await discord.api.sendMessage(discordMsg.channelID, toModify & " Removed")
      else: discard