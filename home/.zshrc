# プロンプト

autoload -Uz colors
colors
export PROMPT="%{${fg[green]}%}%~%{${reset_color}%} $ "

# 履歴周り

export HISTSIZE=16544
export SAVEHIST=$HISTSIZE

setopt hist_ignore_space
setopt share_history

# エイリアス

## lsに色を付ける

if [ "$(uname)" = "Darwin" ]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi

## hubコマンドをgitにする

if type hub >/dev/null 2>&1; then
    alias git=hub
fi

# その他

setopt correct