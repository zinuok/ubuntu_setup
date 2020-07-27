sudo apt-get install python-catkin-tools python-rosinstall-generator -y
wstool init ~/catkin_ws/src

# install MAVLink
rosinstall_generator --rosdistro melodic mavlink | tee /tmp/mavros.rosinstall
# install MAVROS
rosinstall_generator --upstream mavros --rosdistro melodic | tee -a /tmp/mavros.rosinstall

# create workspace & deps
cd ~/catkin_ws
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src -j4
sudo rosdep init && rosdep update
rosdep install --from-paths src --ignore-src --rosdistro melodic -y

# install GeographicLib datasets
sudo ./src/mavros/mavros/scripts/install_geographiclib_datasets.sh

# last setup
souce devel/setup.bash
source /opt/ros/melodic/setup.bash

# build source
catkin build -DCMAKE_BUILDTYPE=Release -j3

