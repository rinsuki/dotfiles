# all machine
export PATH=$HOME/work/github.com/masarakki/yabai-git-commands/bin:$HOME/.bin:/usr/local/opt/qt5/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.nodebrew/current/bin:$HOME/.rbenv/shims:$HOME/go/bin:$PATH
export PS1="\[\e[32m\]\w\[\e[0m\] \\$ "
export UNAME="$(uname)"
export PATH=$HOME/.bin/platforms/$(uname | tr '[:upper:]' '[:lower:]'):$PATH
if [ ! -z $SSH_TTY ]; then
	export PS1="[$(hostname -fs)] $PS1"
fi
export LANG="ja_JP.UTF-8"
export EDITOR=nano
export HISTSIZE=114514
export HISTIGNORE="fg*:bg*:history*:SECRET *"
alias SECRET=

if [ $UNAME = "Darwin" ]; then
	export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
	alias ls="ls -G"
else
	alias ls="ls --color=auto"
	alias pacman="sudo pacman"
	alias apt="sudo apt"
	alias apt-get="sudo apt-get"
fi

alias unar="aunpack"

if type hub >/dev/null 2>&1; then
	alias git=hub
fi
#if type rbenv >/dev/null 2>&1; then
#	eval "$(rbenv init - --no-rehash)"
#fi
# XQuartz
if [ $UNAME = "Darwin" ]; then
	# mac uim
	export XMODIFIERS=@im=uim
	export GTK_IM_MODULE=uim
	export GTK_PATH=/usr/local/lib/gtk-2.0
fi

# mac command alias
if type systemctl >/dev/null 2>&1; then
	# if linux, systemctl is sudo required
	alias systemctl="sudo systemctl"
elif type brew >/dev/null 2>&1; then
	# linux(systemd) fake
	alias systemctl="brew services"
fi
if type python3 >/dev/null 2>&1; then
	alias python=python3
fi

if [ -f /usr/local/etc/bash_completion ]; then
	. /usr/local/etc/bash_completion
fi
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -d ~/Documents/Wine/main ]; then
	export WINEPREFIX=~/Documents/Wine/main
fi
export WINEARCH=win32

alias su="sudo su"

if [ -f ~/.bashrc_private ]; then
	. ~/.bashrc_private
fi

if type virtualenvwrapper.sh >/dev/null 2>&1; then
	export VIRTUALENVWRAPPER_PYTHON=python3
	source $(which virtualenvwrapper.sh)
	export WORKON_HOME=~/.virtualenvs
fi

# mingw

if [[ $UNAME == MINGW* ]]; then
	alias sudo=gsudo
	export MSYS=winsymlinks:nativestrict
fi

. ~/.anyshrc
