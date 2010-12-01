# .zshrc - zsh configuration file
#
# Randy Morris (rson451@gmail.com)
#
# CREATED:  a long time ago
# MODIFIED: 2010-12-01 08:23
#
# Note: This file closely ties in with my screenrc for the screen title stuff.
#       See http://rsontech.net/dotfiles/screenrc
#

# simple settings {{{
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
autoload -U compinit && compinit
autoload -U colors && colors
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
alias sudo='command sudo '
alias shop='shop --pad 12'
alias gmutt='mutt -F $HOME/.muttrc.personal'
alias gitt='git ls-files -toc'
alias .f='cd ~/.config/dotfiles/'
alias pyc='find . -name "*.pyc" -delete; ls'
alias tmux='tmux -2'

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
  todo_file=$HOME/.todo
  if [ -z $1 ]; then
    awk '{ i += 1; print i": "$0 }' $todo_file
    return
  fi

  case $1 in
    add|a|-a)
      echo $2 >> $todo_file
    ;;
    del|d|-d)
      if [ -z $2 ]; then
        read -q "reply?clear entire todo list? [y|N] "
        [ $reply = 'y' ] || return
      fi
      sed -i "$2d" $todo_file
    ;;
    search|s|-s)
      grep -ni --color=never $2 $todo_file | sed -e 's/:/: /'
    ;;
  esac
}
#}}}

set-title(){ #{{{
    builtin echo -ne "\ek$*\e\\"
}
#}}}

preexec(){ #{{{
    #if [[ -n $STY ]]; then
    if [[ $TERM =~ "screen" ]]; then
        TITLE=${$(echo $3 | sed -r 's/^command sudo ([^ ]*) .*/\1/;tx;s/^([^ ]*) +.*/\1/;s/^([^ ]*)$/\1/;:x;q')/#*\/}
        set-title $TITLE
    fi
}
#}}}

precmd(){ #{{{
    set-prompt
    if [[ $TERM =~ "screen" ]]; then
        TITLE=${0/#*\/}
        set-title $TITLE
    fi
}
#}}}

chpwd(){ #{{{
    set-prompt
    ls
}
#}}}

set-prompt(){ #{{{
    git-prompt
    PS1="%{$fg_no_bold[white]%}%~ $GIT_PROMPT%(?.%{$fg_no_bold[green]%}>%{$fg_bold[green]%}>%{$fg_bold[yellow]%}>.%{$fg_no_bold[magenta]%}>%{$fg_bold[red]%}>%{$fg_bold[magenta]%}>)%{$reset_color%} "
    RPROMPT="%(?.%{$fg_bold[yellow]%}<%{$fg_bold[green]%}<%{$fg_no_bold[green]%}<.%{$fg_bold[magenta]%}<%{$fg_bold[red]%}<%{$fg_no_bold[magenta]%}<) %{$fg_no_bold[white]%}%n@%m%{$reset_color%}"
} #}}}

git-prompt(){ #{{{
    if [ -d .git ]; then
        git_ref=$(git symbolic-ref HEAD 2>/dev/null)
        git_branch=${git_ref#refs/heads/}
        git_upstream=''

        # only do this if it's easy
        git_revs=($(git rev-list --count --left-right "@{upstream}"...HEAD 2>/dev/null))
        if [ $? -eq 0 ]; then
            [[ $git_revs[2] != "0" ]] && git_upstream+=":+$git_revs[2]"
            [[ $git_revs[1] != "0" ]] && git_upstream+=":-$git_revs[1]"
        fi
        GIT_PROMPT="(${git_branch}${git_upstream}) "
    else
        unset GIT_PROMPT
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
bindkey "^J" push-line
bindkey '^R' history-incremental-search-backward
#}}}

set-prompt

# launch X if logged into TTY1
if [[ $TTY == /dev/tty1 ]]; then
    exec /usr/bin/xinit
fi

# vim:foldlevel=0
