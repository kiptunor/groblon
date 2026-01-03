import axios, { type AxiosInstance } from 'axios'




const server_url = import.meta.env.VITE_API_URL


interface AddRequest {
  a: number
  b: number
}

interface AddResponse {
  result: number
}

interface PostResponse {
  server_reply: string
  echo: string
}

type Note = {
  filename: string
  content: string
}

type Table = {
  filename: string
  content: string
  type: string
}


export class GroblonServer {
  private api: AxiosInstance

  constructor(baseURL: string) {
    this.api = axios.create({
      baseURL,
      headers: { 'Content-Type': 'application/json' },
      timeout: 5000,
    })
  }


  async check_default(): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/check_server', {})
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }

  async create_note(name: string): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/create_note', { 
        file_path: name 
      })
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }

  async delete_file(file: string): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/delete_file', { file_path: file })
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }

  async get_notes(): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/get_note_contents', {})
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }
  
  async save_text_file(note: Note): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/write_text_file',
        {
          file_path: note.filename,
          content: note.content
        })
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }
  
  async create_table(name: string): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/create_table', { 
        file_path: name,
        type: ''
      })
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }
  
  async get_tables(): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/get_table_contents', {})
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }
  
  async delete_table(name: string): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/delete_table', { msg: name })
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }
  
  async save_table(table: Table): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/write_table',
      {
        file_path: table.filename,
        content: table.content
      })
      console.log(res)
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }
}

export const server = new GroblonServer(server_url)
// export const server = new ServerAPI();
export type { Note, PostResponse }