# ubuntu_setup
wget https://raw.githubusercontent.com/ROBOTIS-GIT/robotis_tools/master/install_ros_melodic.sh<br>

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
To solve time conflicting problem between Window and Linux,
```
$ timedatectl set-local-rtc 1 --adjust-system-clock
```

## 3. Hangul install
* Settings -> Region&Language -> Manage Installed Languages -> Install/Remove Language...
then you can see 'Korean'
* reboot
* open the terminal
```
$ ibus-setup
```
* add Hangul in ibus-setup: Input Method -> Add -> ... -> Korean -> Hangul
* add Hangul input source: Settings -> Region&Language -> Add an Input Source 
* click 'gear' button
* add transition key input and check 'Start in Hangul mode'

## 4. ROS Melodic & mavros/gazebo9 install (for Ubuntu 18.04 LTS)
from [here](https://dev.px4.io/master/en/setup/dev_env_linux_ubuntu.html)  
(this scripts includes px4 Firmware installation)
```
$ cd ~/ubuntu_setup/
$ chmod +x ubuntu_sim_ros_melodic.sh
$ bash ubuntu_sim_ros_melodic.sh
```
git
## 5. QgroundControl install
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


## 6. 'Mac Mojave' Theme install
from [here](https://itlearningcenter.tistory.com/entry/%E3%80%901804-LTS%E3%80%91%EC%9A%B0%EB%B6%84%ED%88%AC-%ED%85%8C%EB%A7%88-%EA%BE%B8%EB%AF%B8%EA%B8%B0 "link")

* Genome tweak install
```
$ sudo apt-get install -y gnome-tweak-tool
```
* add repository
```
$ sudo add-apt-repository ppa:noobslab/macbuntu
$ sudo apt-get update
$ sudo apt-get install -y macbuntu-os-ithemes-v1804
$ sudo apt-get install -y macbuntu-os-icons-v1804
```


* themes
  * download from [here](https://www.pling.com/p/1275087 "link")
  * unzip and copy
  ```
  $ tar -xf [fime name]
  $ mkdir ~/.themes
  $ sudo cp [file name] ~/.themes
  ```
  * apply  
    open gnome-tweak, go to 'Appearance' tab --> Themes --> Applications
    
* icon
  * download from [here](https://www.gnome-look.org/p/1210856/ "link")
  * unzip and copy
  ```
  $ tar -xf [fime name]
  $ mkdir ~/.icons
  $ sudo cp [file name] ~/.icons
  ```
  * apply  
    open gnome-tweak, go to 'Appearance' tab --> Themes --> Icons

* cursor
  * download from [here](https://www.gnome-look.org/p/1384420/ "link")
  * unzip and copy
  ```
  $ unzip [fime name]
  ```
  * apply  
    open gnome-tweak, go to 'Appearance' tab --> Themes --> Cursor

* dock
  * plank dock install
  ```
  sudo apt-get install -y plank
  sudo add-apt-repository ppa:noobslab/macbuntu && sudo apt update
  sudo apt-get install -y macbuntu-os-plank-theme-lts-v7
  ```
  * add to startup app  
  tweaks --> Startup Applications --> +
  * plank mac theme install
    * download from [here](https://www.gnome-look.org/p/1264834/ "link")
    * copy
    ```
    sudo cp -r [file name] ~/.themes
    ```
    * apply in plank preferences
    
  * remove original dock
  ```
  $ sudo apt remove gnome-shell-extension-ubuntu-dock
  $ reboot
  ```

* terminal
