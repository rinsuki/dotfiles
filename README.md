# dotfiles

私のdotfilesです

## Install

```sh
./install.py
```

Python3.xが必要です

## 試用

WIP

# 機能

- `makegif` - 動画ファイルを簡単にそれなりなGIFファイルに変換できます
- `sandbox` - /tmp下に一時的なディレクトリを掘ってbashを起動します
- `randomgen` - `/dev/urandom`を使って適当な文字列を生成します(Darwin / macOS only)
- `SECRET ` のprefixを付けたコマンドは.bash_historyに残らなくなります

## その他

- `pacman` / `apt` / `apt-get` / `systemctl` でsudoを書く手間を無くします
- `hub` コマンドがあれば `git` にaliasします
- `systemctl` が `brew services` のaliasになります (Darwin / macOS only)
- `python3` が存在する場合は `python` にaliasします
- `/usr/local/etc/bash_completion` が存在する場合はすべてsourceで読み込みます
- `/etc/bash_completion` が存在する場合はすべてsourceで読み込みます
- `su` を `sudo su` にaliasします
- `~/Documents/Wine/main` が存在する場合は`$WINEPREFIX`にそれを設定します
- `WINEARCH` を `win32` に設定します
- `~/.bashrc_private` が存在する場合はsourceで読み込みます
