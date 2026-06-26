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

- `git` - `.gitignore` file
- `nano` - `.nanorc` file
- `screen` - `.screenrc` file
- `kitty` terminal - `.config/kitty` directory

# Command lines

## Cloning disc with broken sectors

```shell
ddrescue -b256 -d -r10 /dev/sr0 disc.img disc.log
```

## ssh login with password only

```shell
ssh -o PubkeyAuthentication=no my_server_config
```

## Generate ssh key

```shell
ssh-keygen -t ed25519 -C 'email_or_comments' -f id_ed25519_name
```

# Troubleshooting

## Keep SSH run programs after logout

To keep the run program on the machine, modify `/etc/systemd/logind.conf` configuration file
with option `KillUserProcesses=no` enabled.

## Fixing GPT partition table

Note: **GParted** can be used to detect broken partition tables.
It showing the information like:

> The primary GPT table is corrupt, but the backup appears OK, so that will be used.

First, identify the device:

```shell
lsblk
```

Then, fix the GPT partition table:

```shell
sudo gdisk /dev/nvme0n1
```

In the `gdisk` menu, press `p` to print the partition table, then `w` to write the changes if backup partition table is loaded correctly.

## Removing MIME types for kitty

Due to opening directories/paths/devices in terminal instead of in GUI file manager.

```shell
sudo rm /usr/share/applications/{kitty.desktop,kitty-open.desktop}
```

## Open URL in firefox in incognito mode

Edit section in file `/usr/share/applications/firefox.desktop`:

```text
Exec=/usr/lib/firefox/firefox --private-window %u
```

## Scan MAC address in local network

```shell
sudo nmap -sn 192.168.1.1/24
```

## Discover devices in local network

Use [whosthere](https://github.com/ramonvermeulen/whosthere) to scan MAC address in local network.

```shell
whosthere
```

## Add docker group to the user

```
sudo usermod -aG docker $USER
```

## Update Arch Linux keyring

```shell
sudo pacman -Sy archlinux-keyring
```
