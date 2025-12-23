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
      const res = await this.api.post<PostResponse>('/create_note', { msg: name })
      return res.data
    }
    catch (err) {
      console.error('Request failed:', err)
      return null
    }
  }

  async delete_note(name: string): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/delete_note', { msg: name })
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
  
  async save_note(note: Note): Promise<PostResponse> {
    try {
      const res = await this.api.post<PostResponse>('/write_note',
        {
          msg: 'From Groblon webapp', // I think this is optional dosen't seem to be that useful lol
          current_note:
          {
            f_path_name: note.filename,
            text_content: note.content
          }
        })
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