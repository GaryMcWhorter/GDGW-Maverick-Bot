import std/[
  strformat,
  options
]
import command, ../harperdb

command:
  name: getuser
  description: "Gets a user from the db if they exist"
  body:
    let uid = discordMsg.author.id.toUid()
    let res = await post(sql &"SELECT name FROM dev.testUsers where uid = '{uid}'")
    if res.isSome:
      discard await discord.api.sendMessage(discordMsg.channelID, res.get())
    else:
      discard await discord.api.sendMessage(discordMsg.channelID, "Something went wrong with the server request")

