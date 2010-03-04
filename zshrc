# .zshrc - zsh configuration file
#
# Randy Morris (rson451@gmail.com)
#
# CREATED:  a long time ago
# MODIFIED: 2010-03-03 10:13
#
# Note: This file closely ties in with my screenrc for the screen title stuff.
#       See http://rsontech.net/dotfiles/server/.screenrc
#

# simple settings {{{
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
autoload -Uz compinit
autoload -U colors && colors
compinit
zstyle :compinstall filename '/home/randy/.zshrc'
setopt nobeep nohistbeep nolistbeep

#}}}

# environ vars {{{
export PATH=$PATH:~/bin
export BC_ENV_ARGS=~/.bcrc
export EDITOR=/usr/bin/vim
#}}}

# aliases {{{
alias ls='ls --color=auto'
alias tree='tree -L 1 -C'
alias :q='exit'
alias gist='pygist -a'
alias sudo='command sudo '
alias shop='shop --pad 12'
alias gmutt='mutt -F $HOME/.muttrc.personal'
alias gitt='git ls-files -toc'
alias .f='cd ~/.config/dotfiles/'

$(which pacman-color &> /dev/null ) && alias pacman='pacman-color'
#}}}

# functions {{{

atop(){ #{{{
	SHOW=10
	DELAY=3;

	if [ $1 ]; then
		SHOW=$1
		if [ $2 ]; then
			DELAY=$2
		fi
	fi
	watch -n $DELAY "free; echo; uptime; echo; ps aux  --sort=-%cpu | head -n $(($SHOW+1)); echo; who"
}
#}}}

todo(){ #{{{
  if [ -z $1 ]; then
    awk '{ i += 1; print i": "$0 }' $HOME/.todo
    return
  fi

  case $1 in
    "add")
      echo $2 >> $HOME/.todo
    ;;
    "del")
      todo=$(< $HOME/.todo | sed "$2"'d')
      echo $todo > $HOME/.todo
    ;;
    "search")
      grep -ni --color=never $2 $HOME/.todo | sed -e 's/:/: /'
    ;;
  esac
}
#}}}

set-title(){ #{{{
    builtin echo -ne "\ek$*\e\\"
}
#}}}

set-hardstatus(){ #{{{
    if [[ $* == "zsh" ]]; then
        printf '\e_%s\e\' $VIMODE
    else
        printf '\e_\e\'
    fi
}
#}}}

preexec(){ #{{{
    #if [[ -n $STY ]]; then
    if [[ $TERM =~ "screen" ]]; then
        TITLE=${$(echo $3 | sed -r 's/^command sudo ([^ ]*) .*/\1/;tx;s/^([^ ]*) +.*/\1/;s/^([^ ]*)$/\1/;:x;q')/#*\/}
        set-title $TITLE
        set-hardstatus $TITLE
    fi
}
#}}}

precmd(){ #{{{
    set-prompt
    #if [[ -n $STY ]]; then
    if [[ $TERM =~ "screen" ]]; then
        TITLE=${0/#*\/}
        set-title $TITLE
        set-hardstatus $TITLE
    fi
}
#}}}

chpwd(){ #{{{
    set-prompt

    if [ -d ".git" ]; then
        if [[ ! $(git config --get remote.origin.url) =~ '/srv/git/dotfiles.git' ]]; then
            git status
        fi
    fi
    ls
}
#}}}

set-mode(){  #{{{
    VIMODE='--'$1'--'
    set-hardstatus $TITLE
}
#}}}

set-prompt(){ #{{{
    if [[ $HOST == 'banks' ]]; then
        PS1="%{$fg_no_bold[white]%}%~ %(?.%{$fg_no_bold[green]%}>%{$fg_bold[green]%}>%{$fg_bold[yellow]%}>.%{$fg_no_bold[magenta]%}>%{$fg_bold[red]%}>%{$fg_bold[magenta]%}>)%{$reset_color%} "
        RPROMPT="%(?.%{$fg_bold[yellow]%}<%{$fg_bold[green]%}<%{$fg_no_bold[green]%}<.%{$fg_bold[magenta]%}<%{$fg_bold[red]%}<%{$fg_no_bold[magenta]%}<) %{$fg_no_bold[white]%}%n@%m%{$reset_color%}"
    else
        PS1="%{$fg_no_bold[white]%}%~ %(?.%{$fg_no_bold[cyan]%}>%{$fg_no_bold[blue]%}>%{$fg_bold[cyan]%}>.%{$fg_no_bold[magenta]%}>%{$fg_bold[red]%}>%{$fg_bold[magenta]%}>)%{$reset_color%} "
        RPROMPT="%(?.%{$fg_bold[cyan]%}<%{$fg_no_bold[blue]%}<%{$fg_no_bold[cyan]%}<.%{$fg_bold[magenta]%}<%{$fg_bold[red]%}<%{$fg_no_bold[magenta]%}<) %{$fg_no_bold[white]%}%n@%m%{$reset_color%}"
    fi
}
#}}}

zle-keymap-select(){ #{{{
    if [[ $KEYMAP == vicmd ]]; then
        set-mode NORMAL
    else
        set-mode INSERT
    fi
}
#}}}

#}}}

# make special keys work as expected {{{
bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\eOd" backward-word
bindkey "\eOc" forward-word
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward
#}}}

# convenience keys {{{
bindkey -s "^\\" " | less\n"
bindkey "^J" push-line
bindkey '^R' history-incremental-search-backward
#}}}

set-mode INSERT
set-prompt

zle -N zle-keymap-select

# vim:foldlevel=0
