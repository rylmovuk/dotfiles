# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd nomatch
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/maxim/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey "${terminfo[khome]}" beginning-of-line		# Home
bindkey "${terminfo[kend]}" end-of-line			# End
bindkey "${terminfo[kdch1]}" delete-char		# Del
bindkey "^[Od" backward-word				# Ctrl-Left
bindkey "^[Oc" forward-word				# Ctrl-Right

alias ls='ls --color=auto'
PROMPT="[%n@%m %F{green}%~%f] %(!.%F{red}#%f.$) "

export EDITOR=vim
# powerline-daemon -q
# . /usr/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh


eval $(thefuck --alias)
