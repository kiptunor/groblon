module main



struct Config
{
  // Config fields soon
  server_port u16
  notes_directory string
  mut:
    media_dirs  []string
  http_logging bool
}

pub fn load_config()
{
  /*
  Todo:
  - Check for default directory "/home/user/.config/groblon-server". If not exsistent create it
  - Check for config file "/home/user/.config/groblon-server/config.json". If not found use default config
  
  // Just a sample config
  result Config {
    server_port: 8080,
    notes_directory: "/home/user/notes",
    media_dirs: ["/home/user/media"],
    http_logging: true,
  }
  */
  // Load and return config structure
}

pub fn save_config(config Config)
{
  // Save config structure to file
}
