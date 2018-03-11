#! /usr/bin/env bash

i=1
function inc () { i=$(( i + 1 )); }

# OS
inc; sysinfo[$i]="* Operating System"
inc; sysinfo[$i]="uname -a"
inc; sysinfo[$i]="cat /etc/{issue,*-release}"
inc; sysinfo[$i]="cat /proc/version"
inc; sysinfo[$i]="dmesg | grep -i linux"
inc; sysinfo[$i]="ls /boot/*vmlinuz*"

# environment variables
inc; sysinfo[$i]="* Environment Variables"
inc; sysinfo[$i]="head -n 1024 /etc/{profile,bashrc} ~/.{bash_profile,profile,bashrc}"
inc; sysinfo[$i]="env"
# inc; sysinfo[$i]="set" # too much output
inc; sysinfo[$i]="alias"

# processes and programs

inc; sysinfo[$i]="* Processes and packages"
inc; sysinfo[$i]="ps aux"
inc; sysinfo[$i]="cat /etc/services"
inc; sysinfo[$i]="ps aux | grep ^root"
#inc; sysinfo[$i]="ls -lhA {,/usr,/usr/local}/bin"   # too much output
#inc; sysinfo[$i]="ls -lhA {,/usr,/usr/local}/sbin"
# inc; sysinfo[$i]="ls -lhA /opt"
inc; sysinfo[$i]="rpm -qa || dpkg -l" # add other pkg managers
inc; sysinfo[$i]="head -n 1024 /etc/{syslog,chttp,lighthttpd,cups,cups/cupsd,inetd,apache2/apache2,my,rc,httpd/conf/httpd}.conf"

# jobs
inc; sysinfo[$i]="* Jobs"
inc; sysinfo[$i]="crontab -l"
inc; sysinfo[$i]="ls -lhA /var/spool/cron"
inc; sysinfo[$i]="ls -lhAR /etc/cron*"
inc; sysinfo[$i]="head -n 1024 /etc/*cron* /etc/cron*/*"
inc; sysinfo[$i]="head -n 1024 /etc/at.*"
inc; sysinfo[$i]="cat /var/spool/cron/crontabs/root"

# credentials in the clear?
inc; sysinfo[$i]="* Credentials in the clear?"
inc; sysinfo[$i]="find / -name '*.php' -exec grep -ni 'var \$pass' {} + 2> /dev/null"
inc; sysinfo[$i]="head -n 1024 ~/.ssh/*"
inc; sysinfo[$i]="head -n 4096 /etc/ssh/*config*"

# interesting permissions
inc; sysinfo[$i]="* Interesting Permissions"
inc; sysinfo[$i]="find / -type f -perm -6000 -exec ls -l {} + 2> /dev/null"
inc; sysinfo[$i]="find / -type f -perm -0002 -exec ls -l {} + 2> /dev/null"
inc; sysinfo[$i]="find / -type d -perm -1000 -exec ls -l {} + 2> /dev/null"
inc; sysinfo[$i]="mount"
inc; sysinfo[$i]="df -h"
inc; sysinfo[$i]="cat /etc/fstab"
inc; sysinfo[$i]="cat /etc/crypttab"
inc; sysinfo[$i]="cat /etc/mtab"
inc; sysinfo[$i]="ls -lAhR /var/www/"
inc; sysinfo[$i]="find /var/log -type f -perm -0001"


# users
inc; sysinfo[$i]="* Users"
inc; sysinfo[$i]="id"
inc; sysinfo[$i]="w; who; last; lastlog"
inc; sysinfo[$i]="cat /etc/passwd"
inc; sysinfo[$i]="cat /etc/group"
inc; sysinfo[$i]="cat /etc/sudoers"
inc; sysinfo[$i]="ls -lhAR /home"
inc; sysinfo[$i]="tail -n 512 ~/.*_history"

# Network
inc; sysinfo[$i]="* Network"
inc; sysinfo[$i]="/sbin/ifconfig -a"
inc; sysinfo[$i]="cat /etc/network/inferfaces"
inc; sysinfo[$i]="cat /etc/sysconfig/network"
inc; sysinfo[$i]="netstat -antupx"
inc; sysinfo[$i]="cat /etc/resolv.conf"
inc; sysinfo[$i]="/sbin/route -n"
inc; sysinfo[$i]="hostname"
inc; sysinfo[$i]="domainname"
inc; sysinfo[$i]="dnsdomainname"
inc; sysinfo[$i]="iptables -L"
inc; sysinfo[$i]="tcpdump -c 1 -i any"
inc; sysinfo[$i]="lpstat -a"


tmux display-message "Running Linux Local Enumeration script..."
# prepend spaces to commands to avoid history logging
log=/tmp/.recon.org
rm -rf $log
#tmux send-keys "stty -echo" Enter
sleep 1
for ((i=1; i < ${#sysinfo[@]}; i++)); do
    cmd="${sysinfo[$i]}"
    [ -n "$cmd" ] || continue
    if grep -q '^\*' <<< "$cmd"; then
      # category heading
      tmux send-keys " echo -e '\n$cmd' >> $log" Enter
    else
      tmux send-keys " echo -e '\n** $cmd' >> $log" Enter
      tmux send-keys " echo -e '\n#+BEGIN_EXAMPLE' >> ${log}" Enter
      tmux send-keys " ($cmd) &>> ${log}" Enter
      tmux send-keys " echo -e '\n#+END_EXAMPLE' >> ${log}" Enter
    fi
done
#tmux send-keys "stty echo" Enter
tmux send-keys " ###### FINISHED ######" Enter

tmux display-message "Reconnaissance log in $log"
