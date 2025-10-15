# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade packages
RUN apt update && apt upgrade -y

# Install necessary tools and locale packages
RUN apt install -y locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Add ROS 2 apt repository
RUN apt update && apt install -y curl gnupg lsb-release
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
    http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
    | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 Jazzy Desktop
ENV ROS_DISTRO=jazzy
RUN apt update && apt install -y ros-${ROS_DISTRO}-desktop

# Install sudo package
RUN apt install -y sudo software-properties-common
RUN apt install -y python3-paho-mqtt ros-${ROS_DISTRO}-tf-transformations
RUN apt install -y mosquitto mosquitto-clients iputils-ping

# Add user account
ENV USER_NAME=mitz
ENV PASSWORD=hira95

RUN useradd -m -d /home/${USER_NAME} ${USER_NAME} \
        -p $(perl -e 'print crypt("${USER_NAME}", "${PASSWORD}"),"\n"') && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN locale-gen en_US.UTF-8
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
ENV HOME=/home/${USER_NAME}
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8


# Install CycloneDDS
RUN sudo apt install -y ros-${ROS_DISTRO}-rmw-cyclonedds-cpp

# RUN sudo apt install -y terminator net-tools
# RUN mkdir -p /home/${USER_NAME}/.config/terminator
# COPY terminator-config /home/${USER_NAME}/.config/terminator/config

# Source the ROS 2 setup file
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]

# 作業ディレクトリの設定
WORKDIR /mitz/docker/ros_mqtt_bridge_container
# Command to run when the container starts
CMD ["bash"]
