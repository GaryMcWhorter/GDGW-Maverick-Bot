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
