```
wget -O /etc/fail2ban/blacklist.conf https://raw.githubusercontent.com/aiastia-script/banip/refs/heads/master/fail2ban/blacklist.conf
wget -O /etc/fail2ban/ip.blacklist https://raw.githubusercontent.com/aiastia-script/banip/refs/heads/master/fail2ban/ip.blacklist
wget -O /etc/fail2ban/jail.local https://raw.githubusercontent.com/aiastia-script/banip/refs/heads/master/fail2ban/jail.local
```
sudo systemctl restart fail2ban
sudo fail2ban-client status
