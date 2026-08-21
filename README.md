# Installation
## Initialisation du fichier de chezmoi

```bash
mkdir ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << eof
[data]
      global_theme = "dark"
      write_theme = "#f1efef"
      color1 = "#0d54b2"
      color2 = "#287def"
      color3 = "#66a7fc"
      opacity = "1"
eof
```

## Changer le nom de l'hôte

Classique
```bash
sudo hostnamectl set-hostname mylinux
```

Avec NixOS
```bash
sed -i '$c\networking.hostName = "mynixos";}' /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

## Initialisation de chezmoi

Classique
```bash
chezmoi init --ssh --apply fadri14
```

Avec NixOS
```bash
nix run nixpkgs#chezmoi init --ssh --apply fadri14
```

## Initialisation de la config NixOS

```bash
sudo rm -fr /etc/nixos
nixos-generate-config --show-hardware-config > ~/.config/nixos/hardware-configuration.nix
sudo ln -s ~/.config/nixos/ /etc/
sudo nixos-rebuild boot --flake /etc/nixos#mynixos
```
