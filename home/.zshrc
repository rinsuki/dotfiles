# bindkey

bindkey "^[[3~" delete-char

# プロンプト

autoload -Uz colors compinit
colors

PROMPT_COLOR="${fg[green]}"
if [ $USER = "root" ]; then
    PROMPT_COLOR="${fg[red]}"
fi
export PROMPT="%{${PROMPT_COLOR}%}%~%{${reset_color}%} $ "
if [ ! -z $SSH_TTY ]; then
	export PROMPT="[$(hostname -fs)] $PROMPT"
fi

uname="$(uname)"

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

if [[ $uname = "Darwin" ]]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi

## hubコマンドをgitにする

if type hub >/dev/null 2>&1; then
    alias git=hub
fi

## brew services -> systemctl

if [[ $uname = "Darwin" ]]; then
	alias systemctl="brew services"
fi

## sudo必要系を自動で付ける
if [[ $uname = "Linux" ]]; then
    alias apt="sudo apt"
fi

## ghqのインクリメンタルサーチ
if type ghq >/dev/null 2>&1; then
    function g() {
        local cdpath=$(ghq list --full-path | fzf-tmux --reverse +m)
        if [ -n "$cdpath" ]; then
            cd $cdpath
        fi
    }
    if type code >/dev/null 2>&1; then
        function gcode() {
        local cdpath=$(ghq list --full-path | fzf-tmux --reverse +m)
            if [ -n "$cdpath" ]; then
                code $cdpath
            fi
        }
    fi
fi

## 雑多

alias be="bundle exec"
alias yw="yarn workspace"

# その他

## typoしたコマンドの提案
setopt correct

## completions

fpath=($HOME/.asdf/completions $HOME/.local/share/zsh-completions /usr/local/share/zsh-completions $fpath)
compinit

### heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/user/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

## git ignore
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

## direnv

type direnv >/dev/null && eval "$(direnv hook zsh)"

## fzf

test -f ~/.fzf.zsh && source ~/.fzf.zsh

## asdf
test -f ~/.asdf/asdf.sh && source ~/.asdf/asdf.sh

## thefuck
type fuck >/dev/null && eval $(thefuck --alias)
