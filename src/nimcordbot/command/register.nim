import std/[
  json,
  strformat,
  options
]
import command, ../harperdb, ../config

command:
  name: register
  description: "First time set up of the server database"
  body:
    let res = await post(createSchema(Config.database.schema))
    if res.isSome:
      echo res.get()
      let res2 = await post(createTable(Config.database.schema, "testUsers", "uid"))
      if res2.isSome:
        echo res2.get()
        let uid = discordMsg.author.id.toUid()
        let newRecord = %*[{"uid": uid, "name": discordMsg.author.username,
            "exp": 0, "karma": 0}]
        # let newRecord = """[{"uid": "u124", "name": "example name", "exp": "0", "karma": "0"}]"""
        let res3 = await post(insert(Config.database.schema, "testUsers", $newRecord))
        if res3.isSome:
          echo res3.get()
          discard await discord.api.sendMessage(discordMsg.channelID, "Server database is now fully set up")
    else:
      discard await discord.api.sendMessage(discordMsg.channelID, "Something went wrong! The database may already be set up!")

