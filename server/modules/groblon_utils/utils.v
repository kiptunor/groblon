module groblon_utils

import os
import log





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