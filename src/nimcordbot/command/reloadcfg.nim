import command, ../config

command:
  name: reloadcfg
  description: "Reloads the bot config without restarting the bot"
  body:
    Config.reload()
    discard await discord.api.sendMessage(discordMsg.channelID, "Reloaded the bot config")
