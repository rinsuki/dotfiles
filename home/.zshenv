# macOSではPATHが/etc/zprofileによって上書きされるのでそれを回避

if [ "$(uname)" = "Darwin" ]; then
    setopt no_global_rcs
    # system-wide environment settings for zsh(1)
    if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
    fi
fi

export PATH=$HOME/.rbenv/shims:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.bin/platforms/$(uname | tr '[:upper:]' '[:lower:]'):$PATH
export EDITOR=nano
