# Groblon Server

This is where I'll learn the V programing language lol


# API Documentation

The server allows http requests only trough POST method.

## Endpoints
The API uses JSON format for requests and responses.  
All JSON keys **must follow the snake_case naming convention**.

### POST
`/check_server`
- Initial check of the server status



`/get_note_list`
Reads trough all provided directories and returns a JSON object array containing the full path to each note file along with the text content.  
Returned JSON:
```json
{
  "status": "ok",
  "msg": "Operation successful",
  "note_list":[
    {
      "file_path": "returned/path/to/text/file.txt",
      "content": "The entire content of the file"
    },
    {
      "file_path": "returned/path/to/text/file2.txt",
      "content": "Just another example\nwith multiline content\n"
    }
  ]
}
```

`/get_table_list`
This request only works with text based table formats:
  - CSV (Currently supported)
  - TSV
  - JSON

Same as getting the notes. The only difference is that it returns an additional key `type`.  
Returned JSON:
At the moment the `type` key is empty
```json
{
  "status": "ok",
  "msg": "Operation successful",
  "table_list":[
    {
      "file_path": "returned/path/registry.csv",
      "content": "table content",
      "type": "csv"
    },
    {
      "file_path": "returned/path/basic_table.csv",
      "content": "table content",
      "type": "csv"
    }
  ]
}
```

`/get_pastebin_list`

Once again, same way as getting the notes but for pastebins (source files)  
Returned JSON:
```json
{
  "status": "ok",
  "msg": "Operation successful",
  "pastebin_list":[
    {
      "file_path": "returned/path/to/pastebin/sample.cpp",
      "content": "#include <iostream>\n\nint main() {\n    std::cout << \"Hello, World!\" << std::endl;\n    return 0;\n}"
    },
    {
      "file_path": "returned/path/to/pastebin/sample.c",
      "content": "#include <stdio.h>\n\nint main() {\n    printf(\"Hello, World!\");\n    return 0;\n}"
    }
  ]
}
```



`/write_text_file`
This request is common for saving notes, tables in text formats, and pastebins  
JSON Structure:
```json
{
  "file_path": "path/to/text_file.txt",
  "content": "Some text content here"
}
```

`/delete_file`
Also a common http request for deleting, notes, tables and pastebins (Source files).  
JSON Structure:
```json
{
  "file_path": "path/to/file.txt"
}
```


> [!NOTE]
> At the moment table saving is done trough CSV  
> From the web application each table created has 50 rows and 50 columns by default.  
> Each CSV cell is still written **even when empty**. So the resulted CSV content looks like this:  
> ```
> Cell value1,Cell value2,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
> On rows,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
> ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
> ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
> ```
> 
> This happens because of how [HandsOnTable](https://github.com/handsontable/handsontable) exports CSV string

`/create_note`  
`/create_pastebin`
Creates a an empty file at the specified path.  
JSON Structure:
```json
{
  "file_path": "path/to/file.txt"
}
```

`/create_table`
Creates a an empty csv file  
JSON Structure:
```json
{
  "file_path": "path/to/file.txt",
  "type": "csv"
}
```
