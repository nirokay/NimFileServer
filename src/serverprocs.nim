import std/[os, strutils, json]

type FileSystemObject = object
    name*, `type`*, fullpath*: string


proc message*(message: string): string =
    return "{\"message\":\"" & message & "\"}"

proc readFilesystem*(path: string): string =
    let seperator: char = block:
        if defined(windows): '\\'
        else: '/'
    var items: seq[FileSystemObject]
    for item in path.walkDir():
        items.add(FileSystemObject(
            name: item.path.tailDir().split(seperator)[^1],
            fullpath: item.path,
            `type`: case item.kind:
                of pcDir: "directory"
                of pcFile: "file"
                of pcLinkToDir: "directory-link"
                of pcLinkToFile: "file-link"
        ))
    return $(%items)


proc readFileContents*(path: string): string =
    return "{\"file-content\":" & $(%path.readFile()) & "}"
