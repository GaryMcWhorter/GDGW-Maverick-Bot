import std/[
    asyncdispatch,
    httpclient,
    json,
    options,
    os,
    uri
]

let
  DB_URL: string = getEnv("DB_URL")
  DB_AUTH: string = getEnv("DB_AUTH")
  client = newAsyncHttpClient()

proc post*(jbody: string): Future[Option[string]] {.async.} =
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "Authorization": DB_AUTH
  })
  let res = await client.request(DB_URL,
      httpMethod = HttpPost, body = jbody)
  if res.code.is2xx:
    return some await res.body
  else:
    return none(string)

proc toUid*(discordId: string): string =
  return 'u' & discordId

proc sql*(query: string): string =
  return """{"operation":"sql","sql":"""" & query & "\"}"

proc upsert*(schema: string, table: string, records: string): string =
  return """{"operation":"upsert","schema":"""" & schema & """","table":"""" &
      table & """","records":""" & records & "}"


