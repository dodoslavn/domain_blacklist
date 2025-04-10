# Blacklist of domains marked for scam/spam activities
Script which downloads list of domains which are marked for bad activities, and set them to not translate in your DNS.
## Preparations/requirements
You will need Unbound DNS server,  
and you will need to add to the Unbound config /etc/unbound/unbound.conf , in the "server:" part, this line:
> include: /etc/unbound/blacklist/*.txt

Create the folder and set permission:
> mkdir /etc/unbound/blacklist/  
> chmod 755 /etc/unbound/blacklist/  
> chown unbound:unbound 755 /etc/unbound/blacklist/  
## Installation
> su - root  
> \# move to some permanent folder  
> git clone https://github.com/dodoslavn/domain_blacklist.git  
> ./scripts/install.sh
## Verification
Get any blacklisted DNS record from the list
> head -1 /etc/unbound/blacklist/"$(ls /etc/unbound/blacklist/ | head -1)"

Example output:  
> local-zone: "000aproxy.on-4.com" always_nxdomain  

Test the domain in public DNS:
> dig +short @8.8.8.8 000aproxy.on-4.com

This should return some IP, meaning translation was successful and the domain fully works.  
Now lets test our own DNS:
> dig +short @127.0.0.1 000aproxy.on-4.com
> 
This should return nothing, meaning the blacklist is working. You can now start using this DNS in your devices.
