import std/[asyncdispatch]
import ./server

when isMainModule:
    waitFor runServer()
