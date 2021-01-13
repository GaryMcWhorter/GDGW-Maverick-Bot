import anonimongo
import std/[
    os,
    strformat
]

proc mongoInit*(): Mongo =
    var DB_USER = getenv("DB_USER")
    var DB_PASS = getenv("DB_PASS")
    let dbName = "users"
    let connectToAtlas = fmt"mongodb+srv://{DB_USER}:{DB_PASS}@cluster0.3nrqa.mongodb.net/{dbName}?retryWrites=true&w=majority"

    var mongo = newMongo(MongoUri connectToAtlas)
    if not waitfor mongo.connect:
        quit "Cannot connect to db"
    echo "mongo successfully connected"

    return mongo

export close
