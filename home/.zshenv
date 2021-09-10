# msys2 では .zshenv が /etc/profile に先行してしまうせいでunameとかが存在しないと言われてしまう
# ので uname がなかったらPATHを通しておく

if type uname >/dev/null 2>&1; then
else
    export PATH="$PATH:/usr/bin"
fi

# macOSではPATHが/etc/zprofileによって上書きされるのでそれを回避

if [ "$(uname)" = "Darwin" ]; then
    setopt no_global_rcs
    # system-wide environment settings for zsh(1)
    if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
    fi
fi

export DOTNET_CLI_TELEMETRY_OPTOUT=1

export VITASDK=$HOME/.vitasdk
export THEOS=$HOME/.theos
export HAXE_STD_PATH="/usr/local/lib/haxe/std"

export PIPENV_VENV_IN_PROJECT=1
export PYENV_ROOT="$HOME/.pyenv"

# PATH の最初に追加する勢
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.bin/platforms/$(uname | tr '[:upper:]' '[:lower:]'):$PATH
export PATH=$HOME/.bin.private:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$PYENV_ROOT/bin:$PATH

# PATH の最後に追加する勢
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$VITASDK/bin
export PATH=$PATH:$HOME/work/chromium.googlesource.com/chromium/tools/depot_tools
export PATH=$PATH:$HOME/.composer/vendor/bin
export PATH=$PATH:$HOME/flutter/bin

if [ -d /Applications/SeKey.app ]; then
    export PATH=$PATH:/Applications/SeKey.app/Contents/MacOS
    export SSH_AUTH_SOCK=$HOME/.sekey/ssh-agent.ssh
fi

export EDITOR=nano

if [ -f ~/.zshenv.private ]; then
    source ~/.zshenv.private
fi
