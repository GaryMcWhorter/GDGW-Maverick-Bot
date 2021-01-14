# Nimcordbot
This is an easily expandable Discord bot written in Nim.


## Setup and Installation
After installing Nim, clone this repo, make an `.env` file, with the following fields:
```
BOT_TOKEN=$YourGithubBotToken
BOT_PREFIX="!"
```
The `BOT_TOKEN` is the bot token given by discord, and the `BOT_PREFIX` is the leading character to invoke commands.
To get all the dependencies can `nimble install --depsOnly`
To make new commands simply make a new `.nim` file in the `stc/nimcordbot/command` folder.
Then do the following:

```nim
import command
command:
  name: yourCommandName
  description: "This Command does something"
  body:
    discard await discord.api.sendMessage(discordMsg.channelID, "It sends this message")
```

After compliation you can now send the message `!yourCommandName` and the bot will send a message containing "It sends this message" in response.
