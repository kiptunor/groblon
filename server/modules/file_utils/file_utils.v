module file_utils


import os
import time






pub fn is_file_changed(file_name string, mut last_mod)
{
  mut last_mod := os.file_last_mod_time(file_name)
  
  time.sleep(500 * time.millisecond)
  curr_mod := os.file_last_mod_time(file_path)
  if curr_mod != last_mod
  {
    println('File changed!')
    return true
    last_mod = curr_mod
  }
}

pub fn create_empty_file(file_name string)
{
  // Todo
}

pub fn delete_file(file_name string)
{
  // Todo
}
