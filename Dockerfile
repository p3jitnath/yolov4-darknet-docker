FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
LABEL maintainer="Pritthijit Nath <pritthijit.nath@icloud.com>"

# Setting up environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

# Install essential packages
RUN apt-get update && apt-get install -y --no-install-recommends build-essential cmake pkg-config unzip yasm git checkinstall libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev \
                                       libswscale-dev libavresample-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev \
                                       libfaac-dev libmp3lame-dev libvorbis-dev libopencore-amrnb-dev libopencore-amrwb-dev python3-testresources \
                                       libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev wget tar \
                                       libgtk-3-dev python3-dev python3-pip libdc1394-22 libdc1394-22-dev libxine2-dev libv4l-dev v4l-utils libtbb-dev libatlas-base-dev \
                                       gfortran libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

RUN cd /usr/include/linux && ln -s -f ../libv4l1-videodev.h videodev.h

# Build Python3.6.9 on Ubuntu
RUN wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz && tar xzf Python-3.6.9.tgz && cd Python-3.6.9 && ./configure --enable-optimizations && make install && pip3 install numpy wheel

# Build OpenCV 4.2.0 with CUDA 10.1 version
COPY ./ /
RUN chmod +x build-opencv-4.2.0-18.04-cuda.sh && ./build-opencv-4.2.0-18.04-cuda.sh && g++ -o test test_opencv.cpp `pkg-config opencv --cflags --libs`

# Install Darknet
RUN git clone https://github.com/AlexeyAB/darknet
WORKDIR /darknet
COPY ./Makefile /
RUN make -j12 # Number of CPU cores (use nproc)

# References:
# [1]: https://github.com/silviopaganini/darknet-docker-nvidia/blob/master/Dockerfile
# [2]: https://gist.github.com/nathzi1505/858a140b4ab621209b0e71c8a55df221
# [3]: https://towardsdatascience.com/building-python-from-source-on-ubuntu-20-04-2ed29eec152b
# [4]: https://gitlab.com/nvidia/container-images/cuda