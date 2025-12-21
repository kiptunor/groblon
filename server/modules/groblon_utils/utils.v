module groblon_utils

import os
import log




enum NoteType as u8
{
  plain    // Simple text note
  markdown // Markdown formatted text note
  table     // CSV formatted table note
}

struct TextNote
{
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


pub fn get_default_note_dir() string
{
  home_dir := os.home_dir()
  mut full_path := ""
  if os.exists(home_dir + "/Documents") && os.is_dir(home_dir + "/Documents")
  {
    full_path = home_dir + "/Documents/My Notes"
  }
  else
  {
    log.error('"\x1b[38;5;142m${home_dir + "/Documents"}\x1b[0m" directory does NOT exist')
  }
  return full_path
}

pub fn get_config_dir() string
{
  home_dir := os.home_dir()
  mut full_path := ""
  if os.exists(home_dir + "/.config") && os.is_dir(home_dir + "/.config")
  {
    full_path = home_dir + "/.config/groblon-server"
  }
  else
  {
    log.error('"\x1b[38;5;142m${home_dir + "/.config"}\x1b[0m" directory does NOT exist')
  }
  return full_path
}

pub fn setup()
{
  /*
  - Use loaded settings
  - Check for default directories
  */
  
  if !os.exists(get_default_note_dir())
  {
    log.debug('Creating default note directory...')
    os.mkdir(get_default_note_dir()) or 
    {
      log.error('Error creating default note directory: $err')
    }
  }
}