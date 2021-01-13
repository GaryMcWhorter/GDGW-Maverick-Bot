import macros, os

macro importCommands*(): untyped =
  var bracket  = newNimNode(nnkBracket)
  for x in walkDir("./src/nimcordbot/command", true):
    if(x.kind == pcFile):
      let split = x.path.splitFile()
      if(split.ext == ".nim"):
        bracket.add ident(split.name)
  newStmtList(
    newNimNode(nnkImportStmt).add(
      newNimNode(nnkInfix).add(
        ident("/"),
        newNimNode(nnkPrefix).add(
          ident("/"),
          ident("command")
        ),
        bracket
      )
    )
  )

proc startsWith*(msg: string, prefix: string): bool =
    if msg.len == 0 or msg.len <= prefix.len:
        return false
    for i in 0 ..< prefix.len:
        if prefix[i] != msg[i]:
            return false
    return true

proc getCommandInfo*(msg, prefix: string): (string, string) =
  var i = prefix.len
  while i < msg.len:
    if msg[i] == ' ':
      break
    inc i
  (msg[prefix.len..(i - 1)], msg[(i + 1)..^1])