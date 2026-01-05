module groblon_core

import os
import log
import encoding.csv




enum TableType as u8
{
  json
  csv
  tsv
  xlsx
}

pub struct TextNote
{
  pub:
    f_path_name string @[required] // The file path and the name
    text_content string
}

pub struct TableFile
{
  pub:
    f_path_name string @[required] // The file path and the name
    table_content string
    table_type TableType
}

pub struct TextFile
{
pub:
  f_path_name string @[required] // The file path and the name
  text_content string
}



pub fn create_note(n string)!
{
  if os.exists(n)
  {
    return error('note already exists: $n')
  }
 
  os.write_file(n, '')!
}

pub fn create_file(f string)!
{
  if os.exists(f)
  {
    return error('file already exists: $f')
  }
 
  os.write_file(f, '')!
}

pub fn save_note(note TextNote)!
{
  os.write_file(note.f_path_name, note.text_content)!
}

pub fn delete_file(file_path string)!
{
  if !os.exists(file_path)
  {
    return error('file does not exist')
  }
  
  if !os.is_file(file_path)
  {
    return error('path is not a file')
  }
  
  os.rm(file_path)!
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
      tables << TableFile
      {
        f_path_name: full_path
        table_content: os.read_file(full_path) or { '' }
      }
    }
  }
  
  return tables
}

pub fn get_text_file_contents(dir_path string) ![]TextFile
{
  mut text_files := []TextFile{}
  
  entries := os.ls(dir_path)!
  
  for entry in entries
  {
    full_path := os.join_path(dir_path, entry)

    if os.is_file(full_path)
    {
      text_files << TextFile
      {
        f_path_name: full_path
        text_content: os.read_file(full_path) or { '' }
      }
    }
  }
  
  return text_files
}