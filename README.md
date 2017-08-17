bash-environment
================

Bash environment files for OS X (or other unix).


- Clone repo
```sh
cd $HOME
git clone https://github.com/jmfee-usgs/bash-environment.git
```

- Load in profile (`$HOME/.bash_profile` or similar):
```sh
# git utility functions
. ./bash-environment/git-functions.sh

# git bash prompt
. ./bash-environment/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export PS1='\u@\h:\w$(__git_ps1 " (%s)")\n\$ '
```
