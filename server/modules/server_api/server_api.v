module server_api

import net.http
import json
import log
import groblon_utils
import groblon_core


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


//http_log := log.Log{}
__global (
    http_log &log.ThreadSafeLog
)

struct HttpHandler {}

struct MsgRequest
{
  msg string
}

struct SaveNoteRequest
{
  msg string
  current_note groblon_core.TextNote
}

struct MsgResponse
{
  status string
  msg    string
  data   []groblon_core.TextNote
}

pub struct NoteJson
{
  pub:
    filename string
    content  string
}


fn notes_to_json(notes []groblon_core.TextNote) string
{
  mut out := []NoteJson{}

  for note in notes
  {
    out << NoteJson
    {
      filename: note.f_path_name
      content:  note.text_content
    }
  }

  return json.encode(out)
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
  
  http_log = log.new_thread_safe_log()
  http_log.set_level(.info)
      
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
        http_log.info("Server check requested")
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
          http_log.error('failed to \x1b[38;5;45m/create_note\x1b[0m. Invalid JSON received')
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON while attempting to create a note"}'
            header: cors_headers()
          }
        }

        http_log.info('Creating note: $data.msg')
        groblon_core.create_new_note(groblon_utils.get_default_note_dir() + "/" + data.msg)
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
          http_log.error('failed to \x1b[38;5;45m/delete_note\x1b[0m. Invalid JSON received')
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
        
        // println("Request: $req")
        
        http_log.info("Received request: \x1b[38;5;45m/get_note_contents\x1b[0m")
        
        // Use default note directory for now
        notes := groblon_core.get_notes(groblon_utils.get_default_note_dir()) or
        {
          http_log.error('failed to \x1b[38;5;45m/get_note_contents\x1b[0m. $err')
          
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Failed to read notes directory", "errorDescription":"$err"}'
            header: cors_headers()
          }
        }
        
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Operation successful'
          data: notes
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
        data := json.decode(SaveNoteRequest, req.data) or
        {
          http_log.error('failed to \x1b[38;5;45m/write_note\x1b[0m. Invalid JSON received')
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON while writing note"}'
            header: cors_headers()
          }
        }
        
        // http_log.info('Writing note: $data')
        
        http_log.info('Received request: \x1b[38;5;45m/write_note\x1b[0m')
        
        note := groblon_core.TextNote
        {
          f_path_name: data.current_note.f_path_name
          text_content: data.current_note.text_content
        }
        
        groblon_core.save_note(note)
        
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
          http_log.error('failed to \x1b[38;5;45m/append_note\x1b[0m. Invalid JSON received')
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON while appending note"}'
            header: cors_headers()
          }
        }
        
        http_log.info('Appending note: $data.msg')
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
          http_log.error('failed to /save_server_settings. Invalid JSON received')
          return http.Response
          {
            status_code: 400
            body: '{"status":"error","msg":"Invalid JSON while saving server settings"}'
            header: cors_headers()
          }
        }
        
        http_log.info('Saving settings: $data.msg')
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
        http_log.error('Endpoint not found')
        return http.Response
        {
          status_code: 404
          body: '{"status":"error","msg":"Endpoint not found"}'
          header: cors_headers()
        }
      }
    }
  }

  http_log.error('Invalid request method. Use POST method instead')
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