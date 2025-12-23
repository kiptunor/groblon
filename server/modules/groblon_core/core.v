module groblon_core

import os
import log



enum NoteType as u8
{
  plain    // Simple text note
  markdown // Markdown formatted text note
  table     // CSV formatted table note
}

pub struct TextNote
{
  pub:
    f_path_name string @[required] // The file path and the name
    //mut color := Color
    text_content string
}



pub fn create_new_note(n string)
{
  // Necessary checking since os.write_file can't check if a file exist before creating it
  if !os.exists(n)
  {
    os.write_file(n, '') or {
      log.error('Note Creation Error: $err')
    }
  }
  else
  {
    log.error('Note Creation Error: ${n} already exists')
  }
}

pub fn get_notes(dir_path string) ![]TextNote
{
  mut notes := []TextNote{}
  
  entries := os.ls(dir_path)!
  
    for entry in entries
    {
      full_path := os.join_path(dir_path, entry)
  
      if os.is_file(full_path)
      {
        notes << TextNote
        {
          f_path_name: full_path
          text_content: '' // Todo: Read the file content
        }
      }
    }
  
  return notes
}

pub fn save_note(note TextNote)
{
  //Todo
}

pub fn delete_note(note string)
{
  //Todo
}

pub fn get_note_info(note TextNote)
{
  //Todo (Requires a struct)
}
