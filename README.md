# ubuntu_setup

## graphic driver problem (nouveau)
if your computer has nvidia graphic card and driver, you may have a problem with nouveau (ex: not booted up)
so you have to turn off nouveau. 
from: [nouveau](https://blog.neonkid.xyz/66 "link")

* at GNU grub, type 'e' and append 'nouveau.modeset=0' to turn off the nouveau temporarily
* make file
```
$ sudo gedit /etc/modprobe.d/blacklist-nouveau.conf
```
and save after writing these:
```
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
```
