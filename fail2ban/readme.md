```
sudo wget -O /etc/fail2ban/filter.d/blacklist.conf https://raw.githubusercontent.com/aiastia-script/banip/refs/heads/master/fail2ban/blacklist.conf
sudo wget -O /etc/fail2ban/ip.blacklist https://raw.githubusercontent.com/aiastia-script/banip/refs/heads/master/fail2ban/ip.blacklist
sudo wget -O /etc/fail2ban/jail.local https://raw.githubusercontent.com/aiastia-script/banip/refs/heads/master/fail2ban/jail.local

sudo wget -O /etc/fail2ban/action.d/custom-ipset.conf https://raw.githubusercontent.com/aiastia-script/banip/refs/heads/master/fail2ban/custom-ipset.conf
```
sudo systemctl restart fail2ban


sudo fail2ban-client status

sudo fail2ban-client status blacklist

sudo fail2ban-client status sshd

sudo systemctl start fail2ban


sudo systemctl enable fail2ban
