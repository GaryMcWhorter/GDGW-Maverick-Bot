# Package

version       = "0.1.0"
author        = "GaryM-exkage"
description   = "A discord bot for the GDGW server"
license       = "MIT"
srcDir        = "src"
bin           = @["nimcordBot"]


# Dependencies

requires "nim >= 1.4.2"
requires "dimscord >= 1.2.5"
requires "constructor >= 0.1.0"
requires "timestamp >= 0.4.1"
requires "toml_serialization >= 0.1.0"

task maked, "Makes the debug build":
  switch("out", "bin/maverickbot")
  selfExec("c ./src/nimcordBot")
