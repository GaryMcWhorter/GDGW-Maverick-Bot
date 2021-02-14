import std/[
  asyncdispatch,
  httpclient,
  options
]

import
  config

let
  DB_URL: string = Config.database.url
  DB_AUTH: string = Config.database.auth
  client = newAsyncHttpClient()

proc post*(jbody: string): Future[Option[string]] {.async.} =
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "Authorization": DB_AUTH
  })
  let res = await client.request(DB_URL, httpMethod = HttpPost, body = jbody)
  if res.code.is2xx:
    return some await res.body
  else:
    return none(string)

proc toUid*(discordId: string): string =
  return 'u' & discordId

proc sql*(query: string): string =
  return """{"operation":"sql","sql":"""" & query & "\"}"

proc insert*(schema: string, table: string, records: string): string =
  return """{"operation":"insert","schema":"""" & schema & """","table":"""" &
      table & """","records":""" & records & "}"

proc upsert*(schema: string, table: string, records: string): string =
  return """{"operation":"upsert","schema":"""" & schema & """","table":"""" &
      table & """","records":""" & records & "}"

proc update*(schema: string, table: string, records: string): string =
  return """{"operation":"update","schema":"""" & schema & """","table":"""" &
      table & """","records":""" & records & "}"

proc delete*(schema: string, table: string, hash_values: openArray[
    string]): string =
  return """{"operation":"delete","schema":"""" & schema & """","table":"""" &
      table & """","hash_values":""" & $hash_values & "}"


