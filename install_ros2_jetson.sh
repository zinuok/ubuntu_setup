locale  # check for UTF-8
sudo apt update && sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale  # verify settings

sudo apt update && sudo apt install -y curl gnupg2 lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update
sudo apt -y upgrade

sudo apt install -y build-essential libboost-system-dev libboost-thread-dev libboost-program-options-dev libboost-test-dev libboost-filesystem-dev 
sudo apt install -y libboost-dev libeigen3-dev libgeographic-dev libpugixml-dev libpython3-dev libboost-python-dev python3-catkin-tools

sudo apt install -y ros-foxy-ros-base
sudo apt install -y ros-foxy-image-transport
sudo apt install -y ros-foxy-rviz2 ros-foxy-diagnostic-updater ros-foxy-rqt-image-view


echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt update && sudo apt install -y build-essential cmake git libbullet-dev python3-colcon-common-extensions python3-flake8 python3-pip python3-pytest-cov python3-rosdep python3-setuptools python3-vcstool wget

sudo rosdep init
rosdep update

mkdir -p ~/ros/catkin_ws/src

# ROS2 cv-bridge
cd ~/ros/catkin_ws/src && git clone https://github.com/ros-perception/vision_opencv
cd vision_opencv
git checkout foxy
cd ~/ros/catkin_ws
colcon build --symlink-install --cmake-args=-DCMAKE_BUILD_TYPE=Release
source ./install/local_setup.bash

echo "source ~/ros/catkin_ws/install/local_setup.bash" >> ~/.bashrc
source ~/.bashrc


# ROS alias
echo "" >> ~/.bashrc
echo "# ROS alias" >> ~/.bashrc
echo "alias cw='cd ~/ros/catkin_ws'" >> ~/.bashrc
echo "alias cs='cd ~/ros/catkin_ws/src'" >> ~/.bashrc
echo "alias cb='colcon build --symlink-install'" >> ~/.bashrc
echo "alias cc='rm -rf build install log'" >> ~/.bashrc
echo "alias cwb='cw && cb'" >> ~/.bashrc
echo "alias s='source ./install/local_setup.bash && source ./install/setup.bash'" >> ~/.bashrc


cd ~
mkdir backend && cd backend

## build OpenCV
# from: https://github.com/engcang/vins-application#-ros2-cv_bridge
sudo apt-get purge libopencv*
sudo apt-get purge python-opencv python3-opencv
pip uninstall opencv-python
sudo apt-get update
sudo apt-get install -y build-essential pkg-config
sudo apt-get install -y cmake libavcodec-dev libavformat-dev libavutil-dev \
    libglew-dev libgtk2.0-dev libgtk-3-dev libjpeg-dev libpng-dev libpostproc-dev \
    libswscale-dev libtbb-dev libtiff5-dev libv4l-dev libxvidcore-dev \
    libx264-dev qt5-default zlib1g-dev libgl1 libglvnd-dev pkg-config \
    libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev mesa-utils 
sudo apt-get install python3-dev python3-numpy

wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.5.zip
unzip opencv.zip && rm opencv.zip
cd opencv-4.5.5/
unzip opencv_contrib.zip && rm opencv_contrib.zip
mkdir build && cd build

# CUDA_ARCH_BIN: 
# 8.7 for jetson ORIN, 8.6 for RTX3080 7.2 for Xavier, 5.2 for GTX TITAN X, 6.1 for GTX TITAN X(pascal), 6.2 for TX2
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_C_COMPILER=gcc-9 \
      -D CMAKE_CXX_COMPILER=g++-9 \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_GENERATE_PKGCONFIG=YES \
      -D PYTHON_EXECUTABLE=/usr/bin/python3.8 \
      -D PYTHON2_EXECUTABLE="" \
      -D BUILD_opencv_python3=ON \
      -D BUILD_opencv_python2=OFF \
      -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.8/dist-packages \
      -D BUILD_NEW_PYTHON_SUPPORT=ON \
      -D OPENCV_SKIP_PYTHON_LOADER=ON \
      -D WITH_CUDA=ON \
      -D OPENCV_DNN_CUDA=ON \
      -D WITH_CUDNN=ON \
      -D CUDA_ARCH_BIN=8.7 \
      -D CUDA_ARCH_PTX=8.7 \
      -D ENABLE_FAST_MATH=ON \
      -D CUDA_FAST_MATH=ON \
      -D WITH_CUBLAS=ON \
      -D WITH_LIBV4L=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_GSTREAMER_0_10=OFF \
      -D WITH_CUFFT=ON \
      -D WITH_NVCUVID=ON \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      -D WITH_IPP=OFF \
      -D WITH_V4L=ON \
      -D WITH_1394=OFF \
      -D WITH_GTK=ON \
      -D WITH_EIGEN=ON \
      -D WITH_FFMPEG=ON \
      -D WITH_TBB=ON \
      -D BUILD_opencv_cudacodec=OFF \
      -D CUDA_NVCC_FLAGS="--expt-relaxed-constexpr" \
      -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.5.5/modules \
      ../
make -j20
sudo make install

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


## VINS ROS2
cd ~/ros/catkin_ws/src && git clone https://github.com/zinuok/VINS-Fusion-ROS2
cd ~/ros/catkin_ws
colcon build --symlink-install --cmake-args=-DCMAKE_BUILD_TYPE=Release


## Realsens SDK & ROS2
cd ~/ros/catkin_ws/src
git clone --depth 1 --branch `git ls-remote --tags https://github.com/IntelRealSense/realsense-ros.git | grep -Po "(?<=tags/)3.\d+\.\d+" | sort -V | tail -1` https://github.com/IntelRealSense/realsense-ros.git
cd ..

## install dependencies
sudo apt-get install python3-rosdep -y
sudo rosdep init # "sudo rosdep init --include-eol-distros" for Dashing
rosdep update
rosdep install -i --from-path src --rosdistro $ROS_DISTRO --skip-keys=librealsense2 -y

# buildROS2
cd ~/ros/catkin_ws
colcon build --symlink-install --cmake-args=-DCMAKE_BUILD_TYPE=Release

