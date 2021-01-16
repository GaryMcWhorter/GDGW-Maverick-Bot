import std/[
  json,
  strformat,
  options
]
import command, ../harperdb

command:
  name: upsertuser
  description: "update or insert user"
  body:
    let uid = discordMsg.author.id.toUid()
    let newRecord = %*[{"uid": uid, "name": discordMsg.author.username}]
    let res = await post(upsert("dev", "testUsers", $newRecord))
    if res.isSome:
      discard await discord.api.sendMessage(discordMsg.channelID, res.get())
    else:
      discard await discord.api.sendMessage(discordMsg.channelID, "Something went wrong with the server request")

