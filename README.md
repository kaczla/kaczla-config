# kaczla-config

Personal configuration

# Configuration

## git

Set GPG key for `git`.

```
git config --global user.signingkey __KEY__
git config --global gpg.program gpg2
git config --global commit.gpgsign true
```

# Configuration files

- `git` - `.gitignore`
- `nano` - `.nanorc`
- `screen` - `.screenrc`

# Troubleshooting

## Removing MIME types for kitty

Due to opening directories/paths/devices in terminal instead of in GUI file manager.

```shell
sudo rm /usr/share/applications/{kitty.desktop,kitty-open.desktop}
```
