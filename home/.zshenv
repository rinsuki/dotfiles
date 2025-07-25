# msys2 では .zshenv が /etc/profile に先行してしまうせいでunameとかが存在しないと言われてしまう
# ので uname がなかったらPATHを通しておく

if type uname >/dev/null 2>&1; then
else
    if [[ $OLD_PATH = "" ]]; then
        # .bin/platforms/msys/open 用の msys で汚れてない PATH をメモっておく
        export OLD_PATH="$PATH"
    fi
    export PATH="$PATH:/usr/bin"
fi

uname="$(uname)"

# macOSではPATHが/etc/zprofileによって上書きされるのでそれを回避

if [[ $uname = "Darwin" ]]; then
    setopt no_global_rcs
    # system-wide environment settings for zsh(1)
    if [[ -x /usr/libexec/path_helper ]]; then
        eval `/usr/libexec/path_helper -s`
    fi
fi

platform_name="$(uname | tr '[:upper:]' '[:lower:]')"

if [[ $platform_name =~ ^msys ]]; then
    platform_name=msys
fi

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DENO_TLS_CA_STORE=mozilla,system

export VITASDK=$HOME/.vitasdk
export THEOS=$HOME/.theos
export HAXE_STD_PATH="/usr/local/lib/haxe/std"

# PATH の最初に追加する勢
if [[ $uname = "Darwin" ]]; then
    export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
fi
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export REQUESTS_CA_BUNDLE=/opt/homebrew/etc/ca-certificates/cert.pem
fi
path=(
    "$HOME/.bin"
    "$HOME/.bin/platforms/$platform_name"
    "$HOME/.bin.private"
    "$HOME/.local/bin"
    "$HOME/.asdf/shims"
    "$HOME/.cargo/bin"
    "$HOME/.rye/shims"
    $path
    "$HOME/go/bin"
    "$VITASDK/bin"
    "$HOME/work/chromium.googlesource.com/chromium/tools/depot_tools"
    "$HOME/.composer/vendor/bin"
    "$HOME/flutter/bin"
)

if [[ -d ~/.modular ]]; then
    export MODULAR_HOME="$HOME/.modular"
    path=(
        "$MODULAR_HOME/pkg/packages.modular.com_mojo/bin"
        $path
    )

    export PATH
fi

export PATH

export EDITOR=nano

if [[ -f ~/.cargo/env ]]; then
    source ~/.cargo/env
fi

if [[ -f ~/.zshenv.private ]]; then
    source ~/.zshenv.private
fi

if [[ -f /opt/homebrew/etc/ca-certificates/cert.pem ]]; then
    export REQUESTS_CA_BUNDLE=/opt/homebrew/etc/ca-certificates/cert.pem
fi
