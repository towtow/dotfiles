# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

umask 022

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

function cleansandbox {
    svn revert -R .
    svn st | grep ^\? | cut -c3- | xargs rm -r 2>/dev/null
    svn st
    svn up
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
    /usr/bin/mvn $* | sed \
	-e 's/\(\[WARN\].*\)/[33m\1[0m/g' \
	-e 's/\(\[WARNING\].*\)/[33m\1[0m/g' \
	-e 's/\(\[INFO\].*\)/[1;34m\1[0m/g' \
	-e 's/\(\[ERROR\].*\)/[1;31m\1[0m/g' \
	-e '/Tests run.*Failures: 0, Errors: 0, Skipped: 0/s/\(.*\)/[0;32m\1[0m/g' \
	-e '/Tests run.*Failures: [^0].*, Errors: 0, Skipped: 0/s/\(.*\)/[0;31m\1[0m/g' \
	-e '/Tests run.*Failures: 0, Errors: [^0], Skipped: 0/s/\(.*\)/[0;31m\1[0m/g' \
	-e '/Tests run.*Failures: 0, Errors: 0, Skipped: [^0]/s/\(.*\)/[0;33m\1[0m/g'
    # [0;31m red[0m
    # [0;32m green[0m
    # [0;33m yellow[0m
    # [0;37m white[0m
}
function use_java() {
    export JAVA_HOME=$1
    export PATH=$JAVA_HOME/bin:$PATH
    java -version
}
alias ls="ls --color"
alias grep="grep --color=always"
alias less="less -R"
alias vi="vim"
alias sqlplus="rlwrap /opt/instantclient/sqlplus"
alias idea="/opt/idea/bin/idea.sh >/dev/null 2>&1 &"
alias e="emacsclient --no-wait"
alias nslookup="rlwrap /usr/bin/nslookup"
alias dba="sqlplus system/NevrL8@localhost:1521/xe"
alias g="cd ~/ng/git"
alias gjb="cd ~/ng/git/local/jboss/bin ; ./run.sh"
alias gdb="sqlplus tow_git/tow_git@localhost:1521/xe"
alias t="cd ~/ng/trunk"
alias tjb="cd ~/ng/trunk/local/jboss/bin ; ./run.sh"
alias tdb="sqlplus tow_trunk/tow_trunk@localhost:1521/xe"
alias b1="cd ~/ng/branch1"
alias b1jb="cd ~/ng/branch1/local/jboss/bin ; ./run.sh"
alias b1db="sqlplus tow_branch1/tow_branch1@localhost:1521/xe"
alias b2="cd ~/ng/branch2"
alias b2jb="cd ~/ng/branch2/local/jboss/bin ; ./run.sh"
alias b2db="sqlplus tow_branch2/tow_branch2@localhost:1521/xe"
alias r="cd ~/ng/release"
alias rjb="cd ~/ng/release/local/jboss/bin ; ./run.sh"
alias rdb="sqlplus tow_release/tow_release@localhost:1521/xe"
alias f="find . -name"
alias l="ls -l"
alias a="ant -DskipTests=true"
alias m="a makeAll deploy"
alias cm="a clean undeploy makeAll deploy"
alias fresh="a clean undeploy makeAll deploy freshEnv"
alias mkknownhosts="scp root@monitoring.prod.dc.local:/etc/ssh/ssh_known_hosts /home/tow/.ssh/known_hosts && cat /home/tow/.ssh/additional_known_hosts >>/home/tow/.ssh/known_hosts"
alias v="evince >/dev/null 2>&1"
alias mvn=color_maven
alias maven=/usr/bin/mvn
alias sshpw="ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no"
alias ipmi="~/IPMIView_V2.10.2_bundleJRE_Linux_x64_20150909/IPMIView20 >/dev/null 2>&1 </dev/null &"
alias pm-mobile="nvm use pm-mobile ; export ANDROID_HOME=/opt/android-sdk ; j8 ; export PATH=\${ANDROID_HOME}/platform-tools:\${ANDROID_HOME}/tools:\${PATH} ; export LD_LIBRARY_PATH=\${ANDROID_HOME}/tools/lib64 ; cd ~/ng/pm-mobile"
alias geny='/opt/genymobile/genymotion/genymotion >/dev/null 2>&1 &'
alias d=docker
alias j6='use_java /usr/lib/jvm/java-6-oracle'
alias j7='use_java /usr/lib/jvm/java-7-oracle'
alias j8='use_java /usr/lib/jvm/java-8-oracle'
alias mm='mvn -Pdev -Ptest -DskipTests'
alias mdep='mm dependency:tree -Dverbose'
alias gitsvnup='git co master && git svn fetch && git svn rebase && git co release && git svn fetch && git svn rebase && git co work && git rebase master'
alias gm='g && git co master'
alias gw='g && git co work'
alias prod='ssh root@monitoring.prod.dc.local'
alias ref='ssh root@hadoop.ref.dc.local'
alias jp9='~/jprofiler9/bin/jprofiler >/dev/null 2>&1 </dev/null &'

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

function grepjars {
    if [ -z "$1" ] ; then
	echo "Usage: grepjars <Pattern>"
    else
	for i in *.?ar ; do jar tvf $i | grep $1 && echo $i ; done
    fi
}

function jcprod {
    local SSHPID
    ssh -N -D 7778 root@ng${1}.prod.dc.local &
    SSHPID=$!
    sleep 3
    jconsole -J-DsocksProxyHost=localhost -J-DsocksProxyPort=7778 service:jmx:rmi:///jndi/rmi://localhost:8282/jmxrmi -J-DsocksNonProxyHosts=
    kill $SSHPID
}

function svn-old-branches {
    local twoweeksago=$(date -I -d '2 weeks ago')
    svn-branch-creation-dates | (
	while read i ; do
	    local x=($i)
	    if [ "${x[0]}" \< "$twoweeksago" ] ; then
		echo $i
	    fi
	done
    )
}

function svn-branch-creation-dates {
    (for i in $(svn ls svn://svn.muc.local/ng.platform/branches) ; do
	 echo "$(svn-branch-creation-date ${i}) ${i}"
     done)|sort -k1
}

function svn-branch-creation-date {
    echo "$(svn log --stop-on-copy --xml svn://svn.muc.local/ng.platform/branches/${1}|xmllint --xpath '//logentry[last()]/date/text()' -|cut -dT -f1)"
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
export PROMPT_COMMAND='settitle; svn_branch; history -a;'
# git+svn - export PS1='\[\e${usercolor}\][\u]\[\e${gitcolor}\]$(__git_ps1 "[%s]")\[\e${gitcolor}\]${svnbranch}\[\e${cwdcolor}\][$PWD]\[\e${inputcolor}\] ➤ '
# svn only - export PS1='\[\e${usercolor}\][\u]\[\e${gitcolor}\]${svnbranch}\[\e${cwdcolor}\][$PWD]\[\e${inputcolor}\] ➤ '
export PS1='\[\e${usercolor}\][\u]\[\e${gitcolor}\]$(__git_ps1 "[%s]")\[\e${gitcolor}\]${svnbranch}\[\e${cwdcolor}\][$PWD]\[\e${inputcolor}\] ➤ '
export PS2=' | '

eval `dircolors ~/.dir_colors`

[[ -s "/home/tow/.sdkman/bin/sdkman-init.sh" ]] && source "/home/tow/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="/home/tow/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export TERM=xterm

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

export PATH=/home/tow/bin:$PATH:/home/tow/.gem/ruby/2.1.0/bin:/home/tow/.gem/ruby/2.3.0/bin
export SQLPATH=/home/tow/.sqlplus

setxkbmap -option caps:none
