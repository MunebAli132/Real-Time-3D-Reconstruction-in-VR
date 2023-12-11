# Use Ubuntu 20.04 as base image
FROM ubuntu:20.04

# Avoid timezone prompts
ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'deb [arch=amd64] http://security.ubuntu.com/ubuntu xenial-security main' | tee /etc/apt/sources.list.d/xenial-security.list

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    unzip \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev\
    python-dev \
    python-numpy \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev\
    libjasper-dev\
    libdc1394-22-dev\
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev\
    libv4l-dev \
    liblapacke-dev\
    libxvidcore-dev\
    libx264-dev\
    libatlas-base-dev\
    gfortran\
    ffmpeg \ 
    yasm \
    python3-dev \
    python3-numpy \
    python3-pip

RUN pip install -U colcon-common-extensions

# Install ROS2 Foxy
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN apt-get update
RUN apt-get install -y ros-foxy-desktop

# Install OpenCV 4.2.0
RUN git clone https://github.com/doubleZ0108/OpenCV-4.2.0.git
WORKDIR /OpenCV-4.2.0/build
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=/OpenCV-4.2.0/opencv_contrib-4.2.0/modules/ ..
RUN make -j$(nproc --ignore=2) # Use nproc --ignore=2 to leave 2 cores free
RUN make install


# Configure the path
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf
RUN ldconfig
RUN echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" >> /etc/bash.bashrc
RUN /bin/bash -c "source /etc/bash.bashrc"

# Create opencv.pc
RUN mkdir -p /usr/local/lib/pkgconfig
RUN echo -e "prefix=/usr/local\nexec_prefix=${prefix}\nincludedir=${prefix}/include\nlibdir=${exec_prefix}/lib\n\nName: opencv\nDescription: The opencv library\nVersion:4.2.0\nCflags: -I${includedir}/opencv4\nLibs: -L${libdir} -lopencv_shape -lopencv_stitching -lopencv_objdetect -lopencv_superres -lopencv_videostab -lopencv_calib3d -lopencv_features2d -lopencv_highgui -lopencv_videoio -lopencv_imgcodecs -lopencv_video -lopencv_photo -lopencv_ml -lopencv_imgproc -lopencv_flann  -lopencv_core" > /usr/local/lib/pkgconfig/opencv.pc

# Export the environment parameter
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

RUN apt-get update && apt-get install -y \
    zip\
    tar\
    nasm\
    libpython2.7-dev

# Set the working directory
# WORKDIR /usr/local

# RUN git clone https://gitlab.com/libeigen/eigen.git

# RUN cp -r eigen/Eigen /usr/local/include/

# WORKDIR /usr/local/eigen
# RUN mkdir build && cd build && cmake ..
# RUN make install



WORKDIR /usr/local

# Clone the vcpkg repository
RUN git clone https://github.com/Microsoft/vcpkg.git

# Change to the vcpkg directory
WORKDIR /usr/local/vcpkg

# Run the bootstrap script
RUN ./bootstrap-vcpkg.sh

# Integrate vcpkg with the user-wide integration
RUN ./vcpkg integrate install

# Install Pangolin
RUN ./vcpkg install pangolin

WORKDIR /

# Create the directory for ORB_SLAM3
RUN mkdir -p ~/Install/ORB_SLAM

# Set the WORKDIR to the ORB_SLAM3 directory
WORKDIR /~/Install/ORB_SLAM


ENV CMAKE_TOOLCHAIN_FILE=/usr/local/vcpkg/scripts/buildsystems/vcpkg.cmake
ENV Pangolin_DIR=/usr/local/vcpkg/installed/x64-linux/share/pangolin
ENV PalSigslot_DIR=/usr/local/vcpkg/installed/x64-linux/share/PalSigslot


# RUN apt install libeigen3-dev


# Clone and build ORB_SLAM3
RUN git clone https://github.com/zang09/ORB-SLAM3-STEREO-FIXED.git ORB_SLAM3
WORKDIR /~/Install/ORB_SLAM/ORB_SLAM3
RUN chmod +x build.sh
RUN ./build.sh


# # Install related ROS2 packages
RUN apt-get install -y \
    ros-foxy-vision-opencv \
    ros-foxy-message-filters

WORKDIR /~/Install/ORB_SLAM/ORB_SLAM3/Thirdparty/Sophus/build
RUN make install


WORKDIR /
# # Clone and build ORB_SLAM3_ROS2
RUN mkdir -p colcon_ws/src
WORKDIR /colcon_ws/src
RUN git clone https://github.com/zang09/ORB_SLAM3_ROS2.git orbslam3_ros2
WORKDIR /colcon_ws

RUN sed -i 's|set(ORB_SLAM3_ROOT_DIR "~/Install/ORB_SLAM/ORB_SLAM3")|set(ORB_SLAM3_ROOT_DIR "/~/Install/ORB_SLAM/ORB_SLAM3")|g' /colcon_ws/src/orbslam3_ros2/CMakeModules/FindORB_SLAM3.cmake


RUN /bin/bash -c "source /opt/ros/foxy/setup.bash && colcon build --symlink-install --packages-select orbslam3"

RUN touch /root/.bashrc

RUN echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc

# RUN echo "source /colcon_ws/install/setup.bash" >> /root/.bashrc
