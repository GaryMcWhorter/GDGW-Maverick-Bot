# Nimcordbot
This is an easily expandable Discord bot written in Nim. You must host this on your own computer or server.


## Setup and Installation
After installing Nim, clone this repo, then make a `config.toml` file with the following fields in the top level of the project directory:
```toml
[database]
# Database url, implementation uses HarperDB
url="https://yourDBURL.harperdbcloud.com"
auth="your db authkey here"

[bot]
# Discord bot token
token = "your discord bot token here"

[prefs]
# Prefix for bot commands
botPrefix = "!"
# Cooldown between getting exp : int
expCooldown = 2
```
To get all the dependencies use `nimble install --depsOnly`

This bot uses a custom DSL for creating commands to greatly simplify the process.
To make new commands for the bot simply make a new `.nim` file in the `src/nimcordbot/command` folder, Then follow this structure:

```nim
import command
command:
  name: yourCommandName
  description: "This Command does something"
  body:
    discard await discord.api.sendMessage(discordMsg.channelID, "It sends this message")
```

Compile like normal or use `nimble run` to run the bot.

After compliation you can now send the message `!yourCommandName` and the bot will send a message containing "It sends this message" in response.

## Planned Features
- [x] Custom DSL for creating new bot commands
- [ ] Integration with HarperDB for database operations
- [ ] Built in leveling system for the server
- [ ] Built in karma thanking system