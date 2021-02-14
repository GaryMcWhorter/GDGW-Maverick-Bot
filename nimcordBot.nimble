# Package

version       = "0.1.0"
author        = "GaryM-exkage"
description   = "A discord bot for the GDGW server"
license       = "MIT"
srcDir        = "src"
bin           = @["nimcordBot"]

# Set up paths and Tasks
import os, strformat
let filename  = $bin[0]
let index     = srcDir / filename
let debug     = "bin/debug"
let release   = "bin/release"

task maked, "Makes the debug build":
  selfExec(&"c --outdir:{debug} {index}")

task make, "Makes the release build":
  selfExec(&"c -d:release --outdir:{release} {index}")

task startd, "Makes and runs the debug build":
  makedTask()
  exec debug / filename

task start, "Makes and runs the release build":
  makeTask()
  exec release / filename

# Dependencies

requires "nim >= 1.4.2"
requires "dimscord >= 1.2.5"
requires "constructor >= 0.1.0"
requires "timestamp >= 0.4.1"
requires "toml_serialization >= 0.1.0"
