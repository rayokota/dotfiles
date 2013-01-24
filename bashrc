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
alias jumpssh='ssh -A -t jumphost-001.int.yammer.com ssh $@' 
alias jumppdsh='ssh -A -t jumphost-001.int.yammer.com pdsh $@' 
alias mvnv='mvn versions:display-plugin-updates versions:display-dependency-updates'

shopt -s histappend
HISTFILESIZE=1000000
HISTSIZE=10000000
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'

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
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
 
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

export PATH="${PATH}:/Applications/IntelliJ\ IDEA\ 11.app/Contents/MacOS"
export PATH="${PATH}:/Applications/MacVim.app/Contents/MacOS"
export PATH="${PATH}:/Library/Frameworks/JRuby.framework/Versions/Current/bin"
export PATH="${PATH}:/Library/Haskell/bin"
export PATH="${PATH}:~/code/dropwizard-gen/bin"

export DYLD_LIBRARY_PATH=~/third-party/javacv-bin/javacv-macosx-x86_64/com/googlecode/javacv/cpp/macosx-x86_64
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home
export PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"

complete -F get_dropwizard_commands dropwizard
get_dropwizard_commands () {
    if [ -z $2 ] ; then
        COMPREPLY=(`dropwizard help -c`)
    else
        COMPREPLY=(`dropwizard help -c $2`)
    fi
}

