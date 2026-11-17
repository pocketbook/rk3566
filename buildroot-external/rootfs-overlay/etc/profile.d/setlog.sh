function setlog() {
	rm -f /mnt/secure/syslog /mnt/secure/klog
	[ -n "$1" ] && ln -s $1 /mnt/secure/syslog
	[ -n "$2" ] && ln -s $2 /mnt/secure/klog
	killall -INT xlog 2>/dev/null
}

alias 0='setlog'
alias 1='TTY="$(tty)" || TTY=/dev/console ; setlog "$TTY"'
alias 2='TTY="$(tty)" || TTY=/dev/console ; setlog "$TTY" "$TTY"'
alias 3='touch /tmp/syslog ; setlog "/tmp/syslog"'
alias 4='touch /tmp/syslog ; setlog "/tmp/syslog" "/tmp/syslog"'
alias 9='killall -USR1 xlog'

