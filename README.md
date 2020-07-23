# ubuntu_setup

## 1. graphic driver problem (nouveau)
if your computer has nvidia graphic card and driver, you may have a problem with nouveau (ex: not booted up)  
so you have to turn off nouveau. 
from: [here](https://blog.neonkid.xyz/66 "link")

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
$ sudo apt install -y dkms
$ sudo apt install -y build-essential
$ sudo apt install linux-headers-$(uname -r)
$ echo options nouveua modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
$ sudo update-initramfs -u
$ sudo reboot
```
### NVIDIA driver install
from: [here](https://codechacha.com/ko/install-nvidia-driver-ubuntu/ "link")
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
  
   
   
## 2. etc install (chrome browser, terminator, vscode)
download and run my shell script [install_etc.sh](https://github.com/zinuok/ubuntu_setup/blob/master/install_etc.sh "link")
```
$ git clone https://github.com/zinuok/ubuntu_setup.git
$ chmod +x install_etc.sh
$ ./install_etc.sh
```

## 3. ROS Melodic & mavros/gazebo9 install
from: [here](https://raw.githubusercontent.com/PX4/Devguide/v1.9.0/build_scripts/ubuntu_sim_ros_melodic.sh "link")  
(this is for Ubuntu 18.04 LTS)
```
$ chmod +x ubuntu_sim_ros_melodic_update.sh
$ ./ubuntu_sim_ros_melodic_update.sh
```

## 4. QgroundControl install
from: [here](https://docs.qgroundcontrol.com/en/getting_started/download_and_install.html "link")
* install plugin
```
$ sudo usermod -a -G dialout $USER
$ sudo apt-get remove modemmanager -y
$ sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
```
* download image file
download from [here](https://s3-us-west-2.amazonaws.com/qgroundcontrol/latest/QGroundControl.AppImage "link")
* execute
```
$ chmod +x ./QGroundControl.AppImage
$ ./QGroundControl.AppImage  (or double click)
```
## 5. Mac OS Theme install

