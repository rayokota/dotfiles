if [ -f "$HOME/.bashrc" ]; then
  source ~/.bashrc
  cd . || exit
fi

# prevent tmux from triggering the path to be updated with duplicate items
if [[ -z $TMUX ]]; then
  # Always add to end of PATH (safer)
  export PATH="${PATH}:/Applications/MacVim.app/Contents/MacOS"
  export PATH="${PATH}:/Library/Frameworks/JRuby.framework/Versions/Current/bin"
  export PATH="${PATH}:/Library/Haskell/bin"
  export PATH="${PATH}:$GOROOT/bin:$GOPATH/bin"
  export PATH="${PATH}:$HOME/.local/lib/aws/bin"
  export PATH="${PATH}:$CONFLUENT_HOME/bin"
fi
