# ubuntu_setup
wget https://raw.githubusercontent.com/ROBOTIS-GIT/robotis_tools/master/install_ros_melodic.sh<br>

## 1. graphic driver problem (nouveau)
if your computer has nvidia graphic card and driver, you may have a problem with nouveau (ex: not booted up)  
so you have to turn off nouveau. 
from: [here](https://blog.neonkid.xyz/66 "link")

### at GNU grub, type 'e' and append 'nouveau.modeset=0' to turn off the nouveau temporarily
### make file
```bash
sudo gedit /etc/modprobe.d/blacklist-nouveau.conf
```
### save the file after writing these:
```bash
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
```
### set nouveau options to 0
```bash
sudo apt install -y dkms
sudo apt install -y build-essential
sudo apt install linux-headers-$(uname -r)
echo options nouveua modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
sudo update-initramfs -u
sudo reboot
```
### NVIDIA driver install
from: [here](https://codechacha.com/ko/install-nvidia-driver-ubuntu/ "link")
* find recommended driver for your PC
```bash
ubuntu-drivers devices
```
* install the driver
```bash
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install nvidia-driver-[driver#]
sudo reboot
```  

### CUDA, cuDNN, PyTorch install
from: [here](https://velog.io/@skyfishbae/RTX3090-2%EB%8C%80-Ubuntu-18.04-%EB%94%A5%EB%9F%AC%EB%8B%9D-%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%B6%95-1-Nvidia-driver-Cuda-cuDNN-%EC%84%A4%EC%B9%98)
* be careful to clarify the compatibility of [GPU / CUDA / CUDA-cuDNN / Pytorch] version
* my setup: RTX 3060 Ti / CUDA 11.1 / cuDNN 8.5 / 1.8.0+cu111

* install CUDA 11.1
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.1.0/local_installers/cuda-repo-ubuntu1804-11-1-local_11.1.0-455.23.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-11-1-local_11.1.0-455.23.05-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu1804-11-1-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda
```

* If you have a problem kinds of "cuda : Depends: cuda-10-0 (>= 10.0.130)", (from [here](https://askubuntu.com/a/1281139))
```bash
wget https://developer.download.nvidia.com/compute/cuda/11.1.0/local_installers/cuda_11.1.0_455.23.05_linux.run
chmod +x cuda_11.1.0_455.23.05_linux.run 
sudo ./cuda_11.1.0_455.23.05_linux.run 
```

* install CUDA-cuDNN from [Download cuDNN v8.0.5 (November 9th, 2020), for CUDA 11.1](https://developer.nvidia.com/rdp/cudnn-archive)
```bash
tar -xzvf cudnn-11.1-linux-x64-v8.0.5.39.tgz
sudo cp cuda/include/cudnn*.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

# check if 'CUDNN_MAJOR 8' is printed
cat /usr/local/cuda/include/cudnn_version.h | grep CUDNN_MAJOR -A 2

# export envrionment variables
echo "export PATH=/usr/local/cuda-11.1/bin${PATH:+:${PATH}}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.1/lib64:$LD_LIBRARY_PATH" >> ~/.bashrc
source ~/.bashrc
```

* install PyTorch
```bash
pip3 install torch==1.8.0+cu111 torchvision==0.9.0+cu111 torchaudio==0.8.0 -f https://download.pytorch.org/whl/torch_stable.html

# check if PyTorch works normally
python3
  >> import torch
  >> torch.rand(10).to('cuda')
```


### OpenCV install (ver. 3.4)
refered from [here](https://github.com/engcang/vins-application#-opencv-with-cuda-necessary-for-gpu-version-1)
* clone OpenCV/conrtib 3.4 from github
```bash
git clone -b 3.4 https://github.com/opencv/opencv.git
git clone -b 3.4 https://github.com/opencv/opencv_contrib.git
```

* install OpenCV with CUDA, contrib
```bash
# CUDA_ARCH_BIN=8.6 for RTX 30XX
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_C_COMPILER=gcc-6 \
      -D CMAKE_CXX_COMPILER=g++-6 \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_GENERATE_PKGCONFIG=YES \
      -D WITH_CUDA=ON \
      -D CUDA_ARCH_BIN=8.6 \
      -D CUDA_ARCH_PTX="" \
      -D ENABLE_FAST_MATH=ON \
      -D CUDA_FAST_MATH=ON \
      -D WITH_CUBLAS=ON \
      -D WITH_LIBV4L=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_GSTREAMER_0_10=OFF \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      -D BUILD_opencv_cudacodec=OFF \
      -D CUDA_NVCC_FLAGS="--expt-relaxed-constexpr" \
      -D WITH_TBB=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      ../
      
time make -j1 # important, use only one core to prevent compile error
sudo make install
```
  
  
## 2. etc install (chrome browser, terminator, vscode)
download and run my shell script [install_etc.sh](https://github.com/zinuok/ubuntu_setup/blob/master/install_etc.sh "link")
```bash
git clone https://github.com/zinuok/ubuntu_setup.git
chmod +x install_etc.sh
./install_etc.sh
```
To solve time conflicting problem between Window and Linux,
```bash
timedatectl set-local-rtc 1 --adjust-system-clock
```

## 3. Hangul install
* Settings -> Region&Language -> Manage Installed Languages -> Install/Remove Language...
then you can see 'Korean'
* reboot
* open the terminal
```bash
ibus-setup
```
* add Hangul in ibus-setup: Input Method -> Add -> ... -> Korean -> Hangul
* add Hangul input source: Settings -> Region&Language -> Add an Input Source 
* click 'gear' button
* add transition key input and check 'Start in Hangul mode'

## 4. ROS Melodic & mavros/gazebo9 install (for Ubuntu 18.04 LTS)
from [here](https://dev.px4.io/master/en/setup/dev_env_linux_ubuntu.html)  
(Though this scripts includes px4 Firmware installation, the lastest Firmware version may not work. If you use the 'Firmware', therefore, download from v1.10.0 branch which is verified => ref [this](https://github.com/zinuok/gazebo_mavros))
```bash
cd ~/ubuntu_setup/
chmod +x ubuntu_sim_ros_melodic.sh
bash ubuntu_sim_ros_melodic.sh
```

## 5. QgroundControl install
from: [here](https://docs.qgroundcontrol.com/en/getting_started/download_and_install.html "link")
* install plugin
```bash
sudo usermod -a -G dialout $USER
sudo apt-get remove modemmanager -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
```
* download image file
download from [here](https://s3-us-west-2.amazonaws.com/qgroundcontrol/latest/QGroundControl.AppImage "link")
* execute
```bash
chmod +x ./QGroundControl.AppImage
./QGroundControl.AppImage  (or double click)
```


## 6. 'Mac Mojave' Theme install
from [here](https://itlearningcenter.tistory.com/entry/%E3%80%901804-LTS%E3%80%91%EC%9A%B0%EB%B6%84%ED%88%AC-%ED%85%8C%EB%A7%88-%EA%BE%B8%EB%AF%B8%EA%B8%B0 "link")

* Genome tweak install
```bash
sudo apt-get install -y gnome-tweak-tool
```
* add repository
```bash
sudo add-apt-repository ppa:noobslab/macbuntu
sudo apt-get update
sudo apt-get install -y macbuntu-os-ithemes-v1804
sudo apt-get install -y macbuntu-os-icons-v1804
```


* themes
  * download from [here](https://www.pling.com/p/1275087 "link")
  * my themes: Mojave-dark
  * unzip and copy
  ```bash
  tar -xf [fime name]
  mkdir ~/.themes
  sudo cp -r [file name] ~/.themes
  ```
  * apply  
    open gnome-tweak, go to 'Appearance' tab --> Themes --> Applications
    
* icon
  * download from [here](https://www.gnome-look.org/p/1210856/ "link")
  * my icon: MacBuntu-OSX (which is already installed)
  * unzip and copy
  ```bash
  tar -xf [fime name]
  mkdir ~/.icons
  sudo cp -r [file name] ~/.icons
  ```
  * apply  
    open gnome-tweak, go to 'Appearance' tab --> Themes --> Icons

* cursor
  * download from [here](https://www.gnome-look.org/p/1384420/ "link")
  * unzip and copy
  ```bash
  unzip [fime name]
  ```
  * apply  
    open gnome-tweak, go to 'Appearance' tab --> Themes --> Cursor

* dock
  * plank dock install
  ```bash
  sudo apt-get install -y plank
  sudo add-apt-repository ppa:noobslab/macbuntu && sudo apt update
  sudo apt-get install -y macbuntu-os-plank-theme-lts-v7
  ```
  * add to startup app  
  tweaks --> Startup Applications --> +
  * plank mac theme install
    * download from [here](https://www.gnome-look.org/p/1264834/ "link")
    * copy
    ```bash
    sudo cp -r [file name] /usr/share/plank/themes/
    ```
    * apply in plank preferences
    * plank settings (Ctrl + right click) --> Behaviour --> Dodge maximized window
    
  * remove original dock
  ```bash
  sudo apt remove gnome-shell-extension-ubuntu-dock
  reboot
  ```

* terminal
