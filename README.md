# banip
瞎扫vps的ip

vi /etc/hosts.deny
````
sudo wget https://raw.githubusercontent.com/aiastia/banip/master/hosts.deny -O hosts.deny 
````

````
sudo wget https://raw.githubusercontent.com/aiastia/banip/master/hosts.allow -O hosts.allow 
````

````
sudo cp --no-preserve=mode,ownership ./hosts.deny /etc/hosts.deny
````

~~cat hosts.deny >> /etc/hosts.deny~~






