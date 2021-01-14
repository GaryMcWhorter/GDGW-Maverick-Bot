import constructor/construct
import dimscord
import std/[
  tables,
  asyncdispatch,
  macros
]
export tables, dimscord, asyncdispatch

type Command = object
  name, description: string
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
macro command*(dslBody: untyped): untyped=
  ## Makes it so you dont need to do any repetitive work.
  ## Generates the proc and subscribes it to the table.
  ## Provide a Name, a Description, and the body.
  ## Body has the following variables injected:
  ## `discord` as a `DiscordClient`
  ## `msg` as the string parameter stream
  ## `discordMsg` as the invoking discord `Message`

  result = newStmtList()
  var 
    body, name, nameStr: NimNode
    desc = newStrLitNode("")
    cooldown = newIntLitNode(1)
  for node in dslBody:
    if node[0].kind == nnkident:
      case $node[0]:
      of "description":
        desc = node[1]
      of "body":
        body = node[1]
      of "name":
        name = node[1][0]
        nameStr = newStrLitNode($name)
      of "cooldown":
        cooldown = node[1]
      else: discard
  let
    client = ident("discord")
    msg = ident("msg")
    discordMsg = ident("discordMsg")
  result.add quote do:
    proc `name`(`client`: DiscordClient, `msg`: string, `discordMsg`: Message){.async.} =
      `body`
  result.add quote do:
    static:
      compTimeComTable[`nameStr`] = initCommand(`nameStr`, `name`, `desc`, `cooldown`)