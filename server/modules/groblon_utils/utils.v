module groblon_utils

enum NoteType as u8
{
  plain,    // Simple text note
  markdown, // Markdown formatted text note
  table     // CSV formatted table note
}

struct TextNote
{
  f_path_name string @[required] // The file path and the name
  mut color := Color
  text_content string
}



pub fn create_new_note(n TextNote)
{
  // Todo
}
