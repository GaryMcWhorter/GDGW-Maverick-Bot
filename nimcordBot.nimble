# Package

version       = "0.1.0"
author        = "GaryM-exkage"
description   = "A discord bot for the GDGW server"
license       = "MIT"
srcDir        = "src"
bin           = @["nimcordBot"]

# Set up paths
import os, strformat
let index     = srcDir / $bin[0]
let debug     = "bin/debug"
let release     = "bin/release"

task maked, "Makes the debug build":
  selfExec(&"c --outdir:{debug} {index}")

task make, "Makes the release build":
  selfExec(&"c -d:release --outdir:{release} {index}")

task startd, "Makes and runs the debug build":
  selfExec(&"c -r --outdir:{debug} {index}")

task start, "Makes and runs the release build":
  selfExec(&"c -r -d:release --outdir:{release} {index}")

# Dependencies

requires "nim >= 1.4.2"
requires "dimscord >= 1.2.5"
requires "constructor >= 0.1.0"
requires "timestamp >= 0.4.1"
requires "toml_serialization >= 0.1.0"
