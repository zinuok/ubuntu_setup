# ubuntu_setup

## 1. graphic driver problem (nouveau)
if your computer has nvidia graphic card and driver, you may have a problem with nouveau (ex: not booted up)  
so you have to turn off nouveau. 
from: [nouveau_off](https://blog.neonkid.xyz/66 "link")

### at GNU grub, type 'e' and append 'nouveau.modeset=0' to turn off the nouveau temporarily
### make file
```
$ sudo gedit /etc/modprobe.d/blacklist-nouveau.conf
```
### save the file after writing these:
```
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
```
### set nouveau options to 0
```
$ sudo apt install dkms
$ sudo apt install build-essential
$ sudo apt install linux-header-generic
$ echo options nouveua modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
$ sudo update-initramfs -u
$ sudo reboot
```
### NVIDIA driver install
from: [nvidia_install](https://codechacha.com/ko/install-nvidia-driver-ubuntu/ "link")
* find recommended driver for your PC
```
$ ubuntu-drivers devices
```
* install the driver
```
$ sudo add-apt-repository ppa:graphics-drivers/ppa
$ sudo apt update
$ sudo apt install nvidia-driver-[driver#]
$ sudo reboot
```
## 2. install etc (terminator, vscode)
download and run my shell script [install_etc.sh](https://github.com/zinuok/ubuntu_setup/blob/master/install_etc.sh "link")
```
$ git clone
$ chmod +x install_etc.sh
$ ./install_etc.sh
```

