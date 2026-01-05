module main

import net.http
import json
import log
import groblon_core




__global (
  http_log &log.ThreadSafeLog
)

struct HttpHandler {}

struct MsgRequest
{
  msg string
}

struct CreateTableRequest
{
  file_path string
  type string
}

struct SaveNoteRequest
{
  file_path string
  content string
}

struct CreateNoteRequest
{
  file_path string
}

struct FileDeletionRequest
{
  file_path string
}

struct SaveTableRequest
{
  file_path string
  content string
}

struct MsgResponse
{
  status string
  msg    string
  data   []groblon_core.TextNote
  table_data []groblon_core.TableFile
}

struct MinMsgResponse
{
  status string
  msg    string
}

struct GetTablesResponse
{
  status string
  msg    string
  table_data []TableJson
}

struct GetNotesResponse
{
  status string
  msg    string
  notes  []NoteJson
}

struct GetPastebinsResponse
{
  status string
  msg    string
  pastebins []PastebinJson
}

struct ErrorResponse
{
  status            string
  error_description string
  expected_request  map[string]string 
  os_error          string
}


pub struct NoteJson
{
  pub:
    file_path string
    content  string
}

pub struct PastebinJson
{
  pub:
    file_path string
    content string
}

pub struct TableJson
{
  pub:
    file_path string
    content   string
    type      string
}


fn raw_files2_json_notes(files []groblon_core.TextFile) []NoteJson
{
  mut out := []NoteJson{}

  for file in files
  {
    out << NoteJson
    {
      file_path: file.f_path_name
      content:  file.text_content
    }
  }

  return out
}

fn raw_files2_json_tables(files []groblon_core.TextFile) []TableJson
{
  mut out := []TableJson{}

  for file in files
  {
    out << TableJson
    {
      file_path: file.f_path_name
      content:  file.text_content
      type: '' // Empty for now
    }
  }

  return out
}

fn raw_files2_json_pastebins(files []groblon_core.TextFile) []PastebinJson
{
  mut out := []PastebinJson{}

  for file in files
  {
    out << PastebinJson
    {
      file_path: file.f_path_name
      content:  file.text_content
    }
  }

  return out
}

fn tables_to_json(tables []groblon_core.TableFile) []TableJson
{
  mut out := []TableJson{}

  for table in tables
  {
    out << TableJson
    {
      file_path: table.f_path_name
      content:  table.table_content
      type:     ''
    }
  }

  return out
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
        resp := MinMsgResponse
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
        data := json.decode(CreateNoteRequest, req.data) or
        {
          http_log.error('failed to \x1b[38;5;45m/create_note\x1b[0m. Invalid JSON received')
          err_resp := ErrorResponse
          {
            status: 'error'
            error_description: 'Invalid JSON while attempting to create a note'
            expected_request:
            {
              'file_path': 'path/to/file.txt'
            }
            os_error: ''
          }
          return http.Response
          {
            status_code: 400
            body: json.encode(err_resp)
            header: cors_headers()
          }
        }

        http_log.info('Creating note: $data.file_path')
        groblon_core.create_note(groblon_core.get_default_note_dir() + "/" + data.file_path) or
        {
          http_log.error('failed to \x1b[38;5;45m/create_note\x1b[0m. Invalid JSON received')
          err_resp := ErrorResponse
          {
            status: 'error'
            error_description: 'Failed to create note'
            os_error: '$err'
          }
          return http.Response
          {
            status_code: 400
            body: json.encode(err_resp)
            header: cors_headers()
          }
        }
        resp := MinMsgResponse
        {
          status: 'ok'
          msg: 'Note created: $data.file_path'
        }
          return http.Response
          {
            status_code: 200
            body: json.encode(resp)
            header: cors_headers()
          }
      }
      '/delete_file'
      {
        /*
        Delete / remove an exisisting note (deleting a file)
        */
        data := json.decode(FileDeletionRequest, req.data) or
        {
          http_log.error('failed to \x1b[38;5;45m/delete_file\x1b[0m. Invalid JSON received')
          
          err_resp := ErrorResponse
          {
            status: 'error'
            error_description: 'Invalid JSON received'
            expected_request:
            {
              'file_path': 'path/to/file.txt'
            }
          }
          
          return http.Response
          {
            status_code: 400
            body: json.encode(err_resp)
            header: cors_headers()
          }
        }
      
        //println('Deleting note: $data.msg')
        http_log.info("Received request: \x1b[38;5;45m/delete_file\x1b[0m :: $data.file_path")
        
        groblon_core.delete_file(data.file_path) or
        {
          err_resp := ErrorResponse
          {
            status: 'error'
            error_description: 'Failed to delete file'
            os_error: '$err'
          }
          
          return http.Response
          {
            status_code: 500
            body: json.encode(err_resp)
            header: cors_headers()
          }
        }
        
        resp := MinMsgResponse
        {
          status: 'ok'
          msg: 'File deleted: $data.file_path'
        }
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/get_note_list'
      {
        /*
        Return JSON object array of each note existing in /home/<user>/Documents/MyNotes
        */
        
        // println("Request: $req")
        
        http_log.info("Received request: \x1b[38;5;45m/get_note_contents\x1b[0m")
        
        // Use default note directory for now
        raw_notes := groblon_core.get_text_file_contents(groblon_core.get_default_note_dir()) or
        {
          http_log.error('failed to \x1b[38;5;45m/get_note_contents\x1b[0m. $err')
          
          err_res := ErrorResponse
          {
            status: 'error'
            error_description: 'Failed to read notes directory'
            os_error: '$err'
          }
          
          return http.Response
          {
            status_code: 400
            body: json.encode(err_res)
            header: cors_headers()
          }
        }
        
        json_notes := raw_files2_json_notes(raw_notes)
        
        resp := GetNotesResponse
        {
          status: 'ok'
          msg: 'Operation successful'
          notes: json_notes
        }
        
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/write_text_file'
      {
        /*
        Write / overwrite an entire file with the received contents
        */
        data := json.decode(SaveNoteRequest, req.data) or
        {
          http_log.error('failed to \x1b[38;5;45m/write_text_file\x1b[0m. Invalid JSON received')
          
          err_res := ErrorResponse
          {
            status: 'error'
            error_description: 'Invalid JSON while writing note'
            expected_request:
            {
              'file_path': 'path/to/file',
              'content': 'plain text content'
            }
          }
          
          return http.Response
          {
            status_code: 400
            body: json.encode(err_res)
            header: cors_headers()
          }
        }
        
        // http_log.info('Writing note: $data')
        
        http_log.info('Received request: \x1b[38;5;45m/write_text_file\x1b[0m')
        
        note := groblon_core.TextNote
        {
          f_path_name: data.file_path
          text_content: data.content
        }
        
        groblon_core.save_note(note) or
        {
          err_res := ErrorResponse
          {
            status: 'error'
            error_description: 'Failed to write note'
            os_error: '$err'
          }
          
          return http.Response
          {
            status_code: 500
            body: json.encode(err_res)
            header: cors_headers()
          }
        }
        
        resp := MinMsgResponse
        {
          status: 'ok'
          msg: 'Received content: $data.file_path'
        }
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/create_table' 
      {
        /*
        Create a new CSV table
        */
        data := json.decode(CreateTableRequest, req.data) or
        {
          http_log.error('failed to \x1b[38;5;45m/create_table\x1b[0m. Invalid JSON received')
          err_resp := ErrorResponse
          {
            status: 'error'
            error_description: 'Invalid JSON while attempting to create table'
            expected_request:
            {
              'file_path': 'path/to/tableFile'
              'type': 'csv / json'
            }
          }
          return http.Response
          {
            status_code: 400
            body: json.encode(err_resp)
            header: cors_headers()
          }
        }

        http_log.info('Creating table: $data.file_path')
        groblon_core.create_table(groblon_core.get_default_table_dir() + "/" + data.file_path)
        resp := MinMsgResponse
        {
          status: 'ok'
          msg: 'Table created: $data.file_path'
        }
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/get_table_list'
      {
        /*
        Return JSON object array of each note existing in /home/<user>/Documents/MyNotes
        */
        
        // println("Request: $req")
        
        http_log.info("Received request: \x1b[38;5;45m/get_table_contents\x1b[0m")
        
        // Use default note directory for now
        // println("Table files: ${groblon_core.get_tables(groblon_utils.get_default_table_dir())}")
        raw_tables := groblon_core.get_tables(groblon_core.get_default_table_dir()) or
        {
          http_log.error('failed to \x1b[38;5;45m/get_table_contents\x1b[0m. $err')
          
          err_res := ErrorResponse
          {
            status: 'error'
            error_description: 'Failed to read table directory'
            os_error: '$err'
          }
          
          return http.Response
          {
            status_code: 400
            body: json.encode(err_res)
            header: cors_headers()
          }
        }
        
        tables := tables_to_json(raw_tables)
        
        resp := GetTablesResponse
        {
          status: 'ok'
          msg: 'Operation successful'
          table_data: tables
        }
        
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/create_pastebin'
      {
        data := json.decode(CreateNoteRequest, req.data) or
        {
          http_log.error('failed to \x1b[38;5;45m/pastebin_create_file\x1b[0m. Invalid JSON received')
          err_resp := ErrorResponse
          {
            status: 'error'
            error_description: 'Invalid JSON while attempting to create pastebin file'
            expected_request:
            {
              'file_path': 'path/to/file.txt'
            }
            os_error: ''
          }
          return http.Response
          {
            status_code: 400
            body: json.encode(err_resp)
            header: cors_headers()
          }
        }

        http_log.info('Creating pastebin: $data.file_path')
        groblon_core.create_file(groblon_core.get_default_pastebin_dir() + "/" + data.file_path) or
        {
          http_log.error('failed to \x1b[38;5;45m/pastebin_create_file\x1b[0m. Invalid JSON received')
          err_resp := ErrorResponse
          {
            status: 'error'
            error_description: 'Failed to create pastebin file'
            os_error: '$err'
          }
          return http.Response
          {
            status_code: 400
            body: json.encode(err_resp)
            header: cors_headers()
          }
        }
        resp := MinMsgResponse
        {
          status: 'ok'
          msg: 'Pastebin file created: $data.file_path'
        }
          return http.Response
          {
            status_code: 200
            body: json.encode(resp)
            header: cors_headers()
          }
      }
      '/get_pastebin_list'
      {
        http_log.info("Received request: \x1b[38;5;45m/get_pastebin_list\x1b[0m")
        
        raw_files := groblon_core.get_text_file_contents(groblon_core.get_default_pastebin_dir()) or
        {
          http_log.error('failed to \x1b[38;5;45m/get_pastebin_list\x1b[0m. $err')
          
          err_res := ErrorResponse
          {
            status: 'error'
            error_description: 'Failed to read pastebin directory'
            os_error: '$err'
          }
          
          return http.Response
          {
            status_code: 400
            body: json.encode(err_res)
            header: cors_headers()
          }
        }
        
        json_pastebins := raw_files2_json_pastebins(raw_files)
        
        resp := GetPastebinsResponse
        {
          status: 'ok'
          msg: 'Operation successful'
          pastebins: json_pastebins
        }
        
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/get_settings'
      {
        /*
        Get the server settings (Locally stored)
        */
        
        println("Request: $req")
        
        // Todo: JSON struct required
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
      '/save_settings'
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
            body: '{"status":"error",\n"msg":"Invalid JSON while saving server settings"}'
            header: cors_headers()
          }
        }
        
        http_log.info('Saving settings: $data.msg')
        resp := MinMsgResponse
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


fn server_init()
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