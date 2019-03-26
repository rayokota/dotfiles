# Better auto-completion if shell is *i*nteractive
#[[ $- = *i* ]] && bind TAB:menu-complete
[[ $- = *i* ]] && bind TAB:complete

EDITOR=vi
VISUAL=vim

GREY=$'\033[1;30m'
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
MAGENTA=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[0;37m'
NONE=$'\033[m'

alias cp='cp -i'
alias mv='mv -i'
alias rmi='rm -i'
alias h='history'
alias psa='ps auxwww'
alias mvnv='mvn versions:display-plugin-updates versions:display-dependency-updates'
alias isodate='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias isodate2='date -u +"%Y-%m-%dT%H_%M_%SZ"'

shopt -s histappend
history -a # record each line as it gets issued
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth" # avoid duplicate entries
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history" # don't record some commands
HISTTIMEFORMAT='%F %T ' # useful timestamp format

ssht() {
  ssh $* -t 'tmux a || tmux || /bin/bash'
}

mvim() { 
  if [[ $1 == /* ]]
  then 
    MacVim $1
  else 
    local x=$(pwd)
    MacVim "${x}/$1" 
  fi
}

# trims long paths down
_get_path() {
  local x=$(pwd | sed -e "s:$HOME:~:")
  local len=${#x}
  local max=60
  if [ $len -gt $max ]
  then
      echo ...${x:((len-max+3))}
  else
      echo ${x}
  fi
}
 
# change xterm title
title() {
   if [ $# -eq 0 ]
   then
      title=""
   else
      title="$* - "
   fi
}

# Git info at prompt
git_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

git_status() {
  # git status is slow on nfs mounts 
  if [ `uname` == 'Linux' ]
  then
    [[ $(stat -f -L -c %T .) != "nfs" ]] || return
  fi
  tmp_flags=$(git status --porcelain 2> /dev/null | cut -c1-2 | sed 's/ //g' | cut -c1 | sort | uniq)
  echo $tmp_flags | sed 's/ //g'
}

#executed just before prompt
PROMPT_COMMAND='exitStatus=$?;mydir=$(_get_path);gitbr=$(git_branch);gitst=$(git_status)'
PROMPT_COMMAND="$PROMPT_COMMAND;history -a"  # execute history after capturing exitStatus
 
PS1='\033]0;${title}\u@\h:`tty`>${mydir}\007\n\
\[${GREY}\]\[${CYAN}\]\A\[${GREY}\] \
\[${GREY}\]\[${GREEN}\]\u@\h\[${GREY}\] \
\[${WHITE}\]${mydir} \
\[${GREY}\](\
\[${YELLOW}\]${gitbr}`if [ -n "$gitbr" ]; then echo -n "\[${GREY}\]|"; if [ -n "$gitst" ]; then echo "\[${RED}\]$gitst\[${GREY}\]|"; fi; fi`\
\[${YELLOW}\]%\j\[${GREY}\]|\
\[${YELLOW}\]`if [ $exitStatus -ne 0 ] ; then echo "\[${RED}\]" ; fi`${exitStatus}\
\[${GREY}\])\[${GREEN}\]\
\[${GREEN}\]$\[${GREEN}\] '

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PYTHONPATH=
export JRUBY_OPTS="--1.9"
export MAVEN_OPTS=-Xmx512m
export GOPATH="$HOME/go"
export GO111MODULE=on
export HADOOP_HOME="$HOME/thirdparty/hadoop/hadoop-2.7.1-src/hadoop-dist/target/hadoop-2.7.1"
export HBASE_HOME="$HOME/thirdparty/hbase/hbase-1.1.1/hbase"
export KUBE_EDITOR=vim
export CONFLUENT_HOME="$HOME/thirdparty/confluent-5.1.0-SNAPSHOT"
export CONFLUENT_CURRENT=

# prevent tmux from triggering the path to be updated with duplicate items
if [[ -z $TMUX ]]; then
  # Always add to end of PATH (safer)
  export PATH="${PATH}:/Applications/MacVim.app/Contents/MacOS"
  export PATH="${PATH}:/Library/Frameworks/JRuby.framework/Versions/Current/bin"
  export PATH="${PATH}:/Library/Haskell/bin"
  export PATH="${PATH}:$HOME/.local/bin" # stack tool for Haskell
  export PATH="${PATH}:$GOPATH/bin"
  export PATH="${PATH}:$HOME/.local/lib/aws/bin"
  export PATH="${PATH}:$CONFLUENT_HOME/bin"
fi

eval "$(goenv init -)"

[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ${GOPATH}/src/github.com/confluentinc/cc-dotfiles/caas.sh
source ~/.git-completion.bash
