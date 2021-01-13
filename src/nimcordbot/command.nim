import constructor/construct
import std/[
  tables,
  options
]

{.experimental: "dotOperators".}

type Command = object
  name, description: string
  prefix: seq[string]
  command: proc(msg: string)
  cooldown: int

Command.construct(true):
  name: required
  command: required
  description: ""
  prefix: @[]
  cooldown: 1

proc `.()`*(c: Command, msg: string) =
  c.command(msg)

var compTimeComTable{.compileTime.} = initTable[string, Command]()
const commandTable = static compTimeComTable

proc addCommand*(c: Command){.compileTime.} =
  for prefix in c.prefix:
    compTimeComTable[prefix] = c

proc getCommand*(prefix: string): Option[Command] =
  if prefix in commandTable:
    some(commandTable[prefix])
  else:
    none(Command)