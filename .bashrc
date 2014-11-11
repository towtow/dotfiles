# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

function cleansandbox {
	svn revert -R .
	svn st | grep ^\? | cut -c3- | xargs rm -r 2>/dev/null
	svn st
	echo Cleaned.
}
function fixsandbox {
	local SVNURL
	SVNURL=`svn info | grep ^URL | cut -d' ' -f2`
	find . -name .svn -type d -print0 2>/dev/null | xargs -0 rm -rf
	svn co --force $SVNURL . >/dev/null
	svn st
	echo Fixed.
}
function color_maven {
  $M2_HOME/bin/mvn $* | sed -e 's/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/[1;32mTests run: \1[0m, Failures: [1;31m\2[0m, Errors: [1;33m\3[0m, Skipped: [1;34m\4[0m/g' \
    -e 's/\(\[WARN\].*\)/[1;33m\1[0m/g' \
    -e 's/\(\[INFO\].*\)/[1;34m\1[0m/g' \
    -e 's/\(\[ERROR\].*\)/[1;31m\1[0m/g'
}

alias ls="ls --color"
alias grep="grep --color=always"
alias less="less -R"
alias vi="vim"
alias sqlplus="rlwrap $ORACLE_HOME/bin/sqlplus"
alias idea="/opt/idea/bin/idea.sh >/dev/null 2>&1 &"
alias e="emacsclient"
alias nslookup="rlwrap /usr/bin/nslookup"
alias trunkdb="sqlplus tow_trunk/tow_trunk@//localhost:1521/XE"
alias branch1db="sqlplus tow_branch1/tow_branch1@//localhost:1521/XE"
alias branch2db="sqlplus tow_branch2/tow_branch2@//localhost:1521/XE"
alias releasedb="sqlplus tow_release/tow_release@//localhost:1521/XE"
alias tjb="cd ~/ng/trunk/local/jboss/bin ; ./run.sh"
alias b1jb="cd ~/ng/branch1/local/jboss/bin ; ./run.sh"
alias b2jb="cd ~/ng/branch2/local/jboss/bin ; ./run.sh"
alias rjb="cd ~/ng/release/local/jboss/bin ; ./run.sh"
alias forge=~/dev/TriggerToolkit/forge
alias nocaps="setxkbmap -option caps:none"
alias f="find . -name"
alias l="ls -l"
alias m="ant -Dskip.tests=true makeAll"
alias cuma="ant -Dskip.tests=true clean undeploy makeAll"
alias fresh="ant -Dskip.tests=true clean undeploy makeAll freshEnv"
alias mkknownhosts="scp root@monitoring.prod.dc.local:/etc/ssh/ssh_known_hosts /home/tow/.ssh/known_hosts && cat /home/tow/.ssh/additional_known_hosts >>/home/tow/.ssh/known_hosts"
alias v="evince >/dev/null 2>&1"
alias mvn=color_maven
alias maven=$M2_HOME/bin/mvn

# Bash history settings
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignoredups:ignorespace
export HISTIGNORE='ls:history:ll'
export HISTTIMEFORMAT='%F %T '
# Append to bash_history instead of overwriting
shopt -s histappend

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# get current git branch name
function git_branch {
    export gitbranch=[$(git rev-parse --abbrev-ref HEAD 2>/dev/null)]
    if [ "$?" -ne 0 ]
      then gitbranch=
    fi
    if [[ "${gitbranch}" == "[]" ]]
      then gitbranch=
    fi
}

function svn_branch {
  export svnbranch=[$(svn info 2>/dev/null | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$' | sed -e 's/\(.*\)/\1/')]
    if [ "$?" -ne 0 ]
      then svnbranch=
    fi
    if [[ "${svnbranch}" == "[]" ]]
      then svnbranch=
    fi
}
 
# set usercolor based on whether we are running with Admin privs
function user_color {
    id | grep "Admin" > /dev/null
    RETVAL=$?
    if [[ $RETVAL == 0 ]]; then
        usercolor="[0;35m";
    else
        usercolor="[0;32m";
    fi
}
 
# Set prompt and window title
inputcolor='[0;37m'
cwdcolor='[0;34m'
gitcolor='[1;31m'
user_color
 
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
export PROMPT_COMMAND='settitle; git_branch; svn_branch; history -a;'
# git+svn - export PS1='\[\e${usercolor}\][\u]\[\e${gitcolor}\]${gitbranch}\[\e${gitcolor}\]${svnbranch}\[\e${cwdcolor}\][$PWD]\[\e${inputcolor}\] ➤ '
export PS1='\[\e${usercolor}\][\u]\[\e${gitcolor}\]${svnbranch}\[\e${cwdcolor}\][$PWD]\[\e${inputcolor}\] ➤ '
export PS2=' | '

eval `dircolors ~/.dir_colors`

[[ -s "/home/tow/.gvm/bin/gvm-init.sh" ]] && source "/home/tow/.gvm/bin/gvm-init.sh"

export NVM_DIR="/home/tow/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export TERM=screen-256color-bce

preexec () {
    echo -n "[1;34m[0m" && :;
}
preexec_invoke_exec () {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
    local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
    preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG
