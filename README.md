# banip
瞎扫vps的ip

vi /etc/hosts.deny
````
sudo wget https://raw.githubusercontent.com/aiastia/banip/dev/hosts.deny -O hosts.deny 
````

````
sudo cp --no-preserve=mode,ownership ./hosts.deny /etc/hosts.deny
````

~~cat hosts.deny >> /etc/hosts.deny~~






例如：

A文件内容：

HAHAHAHA

B文件内容：

BALABALA

复制后结果：

HAHAHAHA

BALABALA

命令行下

使用cat命令

cat B >>  A

>>是在linux中是追加的意思，即为不覆盖原文件

>是重定向的意思，覆盖原文件。
