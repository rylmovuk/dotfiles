HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt ALWAYSTOEND AUTOCD AUTOMENU COMPLETEINWORD EXTENDEDHISTORY \
	HISTEXPIREDUPSFIRST HISTIGNOREDUPS HISTIGNORESPACE HISTVERIFY \
	INCAPPENDHISTORY INTERACTIVECOMMENTS NOMATCH SHAREHISTORY
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compaudit compinit
# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP=".zsh/zcompdump-${HOST/.*/}-${ZSH_VERSION}"
fi
compinit -u -C -d "${ZSH_COMPDUMP}"

zmodload -i zsh/complist

bindkey -M menuselect '^o' accept-and-infer-next-history
zstyle ':completion:*:*:*:*:*' menu select

zstyle ':completion:*' special-dirs true

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path .zsh/cache

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa www run xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

autoload -Uz colors; colors
unalias run-help; autoload -Uz run-help
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=blue'
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_STRATEGY=history
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-theme.zsh

bindkey -v
export KEYTIMEOUT=2
autoload -Uz up-line-or-beginning-search; zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search; zle -N down-line-or-beginning-search

bindkey "${terminfo[khome]}" beginning-of-line \
	"${terminfo[kend]}" end-of-line \
	"${terminfo[kdch1]}" delete-char \
	"${terminfo[kcuu1]}" up-line-or-beginning-search \
	"${terminfo[kcud1]}" down-line-or-beginning-search \
	'^P' up-line-or-beginning-search \
	'^N' down-line-or-beginning-search \
	'^O' autosuggest-accept \
	'^[.' insert-last-word \
	'^[f' forward-word \
	'^[b' backward-word


bindkey -a 'K' run-help
bindkey -as 'ZZ' '^D'
autoload -U edit-command-line; zle -N edit-command-line
bindkey -a 'gv' edit-command-line

_zshrc_cursor_insert='\e[6 q'
_zshrc_cursor_normal='\e[2 q'
if [[ -n $TMUX ]]; then
	_zshrc_cursor_insert='\ePtmux;\e'$_zshrc_cursor_insert'\e\\'
	_zshrc_cursor_normal='\ePtmux;\e'$_zshrc_cursor_normal'\e\\'
fi

function zle-keymap-select {
	# Manipulate cursor
	if [[ $KEYMAP = "main" || $KEYMAP = "viins" ]]; then
		echo -ne "$_zshrc_cursor_insert"
	else
		echo -ne "$_zshrc_cursor_normal"
	fi
}
function zle-line-init {
	if [[ $terminfo[smkx] ]] echoti smkx # terminfo compliance (st)
	zle-keymap-select
}

function zle-line-finish {
	if [[ $terminfo[rmkx] ]] echoti rmkx # terminfo compliance (st)
}

function accept-line {
	echo -en "$_zshrc_cursor_normal"
	zle .accept-line
}

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish
zle -N accept-line

# set title
function set_term_title_zsh { echo -en "\e]0;${PWD/#$HOME/~} [$TERMINAL]\a" }
function set_term_title_cmd { echo -en "\e]0;$2 [$TERMINAL]\a" }
add-zsh-hook precmd set_term_title_zsh
add-zsh-hook preexec set_term_title_cmd

alias ls='ls --color=auto' grep='grep --color=auto'
alias l='ls -Fhl' ll='ls -AFhl' la='ls -Fahl' lsa='ls -Fa'
alias vi=vim e="$EDITOR" rmr='rm -r' md='mkdir'
alias X='startx ~/.xinitrc' paclean='sudo pacman -Sc --noconfirm'
ccd() { [ -d "$1" ] || mkdir -p "$1"; cd "$1" }

NNN_COPIER="xclip -i -sel c"

# man colors
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# BASE16_SHELL=$HOME/.config/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
