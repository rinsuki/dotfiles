# プロンプト

autoload -Uz colors
colors
export PROMPT="%{${fg[green]}%}%~%{${reset_color}%} $ "

# 履歴周り

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=16544
export SAVEHIST=165440

if type peco >/dev/null 2>&1; then
    function peco-history-search() {
        BUFFER=`history -n 1 | tail -r| peco`
        CURSOR=$#BUFFER
        zle reset-prompt
    }
    zle -N peco-history-search
    bindkey '^R' peco-history-search
fi

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

## typoしたコマンドの提案
setopt correct

## completions

fpath=(/usr/local/share/zsh-completions $fpath)
