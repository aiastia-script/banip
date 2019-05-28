# banip
瞎扫vps的ip

vi /etc/hosts.deny
````
sudo wget https://raw.githubusercontent.com/aiastia/banip/master/hosts.deny -O hosts.deny 
````



````
sudo cp --no-preserve=mode,ownership ./hosts.deny /etc/hosts.deny
````


允许的ip

````
sudo wget https://raw.githubusercontent.com/aiastia/banip/master/hosts.allow -O hosts.allow 
````
````
sudo cp --no-preserve=mode,ownership ./hosts.allow /etc/hosts.allow
````
````
echo ALL:ALL  > /etc/hosts.deny
````
````
echo ALL:1.1.1.1  >> /etc/hosts.allow
````


~~cat hosts.deny >> /etc/hosts.deny~~






