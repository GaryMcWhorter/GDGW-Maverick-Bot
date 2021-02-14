import std/[
  options
]
import command, ../harperdb

command:
  name: deleteme
  description: "deletes myself from the db"
  body:
    let uid = discordMsg.author.id.toUid()
    # let newRecord = %*[{"uid": uid, "name": discordMsg.author.username}]
    let res = await post(delete("dev", "testUsers", [uid]))
    if res.isSome:
      discard await discord.api.sendMessage(discordMsg.channelID, res.get())
    else:
      discard await discord.api.sendMessage(discordMsg.channelID, "Something went wrong with the server request")

