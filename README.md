# Installation
```
mkdir ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << eof
[data]
      global_theme = "dark"
      write_theme = "#f1efef"
      color1 = "#0d54b2"
      color2 = "#287def"
      color3 = "#66a7fc"
      alacritty_opacity = "1"
eof
chezmoi init --apply fadri14
```

