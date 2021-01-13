import constructor/construct
import dimscord
import std/[
  tables,
  asyncdispatch
]
export tables, dimscord, asyncdispatch

type Command = object
  name, description: string
  prefix: seq[string]
  command: proc(dc: DiscordClient, msg: string, dMsg: Message){.async.}
  cooldown: int

Command.construct(true):
  name: required
  command: required
  description: ""
  cooldown: 1

proc invoke*(c: Command, dc: DiscordClient, msg: string, dMsg: Message){.async.} =
  await c.command(dc, msg, dmsg)

var compTimeComTable*{.compileTime.} = initTable[string, Command]()
template addCommand*(c: Command)=
  static:
      compTimeComTable[c.name] = c