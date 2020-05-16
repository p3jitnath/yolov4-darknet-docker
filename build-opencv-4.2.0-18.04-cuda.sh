#!/bin/bash

# wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip
# wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.2.0.zip

unzip opencv.zip
unzip opencv_contrib.zip

cd opencv-4.2.0
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
	  -D CMAKE_C_COMPILER=/usr/bin/gcc-7 \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D WITH_TBB=ON \
    -D WITH_CUDA=ON \
    -D BUILD_opencv_cudacodec=OFF \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D WITH_V4L=ON \
    -D WITH_QT=OFF \
    -D WITH_OPENGL=ON \
    -D WITH_GSTREAMER=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_PC_FILE_NAME=opencv.pc \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python3.6/site-packages \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-4.2.0/modules \
    -D PYTHON_EXECUTABLE=/usr/local/bin/python3 \
    -D BUILD_EXAMPLES=ON \
    -D WITH_CUDNN=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D CUDNN_LIBRARY=/usr/lib/x86_64-linux-gnu/libcudnn.so.7.6.5 \
    -D CUDNN_INCLUDE_DIR=/usr/include  \
    -D CUDA_ARCH_BIN=7.5 ..

nproc
make -j12
make install

/bin/bash -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'
ldconfig