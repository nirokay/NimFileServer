import std/[asyncdispatch]
import ./server

waitFor runServer()
