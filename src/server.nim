import std/[os, asyncdispatch, asynchttpserver, strformat]
import ./serverprocs

const serverPort: int = 42069

var server: AsyncHttpServer = newAsyncHttpServer()


proc serverRequestHandler*(request: Request) {.async, gcsafe.} =
    let
        responseHeaders: HttpHeaders = newHttpHeaders {"Content-type": "application/json; charset=utf-8"}
        directoryPath: string = request.url.path
        errorResponse: string = message "500: Internal Error"

    var response: string
    try:
        if directoryPath.dirExists():
            response = directoryPath.readFilesystem()
        elif directoryPath.fileExists():
            response = directoryPath.readFileContents()
        else:
            await request.respond(Http404, message "404: Destination Not Found", responseHeaders)
            return

        await request.respond(Http200, response, responseHeaders)

    except OSError:
        echo "Sent error (reading):\n\t"
        await request.respond(Http500, message errorResponse, responseHeaders)

    except CatchableError, Defect:
        echo "Sent error (unknown):\n\t" & errorResponse
        await request.respond(Http500, errorResponse, responseHeaders)


proc runServer*() {.async.} =
    server.listen(Port serverPort)
    echo &"Connect to: localhost:{uint16 server.getPort()}/"

    while true:
        if server.shouldAcceptRequest():
            await server.acceptRequest(serverRequestHandler)
        else:
            await sleepAsync(500)
