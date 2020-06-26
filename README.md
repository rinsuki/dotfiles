# dotfiles

私のdotfilesです

## Install

```sh
./install.py
```

**warning: ** `~/` にある既存のファイルを上書きします

Python3.xが必要です

## 試用

`Dockerfile` からコンテナを`build`して`run`すれば試用できます

# 機能

- `makegif` - 動画ファイルを簡単にそれなりなGIFファイルに変換できます
    - usage: `makegif in.mp4 out.gif`
- `sandbox` - /tmp下に一時的なディレクトリを掘ってbashを起動します
- `randomgen` - `/dev/urandom`を使って適当な文字列を生成し、クリップボードにコピーします(macOS only)
- `SECRET ` のprefixを付けたコマンドは.bash_historyに残らなくなります
    - usage: `SECRET curl -H "Access-Token: shibuyarin" https://api.secret.example.com/my/profile`
## その他

- `pacman` / `apt` / `apt-get` / `systemctl` でsudoを書く手間を無くします
- `hub` コマンドがあれば `git` にaliasします
- `brew` コマンドがあれば `systemctl` が `brew services` のaliasになります (macOS only)
- `python3` が存在する場合は `python` にaliasします
- `/usr/local/etc/bash_completion` が存在する場合はすべてsourceで読み込みます
- `/etc/bash_completion` が存在する場合はすべてsourceで読み込みます
- `su` を `sudo su` にaliasします
- `~/Documents/Wine/main` が存在する場合は`$WINEPREFIX`にそれを設定します
- `WINEARCH` を `win32` に設定します
- `~/.bashrc_private` が存在する場合はsourceで読み込みます


# その他ファイル

- Mac用
    - `mac-hidutil-replace-henkan-key.app`
        - hidutilでPCの無変換/変換キーを英数/かなキーに置換します。システム環境設定→ユーザーとグループ→ログイン項目に追加して使用します
    - `mac-defaults.sh`
        - 各アプリの設定の一部を自動で設定します