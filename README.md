# config

My personal configuration files for development tools.

## Contents

- `.tmux.conf`: Configuration for tmux terminal multiplexer
- `alacritty.toml`: Configuration for Alacritty terminal emulator
- More configurations may be added in the future

## Usage

### tmux Configuration

1. Copy `.tmux.conf` to your home directory:
   ```
   cp .tmux.conf ~/.tmux.conf
   ```
2. Restart tmux or reload the configuration with:
   ```
   tmux source-file ~/.tmux.conf
   ```

### Alacritty Configuration

1. Copy `alacritty.toml` to your Alacritty configuration directory:
   ```
   # For macOS
   cp alacritty.toml ~/.config/alacritty/alacritty.toml
   
   # For Linux
   cp alacritty.toml ~/.config/alacritty/alacritty.toml
   
   # For Windows
   cp alacritty.toml %APPDATA%\alacritty\alacritty.toml
   ```
2. Restart Alacritty to apply the changes

