import command

command:
  name: parse
  description: "Test parser"
  args:
    someFloat: float
    someInt: int
    someBool: bool
    someString: string
  body:
    if someBool:
      for x in 0..<someInt:
        sendMessage($someFloat)
    else:
      sendMessage(someString)
