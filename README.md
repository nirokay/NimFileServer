# NimFileServer

## About

A simple http server, that lists the filesystem in form of `application/json` content type.

Is this useful? No. Is it cool? Kinda, i guess...

This has been my first server written ever, so it was a great exercise! :)

## Requests

A request looks ike this: `[Server IP]/[Path to directory/file]` (example: `[Server IP]/home/myusername/Documents/`)

## Respond format

### Successful requests

You will get an array of objects, if you specified a correct path.

For example: `curl localhost:42069/home/testUser/`

```json
[
    {
        "fullpath" : "/home/testUser/document.txt",
        "name" : "document.txt",
        "type" : "file"
    },
    {
        "fullpath" : "/home/testUser/link_to_document.txt",
        "name" : "link_to_document.txt",
        "type" : "file-link"
    },
    {
        "fullpath" : "/home/testUser/directory_for_stuff",
        "name" : "directory_for_stuff",
        "type" : "directory"
    },
    {
        "fullpath" : "/home/testUser/link_to_a_directory",
        "name" : "link_to_a_directory",
        "type" : "directory-link"
    }
]
```

If you request the path of a file, you will get its content.

For example: `curl localhost:42069/home/testUser/document.txt`

```json
{
    "file-content": "This is a document!\nSome text is written here."
}
```

### Invalid requests

#### Path does not exist

For example: `curl localhost:42069/home/testUser/directory/that/does/not/exist/`

```json
{
    "message" : "404: Destination Not Found"
}
```

#### Internal errors

On the *slight* possibility, that my code is not amazing and breaks, the server will return an error message:

```json
{
    "message": "500: Internal Error"
}
```
