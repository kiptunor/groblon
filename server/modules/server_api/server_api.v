module server_api

import net.http
import json




struct HttpHandler {}

struct MsgRequest
{
  msg string
}

struct MsgResponse
{
  status string
  msg    string
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
        resp := MsgResponse
        {
          status: 'ok'
          msg: 'Grobly! :D'
        }
        println("Request received")
        return http.Response
        {
          status_code: 200
          body: json.encode(resp)
          header: cors_headers()
        }
      }
      '/create_note' 
      {
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