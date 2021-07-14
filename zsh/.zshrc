# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/fax/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gallois"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
 git
 zsh-syntax-highlighting
 zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ll="lsd -l"
alias lla="lsd -la"
alias cat="bat"
alias set_mac_kb="setxkbmap -variant mac"
alias set_pc_kb="setxkbmap -variant azerty"

PATH="/home/fax/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/fax/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/fax/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/fax/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/fax/perl5"; export PERL_MM_OPT;


#echo $var

proxy_address="http://gateway.schneider.zscaler.net:80/"


function set_schneider_env(){
    setxkbmap -variant latin9

    export {http,https,ftp}_proxy=$proxy_address
    export {HTTP,HTTPS,FTP}_PROXY=$proxy_address

    sed -i "s/#use_proxy/ use_proxy/" /home/fax/.wgetrc
    sed -i "s/#http_proxy/ http_proxy/" /home/fax/.wgetrc
    sed -i "s/#https_proxy/ https_proxy/" /home/fax/.wgetrc
    sed -i "s/#ftp_proxy/ ftp_proxy/" /home/fax/.wgetrc
    printf "Proxies =S= set\n"
}

function set_home_env(){

    setxkbmap -variant mac

    unset {HTTP,HTTPS,FTP}_PROXY
    unset {http,https,ftp}_proxy

    sed -i 's/ use_proxy/#use_proxy/' /home/fax/.wgetrc
    sed -i 's/ http_proxy/#http_proxy/' /home/fax/.wgetrc
    sed -i 's/ https_proxy/#https_proxy/' /home/fax/.wgetrc
    sed -i 's/ ftp_proxy/#ftp_proxy/' /home/fax/.wgetrc

    printf "Proxy =S= unset\n"
}

function set_proxy(){
    var=$(ping -q -c 1 -W 1 8.8.8.8)
    case $var in
        *100%*)
            printf 'You are at work\n'
            set_schneider_env;;
        *0%*)
            printf 'At home yeah\n'
            set_home_env;;
        *)
            printf 'Failed\n';;
    esac
}

set_proxy
