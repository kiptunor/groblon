module server_api

import net.http
import json


/*
Note content data (JSON)
{
  "name": "Filename.txt"
  "contents": "All\nThe text that has been written into a file"
},
{
  "name": "Saved Links.txt"
  "contents": "Links"
}
*/

struct HttpHandler {}

struct MsgRequest
{
  msg string
}

struct MsgResponse
{
  status string
  msg    string
  data   string
}



// CORS helper
fn cors_headers() http.Header
{
  mut h := http.new_header()
  
  h.add(.access_control_allow_origin, '*')
  h.add(.access_control_allow_methods, 'POST, OPTIONS')
  h.add(.access_control_allow_headers, 'Content-Type')
  h.add(.content_type, 'application/json')
  
  return h
}


pub fn(mut h HttpHandler) handle(req http.Request) http.Response
{
  // Handle CORS preflight
  if req.method == .options
  {
    return http.Response
    {
      status_code: 200
      header: cors_headers()
    }
  }

  if req.method == .post
  {
    match req.url
    {
      '/check_server'
      {
        /*
        Required for checking for the official server
        */
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Grobly! :D'
        }
        println("Server checked")
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/create_note' 
      {
        /*
        Create a new note (creating a new empty file)
        Todo: Return error if:
        - Name is empty
        - Note already exists
        - It fails to create the file
        */
        data := json.decode(MsgRequest, req.data) or
        {
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON"}'
            header: cors_headers()
          }
        }

        println('Creating note: $data.msg')
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Note created: $data.msg'
        }
          return http.Response
          {
            status_code: 200
            body: json.encode(resp)
            header: cors_headers()
          }
      }
      '/delete_note' 
      {
        /*
        Delete / remove an exisisting note (deleting a file)
        */
        data := json.decode(MsgRequest, req.data) or
        {
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON"}'
            header: cors_headers()
          }
        }
      
        println('Deleting note: $data.msg')
        resp := MsgResponse{
          status: 'ok'
          msg: 'Note deleted: $data.msg'
        }
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/get_note_contents'
      {
        /*
        Return JSON object array of each note existing in /home/<user>/Documents/MyNotes
        */
        
        println("Request: $req")
        
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'All file contents passed'
          // data: 'Json struct' // Todo
        }
        
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/write_note'
      {
        /*
        Write / overwrite an entire file with the received contents
        */
        data := json.decode(MsgRequest, req.data) or
        {
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON"}'
            header: cors_headers()
          }
        }
        
        println('Writing note: $data.msg')
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Received content: $data.msg'
        }
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/append_note'
      {
        /*
        Append the new text lines to an existing text file
        */
        
        data := json.decode(MsgRequest, req.data) or
        {
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON"}'
            header: cors_headers()
          }
        }
        
        println('Appending note: $data.msg')
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Received content: $data.msg'
        }
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/refresh_note_list'
      {
        /*
        Refresh note list if new text file has been created manually
        */
        
        println("Request: $req")
        
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Refreshed note list'
          // data: 'Json struct' // Todo
        }
        
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/get_server_settings'
      {
        /*
        Get the server settings (Locally stored)
        */
        
        println("Request: $req")
        
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Passing server settings'
          // data: 'Json struct' // Todo
        }
        
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/save_server_settings'
      {
        /*
        Save server settings
        */
        
        data := json.decode(MsgRequest, req.data) or
        {
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON"}'
            header: cors_headers()
          }
        }
        
        println('Saving settings: $data.msg')
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Received content: $data.msg'
        }
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      else
      {
        return http.Response
        {
          status_code: 404
          body: '{"status":"error","msg":"Endpoint not found"}'
          header: cors_headers()
        }
      }
    }
  }

  return http.Response
  {
    status_code: 405
    body: '{"status":"error","msg":"Only POST allowed"}'
    header: cors_headers()
  }
}


pub fn server_init()
{
  mut server := http.Server
  {
    addr: ':8080'           // Listen on all interfaces
    handler: HttpHandler{}
    show_startup_message: true
  }

  println('Server running on http://0.0.0.0:8080')
  server.listen_and_serve()
}