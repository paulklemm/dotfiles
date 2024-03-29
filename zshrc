# source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM="xterm-256color"
# Path to your oh-my-zsh installation.
export ZSH=/Users/paul/.oh-my-zsh

# Autocomplete MAN pages: https://news.ycombinator.com/item?id=4073676
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to disable bi-weekly auto-update prompt.
DISABLE_UPDATE_PROMPT=true

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages colorize zsh-autosuggestions zsh-syntax-highlighting)

# User configuration
# Gitignore.io function
function gi() { curl https://www.gitignore.io/api/$@ ;}

export EDITOR='code'
export PATH=$PATH:/Users/paul/.rvm/gems/ruby-2.2.0/bin:/Users/paul/.rvm/gems/ruby-2.2.0@global/bin:/Users/paul/.rvm/rubies/ruby-2.2.0/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/local/mysql/bin:/Applications/MATLAB_R2013b.app/bin:/usr/local/opt/ruby/bin:/usr/local/sbin:/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin:/Users/paul/.rvm/bin:/Users/paul/.cabal/bin
export PATH=/Users/paul/anaconda3/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"
# Autojump configuration
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
xx() {
  curl cheat.sh/$1
}

# open fzf window with dirs and cd into it - https://prakashdanish.github.io/2018/08/03/command-line-dir-switcher.html
function quick_find () {
    dir=$(find ~ -not -path '*/\.*' -type d -maxdepth 5 | fzf)
    echo -ne "$dir"
    cd $dir
}
zle -N quick_find_widget quick_find # define a widget for the func above
bindkey "^p" quick_find_widget # remap ^p to the widget -> func

# Function for opening location with code and sublime merge
function open_with_code_and_sublime_merge {
    code $1
    smerge $1
}

alias sc="open_with_code_and_sublime_merge"

# Attach remotely to a tmux session that is a combination of the folder name and the MD5 hash of the path
# Adapted from https://medium.com/@joaomoreno/persistent-terminal-sessions-in-vs-code-8fc469ed6b41
function rmux {
    # Get folder name and remove all dots from it
    FOLDER_NAME=$(echo ${PWD##*/} | sed s/\\./_/g)
    SUM=`pwd | md5sum | sed s/\\s//g | sed s/-//g`
    # Only extract the first elements from SUM to make it shorter
    SUM=${SUM:0:3}
    # Get current work folder, create md5sum, remove all whitespace characters, remove all dashes
    SESSION="${FOLDER_NAME}_${SUM}"
    tmux new-session -A -s $SESSION
}

# Enable fzf - https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Disable duplicate entries in the history - https://github.com/junegunn/fzf/issues/600#issuecomment-360075347
setopt HIST_IGNORE_ALL_DUPS

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
