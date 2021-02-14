import
  toml_serialization

type
  Database = object
    url*: string
    auth*: string

  Bot = object
    token*: string

  Prefs = object
    prefix*: string
    expCooldown*: int

  ConfigBase = object
    database*: Database
    bot*: Bot
    prefs*: Prefs

var rawToml = readFile("config.toml")
var Config* = Toml.decode(rawToml, ConfigBase)

proc reload*(cfg: ConfigBase) =
  rawToml = readFile("config.toml")
  Config = Toml.decode(rawToml, ConfigBase)
  echo Config.prefs.prefix
