#!/usr/bin/env bash


## copyright: https://github.com/Tiryoh/ros2_setup_scripts_ubuntu
set -eu

# REF: https://index.ros.org/doc/ros2/Installation/Linux-Install-Debians/
# by Open Robotics, licensed under CC-BY-4.0
# source: https://github.com/ros2/ros2_documentation

CHOOSE_ROS_DISTRO=foxy
INSTALL_PACKAGE=desktop

sudo apt-get update
sudo apt-get install -y curl gnupg2 lsb-release build-essential

[[ "$(lsb_release -sc)" == "focal" ]] || exit 1

sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt-get update
sudo apt-get install -y ros-$CHOOSE_ROS_DISTRO-$INSTALL_PACKAGE
sudo apt-get install -y python3-argcomplete
sudo apt-get install -y python3-colcon-common-extensions
sudo apt-get install -y python3-rosdep python3-vcstool # https://index.ros.org/doc/ros2/Installation/Linux-Development-Setup/
[ -e /etc/ros/rosdep/sources.list.d/20-default.list ] ||
sudo rosdep init
rosdep update
grep -F "source /opt/ros/$CHOOSE_ROS_DISTRO/setup.bash" ~/.bashrc ||
echo "source /opt/ros/$CHOOSE_ROS_DISTRO/setup.bash" >> ~/.bashrc

set +u

source /opt/ros/$CHOOSE_ROS_DISTRO/setup.bash

echo "success installing ROS2 $CHOOSE_ROS_DISTRO"
echo "Run 'source /opt/ros/$CHOOSE_ROS_DISTRO/setup.bash'"

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
