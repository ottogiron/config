# config

My personal configuration files for development tools.

## Contents

- `.tmux.conf`: Configuration for tmux terminal multiplexer
- `alacritty.toml`: Configuration for Alacritty terminal emulator
- More configurations may be added in the future

## Usage

### tmux Configuration

1. Install TPM

    ```git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm```

2. Copy `.tmux.conf` to your home directory:
   ```
   cp .tmux.conf ~/.tmux.conf
   ```
3. Restart tmux or reload the configuration with:
   ```
   tmux source-file ~/.tmux.conf
   ```
4. Install plugins
    
    ```sh
        # Inside a tmux session, press:```
        # prefix + I (capital i)
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

