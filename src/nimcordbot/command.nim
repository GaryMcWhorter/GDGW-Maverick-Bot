import constructor/construct
import std/[
  tables,
  options
]
export tables
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

proc invoke*(c: Command, msg: string) =
  c.command(msg)

var compTimeComTable*{.compileTime.} = initTable[string, Command]()
proc addCommand*(c: Command){.compileTime.} =
  echo c
  for prefix in c.prefix:
    compTimeComTable[prefix] = c