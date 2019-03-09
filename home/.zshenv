# macOSではPATHが/etc/zprofileによって上書きされるのでそれを回避

if [ "$(uname)" = "Darwin" ]; then
    setopt no_global_rcs
    # system-wide environment settings for zsh(1)
    if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
    fi
fi

export VITASDK=$HOME/.vitasdk
export THEOS=$HOME/.theos

export PIPENV_VENV_IN_PROJECT=1
export PYENV_ROOT="$HOME/.pyenv"

export PATH=$HOME/.rbenv/shims:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.bin/platforms/$(uname | tr '[:upper:]' '[:lower:]'):$PATH
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$VITASDK/bin
export PATH=$PYENV_ROOT/bin:$PATH
export EDITOR=nano

source ~/.zshenv.private
