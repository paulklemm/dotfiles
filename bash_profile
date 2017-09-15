# This is my old Bash Profile. Since I now switched to ZSH this is barely put to use.
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=/Applications/MATLAB_R2013b.app/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export NODE_PATH="/usr/local/lib/node"
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:$PATH"
export CLICOLOR=1
# Ruby RVM
source ~/.profile
export LD_LIBRARY_PATH=/usr/local/cuda/lib$LD_LIBRARY_PATH
export LSCOLORS=GxFxCxDxBxegedabagacedsource
alias ls='ls -Glah' 
git_branch () {
    if git rev-parse --git-dir >/dev/null 2>&1
        then echo -e "" [$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')]
    else
        echo ""
    fi
}
function git_color {
    local STATUS=`git status 2>&1`
    if [[ "$STATUS" == *'Not a git repository'* ]]
        then echo ""
    else
    if [[ "$STATUS" != *'working directory clean'* ]]
        then
        # red if need to commit
        echo -e '\033[0;31m'
    else
    if [[ "$STATUS" == *'Your branch is ahead'* ]]
        then
        # yellow if need to push
        echo -e '\033[0;33m'
    else
        # else cyan
        echo -e '\033[0;32m'
    fi
    fi
    fi
}
export PS1='\[\033[0;35m\] λ \[\033[0;36m\]\w/\[$(git_color)\]$(git_branch)\[\033[m\] '
source "`brew --prefix`/etc/grc.bashrc"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*