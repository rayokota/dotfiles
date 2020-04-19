# Load shared shell configuration
source ~/.shrc

GREY=$'\033[1;30m'
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
MAGENTA=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[0;37m'
NONE=$'\033[m'

shopt -s histappend
history -a # record each line as it gets issued
HISTFILE="$HOME/.bash_history"
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth" # avoid duplicate entries
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history" # don't record some commands
HISTTIMEFORMAT='%F %T ' # useful timestamp format

#executed just before prompt
PROMPT_COMMAND='exitStatus=$?;mydir=$(_get_path);gitbr=$(git_branch);gitst=$(git_status)'
PROMPT_COMMAND="$PROMPT_COMMAND;history -a"  # execute history after capturing exitStatus
 
PS1='\033]0;${title}\u@\h:`tty`>${mydir}\007\n\
\[${GREY}\]\[${CYAN}\]\t\[${GREY}\] \
\[${GREY}\]\[${GREEN}\]\u@\h\[${GREY}\] \
\[${CYAN}\]${mydir} \
\[${GREY}\](\
\[${YELLOW}\]${gitbr}`if [ -n "$gitbr" ]; then echo -n "\[${GREY}\]|"; if [ -n "$gitst" ]; then echo "\[${RED}\]$gitst\[${GREY}\]|"; fi; fi`\
\[${YELLOW}\]%\j\[${GREY}\]|\
\[${YELLOW}\]`if [ $exitStatus -ne 0 ] ; then echo "\[${RED}\]" ; fi`${exitStatus}\
\[${GREY}\])\[${GREEN}\]$ \[${WHITE}\]'

[[ -s /usr/local/etc/bash_completion ]] && . /usr/local/etc/bash_completion
source ~/.git-completion.bash
