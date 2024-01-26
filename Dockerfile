FROM ros:noetic-ros-base

# USE BASH
SHELL ["/bin/bash", "-c"]

# RUN LINE BELOW TO REMOVE debconf ERRORS (MUST RUN BEFORE ANY apt-get CALLS)
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends apt-utils python3-pip git

RUN apt install python3-catkin-tools -y

RUN mkdir -p /catkin_ws/src

RUN cd /catkin_ws/src/ && git clone https://github.com/safijari/yujin_ocs && cd yujin_ocs && git submodule update --init --recursive
RUN echo "yaml file:///catkin_ws/src/yujin_ocs/rosdep.yaml" > /etc/ros/rosdep/sources.list.d/99-custom.list
RUN rosdep update
RUN rosdep install -y -r --from-paths /catkin_ws/src/yujin_ocs/yocs_velocity_smoother --ignore-src --rosdistro=noetic

RUN source /opt/ros/noetic/setup.bash \ 
    && cd /catkin_ws/src \
    && catkin_init_workspace \
    && cd .. \
    && catkin config --install \
    && catkin build -DCMAKE_BUILD_TYPE=Release