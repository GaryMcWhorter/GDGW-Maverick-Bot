import std/[
  json,
  strformat,
  options
]
import command, ../harperdb, ../config

command:
  name: karma
  description: "Gets the karma from a user"
  body:
    let uid = discordMsg.author.id.toUid()
    let res = await post(sql &"SELECT karma FROM {Config.database.schema}.testUsers where uid = '{uid}'")
    if res.isSome:
      let username = parseJson(res.get())
      discard await discord.api.sendMessage(discordMsg.channelID, "You have " &
          $username[0]{"karma"}.getInt() & " karma")
    else:
      discard await discord.api.sendMessage(discordMsg.channelID, "Something went wrong with the server request")

