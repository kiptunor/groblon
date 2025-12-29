module groblon_core

import os
import log
import encoding.csv



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

pub struct TableFile
{
  pub:
    f_path_name string @[required] // The file path and the name
    //mut color := Color
    table_content string
}



pub fn create_note(n string)
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
          text_content: os.read_file(full_path) or { '' }
        }
      }
    }
  
  return notes
}

pub fn save_note(note TextNote)
{
  os.write_file(note.f_path_name, note.text_content) or
  {
    log.error('save_note() failed: $err')
    return
  }
}

pub fn delete_note(file_path string)
{
  if os.exists(file_path) && os.is_file(file_path)
  {
    os.rm(file_path) or
    {
      log.error('delete_note() -> os.rm() failed: $err')
      return
    }
  }
  else
  {
    log.error('delete_note() failed: File does not exist')
  }
}

pub fn get_note_info(note TextNote)
{
  //Todo (Requires a struct)
}

pub fn create_table(n string)
{
  // Only CSV is currently supported
  
  
  if !os.exists(n + '.csv')
  {
    os.write_file(n + '.csv', '') or {
      log.error('Table Creation Error: $err')
    }
  }
  else
  {
    log.error('Table Creation Error: ${n} already exists')
  }
}

pub fn get_tables(dir_path string) ![]TableFile
{
  mut tables := []TableFile{}
  
  entries := os.ls(dir_path)!
  
    for entry in entries
    {
      full_path := os.join_path(dir_path, entry)
  
      if os.is_file(full_path)
      {
        //println('full_path: ${full_path}')
        tables << TableFile
        {
          f_path_name: full_path
          //text_content: os.read_file(full_path) or { '' } // Todo: Read the file content
          table_content: os.read_file(full_path) or { '' }
        }
      }
    }
  
  return tables
}

pub fn delete_table(file_path string)
{
  if os.exists(file_path) && os.is_file(file_path)
  {
    os.rm(file_path) or
    {
      log.error('delete_table() -> os.rm() failed: $err')
      return
    }
  }
  else
  {
    log.error('delete_table() failed: File does not exist')
  }
}

pub fn save_table(table TableFile)
{
  os.write_file(table.f_path_name, table.table_content) or
  {
    log.error('save_table() failed: $err')
    return
  }
}