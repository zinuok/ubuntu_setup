#!/bin/bash


# adopted from https://github.com/kemjensak/ROS_single_line_install

echo "This script will install ros humble on your PC"
echo ""
echo "PRESS [ENTER] TO CONTINUE THE INSTALLATION"
echo "IF YOU WANT TO CANCEL, PRESS [CTRL] + [C]"
echo ""
echo ""
read

sudo apt update -y
sudo apt install locales -y
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

sudo apt install software-properties-common -y
sudo add-apt-repository universe -y
sudo apt update -y
sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update -y
sudo apt upgrade -y
sudo apt install ros-humble-desktop-full -y
sudo apt install ros-dev-tools -y
sudo apt install ros-humble-rqt-* -y

sudo apt install python3-vcstool

# timezone setting for dual boot windows 
timedatectl set-local-rtc 1 --adjust-system-clock

echo "[Initialize rosdep]"
sudo rosdep init
rosdep update

sudo usermod -a -G dialout $USER
sudo usermod -a -G tty $USER
sudo ip link set lo multicast on

mkdir -p $HOME/colcon_ws/src
cd $HOME/colcon_ws
colcon build

sh -c "echo \"source /opt/ros/humble/setup.bash\" >> ~/.bashrc"
sh -c "echo \"source ~/colcon_ws/install/local_setup.bash\" >> ~/.bashrc"

sh -c "echo \"source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash\" >> ~/.bashrc"
sh -c "echo \"source /usr/share/vcstool-completion/vcs.bash\" >> ~/.bashrc"
sh -c "echo \"source /usr/share/colcon_cd/function/colcon_cd.sh\" >> ~/.bashrc"

sh -c "echo \"export _colcon_cd_root=~/colcon_ws\" >> ~/.bashrc"
sh -c "echo \"export ROS_DOMAIN_ID=0\" >> ~/.bashrc"
sh -c "echo \"export ROS_LOCALHOST_ONLY=1\" >> ~/.bashrc"

sh -c "echo \"export RCUTILS_CONSOLE_OUTPUT_FORMAT='[{severity} {time}] [{name}]: {message} ({function_name}() at {file_name}:{line_number})'\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_COLORIZED_OUTPUT=1\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_LOGGING_USE_STDOUT=0\" >> ~/.bashrc"
sh -c "echo \"export RCUTILS_LOGGING_BUFFERED_STREAM=1\" >> ~/.bashrc"

sh -c "echo \"alias eb='nano ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias sb='source ~/.bashrc'\" >> ~/.bashrc"
sh -c "echo \"alias cb='cd ~/colcon_ws && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --symlink-install'\" >> ~/.bashrc"
sh -c "echo \"alias cbs='colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --symlink-install'\" >> ~/.bashrc"
sh -c "echo \"alias cbp='colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --symlink-install --packages-select'\" >> ~/.bashrc"
sh -c "echo \"alias cbu='colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --symlink-install --packages-up-to'\" >> ~/.bashrc"
sh -c "echo \"alias rd='rosdep install --from-paths src --ignore-src -r -y'\" >> ~/.bashrc"
sh -c "echo \"alias cw='cd ~/colcon_ws'\" >> ~/.bashrc"
sh -c "echo \"alias cs='cd ~/colcon_ws/src'\" >> ~/.bashrc"

source $HOME/.bashrc

echo "[Complete!!!]"
echo "Please open new terminal or type "source ~/.bashrc" to do further"




mkdir -p ~/ros/catkin_ws/src
cd ~/ros/catkin_ws && colcon build --symlink-install
echo "source ~/ros/catkin_ws/install/setup.bash" >> ~/.bashrc

# ROS alias
echo "" >> ~/.bashrc
echo "# ROS alias" >> ~/.bashrc
echo "alias cw='cd ~/ros/catkin_ws'" >> ~/.bashrc
echo "alias cs='cd ~/ros/catkin_ws/src'" >> ~/.bashrc
echo "alias cb='colcon build --symlink-install'" >> ~/.bashrc
echo "alias cc='rm -rf build install log'" >> ~/.bashrc
echo "alias cwb='cw && cb'" >> ~/.bashrc
echo "alias  s='source ./install/setup.bash && source ./install/local_setup.bash'" >> ~/.bashrc


cd ~
mkdir backend && cd backend

## build Eigen
wget -O eigen-3.3.9.zip https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.zip 
unzip eigen-3.3.9.zip
cd ~/eigen-3.3.9 && mkdir build && cd build
cmake ../ && sudo make install

## Ceres
sudo apt-get install -y cmake libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev
wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz
tar zxf ceres-solver-2.1.0.tar.gz
cd ceres-solver-2.1.0
mkdir build && cd build
cmake -DEXPORT_BUILD_DIR=ON \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      ../
make -j $(nproc) # number of cores
sudo make install -j $(nproc)




cd ~
mkdir backend && cd backend

## build Eigen
wget -O eigen-3.3.9.zip https://gitlab.com/libeigen/eigen/-/archive/3.3.9/eigen-3.3.9.zip 
unzip eigen-3.3.9.zip
cd ~/eigen-3.3.9 && mkdir build && cd build
cmake ../ && sudo make install

## Ceres
sudo apt-get install -y cmake libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev
wget http://ceres-solver.org/ceres-solver-2.2.0.tar.gz
tar zxf ceres-solver-2.2.0.tar.gz
cd ceres-solver-2.2.0
mkdir build && cd build
cmake -DEXPORT_BUILD_DIR=ON \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      ../
make -j $(nproc) # number of cores
sudo make install -j $(nproc)