module main


import server_api
import groblon_utils
import groblon_core



fn main()
{
  server_api.server_init()
  // println(groblon_utils.get_default_note_dir())
  // println(groblon_utils.get_config_dir())
  
  // groblon_utils.setup()
  
  /*
  notes := groblon_core.get_notes('/home/kiptunor/Documents/My Notes') or {
    eprintln(err)
    return
  }
  
  for note in notes {
    println("${note.f_path_name}")
  }
  */
}
