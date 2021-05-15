import constructor/construct
import dimscord
import std/[
  tables,
  asyncdispatch,
  macros,
  sequtils
]
import strutils except startswith
export tables, dimscord, asyncdispatch 

type Command = object
  name, description: string
  argNames: seq[string]
  command: proc(dc: DiscordClient, msg: string, dMsg: Message){.async.}
  cooldown: int

Command.construct(true):
  name: required
  command: required
  description: ""
  cooldown: 1

proc invoke*(c: Command, dc: DiscordClient, msg: string, dMsg: Message){.async.} =
  await c.command(dc, msg, dmsg)

type Parseable = string or int or bool or float

proc parse*[T: Parseable](s: string): T =
  when T is string: 
    s
  elif T is int:
    s.parseInt
  elif T is float:
    s.parseFloat
  elif T is bool:
    s.parseBool



var compTimeComTable*{.compileTime.} = initTable[string, Command]()


template sendMessage*(message: string) =
  ## Sugar for easier message sending
  discard await discord.api.sendMessage(discordMsg.channelID, message)

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
    args: seq[(NimNode, NimNode)]
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
      of "args":
        for x in node[1]:
          args.add (x[0], x[1][0])
      else: discard
  let
    client = ident("discord")
    msg = ident("msg")
    discordMsg = ident("discordMsg")
    argParsing = newStmtList()
  if args.len == 1:
    let (name, typ) = args[0]
    argParsing.add quote do:
        let `name` = 
          try:
            parse[`typ`](`msg`)
          except:
            sendMessage("Parameter mismatch at position: 0, expected: "  & $`typ`)
            return
  elif args.len > 0:
    let 
      splitData = gensym(nskLet, "data")
      argCount = newLit(args.len)
      typeLayout = newLit(args.mapIt($it[1]).join(", "))
    if args[^1][1].eqIdent("string"):
      argParsing.add quote do:
        let `splitData` = split(`msg`)
        if `splitData`.len < `argCount`:
          sendMessage("Too few parameters got: " & $`splitData`.len & " expected atleast: " & $`argCount` & " of parameters: `" & `typeLayout` & "`")
          return
    else:
      argParsing.add quote do:
        let `splitData` = split(`msg`)
        if `argCount` != `splitData`.len:
          sendMessage("Expected:  " & $`argCount` & " parameters but got: " & `splitData`.len)
          return
    for i, (name, typ) in args:
      if args.high != i and not typ.eqIdent("string"):
        let pos = newLit($i)
        argParsing.add quote do:
          let `name` = 
            try:
              parse[`typ`](`splitData`[`i`])
            except:
              sendMessage("Parameter mismatch at position: " & `pos` & " expected: "  & $`typ`)
              return
      else:
        argParsing.add quote do:
          let `name` = `splitData`[`i`..^1].join(" ")
    
  result.add quote do:
    proc `name`(`client`: DiscordClient, `msg`: string, `discordMsg`: Message){.async.} =
      `argParsing`
      `body`
  result.add quote do:
    static:
      compTimeComTable[`nameStr`] = initCommand(`nameStr`, `name`, `desc`, `cooldown`)
