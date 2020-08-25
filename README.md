# dotfiles

私のdotfilesです

## Contents

### `./install.py`

ホームディレクトリを`./home`の内容で上書きします。

**Requirements:** Python 3.x


### `./mac-hidutil-replace-henkan-key.app`

Mac上でPCキーボードの(無)?変換キーを英数/かなキーに変換する設定をします。
システム環境設定→ユーザーとグループ→ログイン項目に追加して使うことを想定しています。

### `mac-defaults.sh`

Macの一部設定を自動で変更&適用します

### `mas-install.sh`

`mas`コマンドで Mac App Store からいつも使うアプリ郡をインストールします

**Requirements:** `mas` コマンド (`brew install mas`でインストール可能)、あらかじめ Mac App Store へサインイン済であること

### `./skk/zenkaku-kigou.rule`

SKKの全角ひらがなモードで全角の記号"！？（）"を出せるようにしたルールです。
AquaSKKの場合は `./skk-install-to-aquaskk.sh` で追加したあとAquaSKKで"設定ファイルの再読み込み"をし、環境設定→拡張設定で有効化してください

**Requirements:** AquaSKK

### `./firefox-user.js`

Firefoxの設定(の一部)です。
Firefoxのプロファイル直下に`user.js`としてシンボリックリンクを貼って使います

### `./firefox-mac/userChrome.css`

macOS上で動くFirefox用の`userChrome.css`です。
Firefoxのプロフィール下の`chrome/userChrome.css`にシンボリックリンクを貼って使います

### `./vivaldi-custom-css/*`

Vivaldi用のカスタムCSSですが、もうVivaldiを使っていないのでメンテナンスされていません

### `win-uninstall-apps-vm.bat`

Windows 10 の VM セットアップ時に、VMでは通常使わないアプリを消すためのバッチ/PS1ファイルです。
削除するアプリの内容は`.ps1`ファイルの中身を見てください。
`.bat`と`.ps1`を同じディレクトリに入れて`.bat`を起動してください。