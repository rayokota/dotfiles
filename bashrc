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
HISTFILESIZE=1000000
HISTSIZE=10000000
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'

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

export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PYTHONPATH=
export JRUBY_OPTS="--1.9"
export MAVEN_OPTS=-Xmx512m
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="$HOME/go"
export SBCL_HOME="/usr/local/lib/sbcl"
export CONFLUENT_HOME="$HOME/thirdparty/confluent-4.1.0-SNAPSHOT"
#export CONFLUENT_HOME="$HOME/thirdparty/confluent-4.0.0"
export CONFLUENT_CURRENT="$CONFLUENT_HOME/var"
export HADOOP_HOME="$HOME/thirdparty/hadoop/hadoop-2.7.1-src/hadoop-dist/target/hadoop-2.7.1"
export HBASE_HOME="$HOME/thirdparty/hbase/hbase-1.1.1/hbase"
export HIVE_HOME="$HOME/thirdparty/hive/packaging/target/apache-hive-1.2.0-SNAPSHOT-bin/apache-hive-1.2.0-SNAPSHOT-bin"

export PATH="${PATH}:/Applications/IntelliJ\ IDEA\ 11.app/Contents/MacOS"
export PATH="${PATH}:/Applications/MacVim.app/Contents/MacOS"
export PATH="${PATH}:/Library/Frameworks/JRuby.framework/Versions/Current/bin"
export PATH="${PATH}:/Library/Haskell/bin"
export PATH="${PATH}:/usr/local/opt/go/libexec/bin"
export PATH="${PATH}:$GOROOT/bin:$GOPATH/bin"
export PATH="${PATH}:$HOME/.local/lib/aws/bin"
export PATH="${PATH}:$HOME/.shelly/bin"
export PATH="${PATH}:$HOME/thirdparty/db-derby-10.10.1.1-bin/bin"
export PATH="${PATH}:$HOME/venvs/tools/bin"
export PATH="/Applications/Vagrant/bin:${PATH}"
export PATH="/Library/PostgreSQL/9.6/bin:${PATH}"
export PATH="/usr/local/mysql/bin:${PATH}"
export PATH="/usr/local/heroku/bin:${PATH}"
export PATH="/usr/local/sbin:${PATH}"
export PATH="/usr/local/bin:${PATH}"
export PATH="$HOME/thirdparty/nim-0.16.0/bin:${PATH}"
export PATH="$HOME/thirdparty/scala-2.11.5/bin:${PATH}"
export PATH="$HOME/thirdparty/dart/dart-sdk/bin:${PATH}"
export PATH="$CONFLUENT_HOME/bin:${PATH}"
export PATH="$HOME/.rvm/bin:${PATH}" # Add RVM to PATH for scripting
export PATH="$HOME/.yarn/bin:$PATH"

# See .bashrc for end of file configs
