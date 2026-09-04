#!/bin/bash
set -xe
# Solarium (aka Liquid Glass) は SwiftUI/Solarium の feature flag を false にすることで無効化できる。
# しかし、 これを一般に(?) 知られている /Library/Preferences/FeatureFlags/Domain/SwiftUI.plist に
# 書き込む方法で無効化すると、決め打ちで Liquid Glass を使っている箇所が透明になるため、一部表示が見づらくなる。
# e.g. Dock, Notification Center, Control Center

# これの解決方法として、Solarium はデフォルト(有効)のまま、ほとんどのアプリに対しては無効化するという手法を見付けた。
# feature flag は /Library/Preferences/FeatureFlags 下に書き込んで再起動後に反映させる方法がよく知られているが、
# 実は環境変数 FEATUREFLAGS_ENABLED/DISABLED で特定プロセスだけ有効/無効化することができる。
# ので、ログイン後なるべく早く launchctl setenv で FEATUREFLAGS_DISABLED を有効化することで、
# WindowServer や Dock などは Solarium を有効にしたまま、他のアプリは Solarium を無効化できる。

# ちなみに: Liquid Glass を特定のアプリだけ再有効化したい場合、
# `open --env FEATUREFLAGS_DISABLED= -a Music` のようにするとそのアプリだけ再有効化した状態で起動できる。

# Solarium をオフにすると影響があるとわかっているアプリ:
# * https://github.com/lwouis/alt-tab-macos
#   * スイッチャーの背景が消える
# * Device Hub (Xcode 27+ 内蔵、com.apple.dt.Devices)
#   * サイドバーを畳むとクラッシュする
# * /System/Applications/Music.app
#   * 下側の再生コントロールが出なくなる
#   * (見た目も微妙になる)

plutil -convert xml1 - -o ~/Library/LaunchAgents/net.rinsuki.dotfiles.nosolarium.plist <<EOF
{
    "ProgramArguments": [
        "/bin/bash",
        "-c",
        "/bin/launchctl setenv FEATUREFLAGS_DISABLED SwiftUI/Solarium; /bin/launchctl kickstart system/net.rinsuki.dotfiles.nosolarium.u$(id -u)"
    ],
    "ProcessType": "Interactive",
    "RunAtLoad": true,
    "Label": "net.rinsuki.dotfiles.nosolarium"
}
EOF

# NSAlert の背景が透明になるのを修正
defaults write -g NSAlertGlassSolariumEnabled -bool false
# WindowServerのSolariumが有効なのにアプリが有効でない時、NSStatusItem (メニューバーの右側) にアイテムが出なくなるのを修正
defaults write -g NSStatusItemUseControlCenter -bool true

# Finder にはなんか反映されないので root で launchctl debug を呼んで反映させる
sudo plutil -convert xml1 - -o /Library/LaunchDaemons/net.rinsuki.dotfiles.nosolarium.u$(id -u).plist <<EOF
{
    "ProgramArguments": [
        "/bin/bash",
        "-c",
        "/bin/launchctl debug gui/$(id -u)/com.apple.Finder --environment FEATUREFLAGS_DISABLED=SwiftUI/Solarium; launchctl kickstart -k gui/$(id -u)/com.apple.Finder"
    ],
    "Label": "net.rinsuki.dotfiles.nosolarium.u$(id -u)"
}
EOF

# 余談: 逆にグローバルで Solarium を切った後に Dock とかだけ Solarium を有効化して起動したらいいんじゃないか? と思うかもしれないが、
# 通知センターやコントロールセンターは SIP で守られていて環境変数を起動時に設定できなかった (ためボツになった)。あと WindowServer は再起動できないし……
