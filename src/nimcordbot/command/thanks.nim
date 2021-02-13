import command, ../utils

command:
  name: thanks
  description: "not really like thanks but testing mentions"
  body:
    if discordMsg.mention_users.len > 0:
      echo "found users"
      var foundUsers = ""
      for member in discordMsg.mention_users:
        foundUsers.add(member.id.toMention & " ")
      discard await discord.api.sendMessage(discordMsg.channelID, "thanks to " & foundUsers)

    # discard await discord.api.sendMessage(discordMsg.channelID, "hello")
