# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

umask 0022

####################################################################################################################################
# Environment
####################################################################################################################################
export PATH="$HOME/bin:/home/tow/Fortify/Fortify_SCA_and_Apps_19.2.0/bin:$PATH"

export PROMPT_COMMAND='history -a'

function use_java() {
    export JAVA_HOME=$1
    export PATH=$JAVA_HOME/bin:$PATH
    java -version
}
alias ls="ls --color"
alias less="less -R"
alias idea="/opt/idea/bin/idea.sh >/dev/null 2>&1 &"
alias e="emacsclient --no-wait"
alias nslookup="rlwrap /usr/bin/nslookup"
alias g="cd ~/ng/pm-platform"
alias f="find . -name"
alias l="ls -l"
alias at="ant -Dbuild.env=dev"
alias a="at -DskipTests=true"
alias m="a makeAll"
alias mt="at makeAll"
alias cm="a clean makeAll"
alias cmt="at clean makeAll"
alias fresh="a clean makeAll freshEnv"
alias v="evince >/dev/null 2>&1"
alias sshpw="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
alias d=docker
alias j8='use_java /usr/lib/jvm/java-8-oracle'
alias j11='use_java /usr/lib/jvm/jdk-11.0.1'
alias oj8='use_java /usr/lib/jvm/java-8-openjdk-amd64'
alias oj11='use_java /usr/lib/jvm/java-11-openjdk-amd64'
alias mm='./mvnw -Pdev -DskipTests'
alias mdep='mm dependency:tree -Dverbose'
alias jp9='~/jprofiler9/bin/jprofiler >/dev/null 2>&1 </dev/null &'
alias mvnrelease='./mvnw --batch-mode release:prepare release:perform'
alias xmind='j8 >/dev/null 2>&1 && cd /home/tow/bin/XMind/XMind_amd64 && ./XMind >/dev/null 2>&1 </dev/null &'
alias freeplane='j11 >/dev/null 2>&1 && /usr/bin/freeplane >/dev/null 2>&1 </dev/null &'
alias ociimages='oci compute image list | jq '"'"'.data[] | ."display-name", .id'"'"
alias firefox='/usr/bin/firefox --new-instance'
alias bastion-fedramp-qa='ssh twildgruber@bastion-ssvc301-1502097150.ap-southeast-2.elb.amazonaws.com'
alias bastion-dev='ssh -i ~/.ssh/id_rsa_bastion twildgru@100.105.152.76'
alias bastion-prod='ssh -i ~/.ssh/id_rsa_bastion twildgru@129.213.76.211'
alias bastion-fedramp-qa-ff='ssh -fN -D 5555 twildgruber@bastion-ssvc301-1502097150.ap-southeast-2.elb.amazonaws.com ; firefox -P proxy-bastion-dev >/dev/null 2>&1 &'
alias bastion-dev-ff='ssh -fN -D 5555 bastion-gbudevcorp ; firefox -P proxy-bastion-dev >/dev/null 2>&1 &'
alias bastion-prod-ff='ssh -i ~/.ssh/id_rsa_bastion -fN -D 5554 twildgru@129.213.76.211 ; firefox -P proxy-bastion-prod >/dev/null 2>&1 &'
alias cpm-ff='ssh -fN -D 5454 root@monitoring.prod.dc.local ; firefox -P proxy-cpm >/dev/null 2>&1 </dev/null & disown'
alias tap='terraform apply'
alias p='cd ~/acx/package-management'
alias install-mvnw='tar xf ~/.mvnw.tar'

# Bash history settings
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignoredups:ignorespace
export HISTIGNORE='ls:history:ll:secret-tool'
export HISTTIMEFORMAT='%F %T '
# Append to bash_history instead of overwriting
shopt -s histappend

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

function grepjars {
    if [ -z "$1" ] ; then
	echo "Usage: grepjars <Pattern>"
    else
	for i in *.?ar ; do jar tvf $i | grep $1 && echo $i ; done
    fi
}

# Set prompt and window title
inputcolor='[0;30m'
cwdcolor='[0;34m'
gitcolor='[1;31m'
usercolor='[0;32m'

# Setup for window title
export TTYNAME=$$
function settitle() {
  p=$(pwd);
  let l=${#p}-25
  if [ "$l" -gt "0" ]; then
    p=..${p:${l}}
  fi
  t="$TTYNAME $p"
  echo -ne "\e]2;$t\a\e]1;$t\a";
}

export EDITOR=emacsclient
export PROMPT_COMMAND='settitle; history -a;'
export PS1='\n\e[0;93m[\D{%Y-%m-%d %H:%M}]\e${usercolor}[\u@\h]\e${gitcolor}$(__git_ps1 "[%s]")\e${cwdcolor}[$PWD]\e${inputcolor}\n➤ '
export PS2='| '

eval `dircolors ~/.dir_colors`

preexec () {
    echo -n "[0m" && :;
}
preexec_invoke_exec () {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
    local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
    preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG

export SQLPATH=/home/tow/.sqlplus

####################################################################################################################################
# Autocomplete
####################################################################################################################################

. /etc/bash_completion

# docker
. /usr/share/bash-completion/completions/docker 
# d alias for docker
complete -F _docker d

# oci
source "$HOME/lib/oracle-cli/lib/python3.6/site-packages/oci_cli/bin/oci_autocomplete.sh"

# bazel
source "$HOME/.bazel/bin/bazel-complete.bash"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ANDROID_SDK_ROOT="$HOME/Android"
