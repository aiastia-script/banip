# banip
瞎扫vps的ip

vi /etc/hosts.deny
````
wget https://raw.githubusercontent.com/aiastia/banip/master/hosts.deny 
````
````
cat hosts.deny >> /etc/hosts.deny
````




````
cp --no-preserve=mode,ownership /home/ubuntu/hosts.deny /etc/hosts.deny
````
