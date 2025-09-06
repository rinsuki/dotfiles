# bindkey

bindkey "^[[3~" delete-char
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
# プロンプト

autoload -Uz colors compinit
colors

PROMPT_COLOR="${fg[green]}"
if [[ $USER = "root" ]]; then
    PROMPT_COLOR="${fg[red]}"
fi
export PROMPT="%{${PROMPT_COLOR}%}%~%{${reset_color}%} $ "
if [[ ! -z $SSH_TTY ]]; then
	export PROMPT="[$(hostname -fs)] $PROMPT"
fi

uname="$(uname)"

if [[ $uname = "Darwin" ]]; then
    if [[ "$(sysctl -n sysctl.proc_translated)" = "1" ]]; then
        export PROMPT="Rosetta: $PROMPT"
    fi
fi

# 履歴周り

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=16544
export SAVEHIST=165440
export FZF_DEFAULT_OPTS="--height 40%"

if type fzf >/dev/null 2>&1; then
    function fzf-history-search() {
        str=`history -n -r 1 | fzf-tmux --no-sort +m --query "$LBUFFER" --reverse`
        if [ -n "$str" ]; then
            BUFFER="$str"
            CURSOR=$#BUFFER
        fi
        zle reset-prompt
    }
    zle -N fzf-history-search
    bindkey '^R' fzf-history-search
fi

setopt extended_history
setopt hist_ignore_space
setopt share_history
setopt nonomatch

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

if [[ $uname = "Darwin" ]]; then
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

## ghqのインクリメンタルサーチ
if type ghq >/dev/null 2>&1; then
    function g() {
        local cdpath=$(ghq list --full-path | fzf-tmux --reverse +m)
        if [[ -n "$cdpath" ]]; then
            cd $cdpath
        fi
    }
    if type code >/dev/null 2>&1; then
        function gg() {
            local cdpath=$(ghq list --full-path | fzf-tmux --reverse +m)
            if [[ -n "$cdpath" ]]; then
                code $cdpath
            fi
        }
    fi
fi

. ~/.anyshrc

# その他

## typoしたコマンドの提案
setopt correct

## completions

type brew &>/dev/null && fpath=("$(brew --prefix)"/share/zsh-completions $fpath)
fpath=($HOME/.asdf/completions $HOME/.local/share/zsh-completions /usr/local/share/zsh-completions $fpath)
test -f ~/.ssh/config && _cache_hosts=(`sed -n -E 's/^Host +(.+)$/\1/p' ~/.ssh/config`) # ssh hosts の補完をなんとかする
compinit
zstyle ':completion:*:ssh:*' users off # ssh users が全部出てきて macOS とかでうざいのをなんとかする

### heroku autocomplete setup
if [[ $uname = "Darwin" ]]; then
    HEROKU_AC_ZSH_SETUP_PATH=$HOME/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
fi

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

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

alias vpm="DOTNET_ROOT=/opt/homebrew/opt/dotnet@6/libexec ~/.dotnet/tools/vpm"
alias claude="/Users/user/.claude/local/claude"
