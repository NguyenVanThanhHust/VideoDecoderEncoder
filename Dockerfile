FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

WORKDIR /opt/
ARG DEBIAN_FRONTEND=noninteractive
ENV PATH="${PATH}:/opt/hpcx/ompi/bin"
ARG PYTHON_VERSION=3.8

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/hpcx/ompi/lib"

RUN apt-get update && apt-get -y install build-essential \
    libssl-dev libgl1 libglib2.0-0 git vim zip unzip wget python3-pip

RUN apt-get update && apt-get -y install \  
    libmagickwand-dev libsm6 libxext6 libboost-all-dev \
    software-properties-common libgtk2.0-dev

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get -qq install  \
        apt-utils \
        autoconf \
        automake \
        checkinstall \
        gfortran \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libavdevice-dev \
        libeigen3-dev \
        libexpat1-dev \
        libglew-dev \
        libgtk-3-dev \
        libjpeg-dev \
        libopenexr-dev \
        libpng-dev \
        libpostproc-dev \
        libpq-dev \
        libqt5opengl5-dev \
        libsm6 \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libtiff-dev \
        libtool \
        libv4l-dev \
        libwebp-dev \
        libxext6 \
        libxrender1 \
        libxvidcore-dev \
        pkg-config \
        protobuf-compiler \
        qt5-default \
        unzip \
        yasm \
        zlib1g-dev \
#   GStreamer :
        libgstreamer1.0-0 \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-doc \
        gstreamer1.0-tools \
        gstreamer1.0-x \
        gstreamer1.0-alsa \
        gstreamer1.0-gl \
        gstreamer1.0-gtk3 \
        gstreamer1.0-qt5 \
        gstreamer1.0-pulseaudio \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge   --auto-remove && \
    apt-get clean

# numpy for the newly installed python :
RUN wget https://bootstrap.pypa.io/get-pip.py  && \
    python${PYTHON_VERSION} get-pip.py --no-setuptools --no-wheel && \
    rm get-pip.py && \
    pip install numpy

WORKDIR /opt/

RUN apt-get install -y pkg-config
RUN python3 -m pip install scikit-build cmake

WORKDIR /opt/
RUN git clone https://github.com/FFmpeg/FFmpeg.git -b release/4.4 ffmpeg/
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git 

WORKDIR /opt/nv-codec-headers/
RUN apt-get install -y yasm libtool libc6 libc6-dev unzip 
RUN apt-get install -y libnuma1 libnuma-dev
RUN make install

WORKDIR /opt/ffmpeg/
RUN echo "export PATH=$PATH:/usr/local/cuda/bin" >> ~/.bashrc
RUN apt-get install -y libxvidcore-dev
RUN ./configure --nvccflags="-gencode arch=compute_75,code=sm_75 -O2" \
    --extra-cflags=-I/usr/local/cuda/include \
    --extra-ldflags=-L/usr/local/cuda/lib64 \
    --disable-static \
    --enable-shared \
    --enable-openssl \
    --enable-postproc \
    --enable-small \
    --enable-cuda-nvcc \
    --enable-nonfree \
    --extra-cflags=" -I/usr/local/include"
RUN make -j16 && make install

ARG LIB_PREFIX='/usr/local'
ENV CXXFLAGS="-D__STDC_CONSTANT_MACROS"
ENV LIB_PREFIX=${LIB_PREFIX} \
    FFMPEG_PATH='/usr/bin/ffmpeg'

# https://github.com/NVIDIA-AI-IOT/deepstream_dockers/blob/main/x86_64/ubuntu_base_devel/Dockerfile
WORKDIR /opt/
RUN git clone https://github.com/KhronosGroup/Vulkan-ValidationLayers.git /opt/vulkan && \
    cd /opt/vulkan && git checkout v1.1.123 
WORKDIR /opt/vulkan
RUN apt install -y libwayland-dev

RUN apt-get update
RUN apt-get install -y libglew-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev

WORKDIR /opt/
RUN git clone https://github.com/oneapi-src/oneTBB.git
WORKDIR /opt/oneTBB/build/
RUN cmake .. && make && make install && ldconfig

WORKDIR /opt/
RUN wget https://github.com/opencv/opencv/archive/4.7.0.zip -O opencv.zip && unzip -qq opencv.zip &&\
    wget https://github.com/opencv/opencv_contrib/archive/4.7.0.zip -O opencv-co.zip && unzip -qq opencv-co.zip

WORKDIR /opt/opencv-4.7.0/build/
RUN cmake \
      -D BUILD_opencv_java=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_CUDA=ON \
      -D WITH_CUBLAS=ON \
      -D OPENCV_DNN_CUDA=ON \
      -D CUDA_ARCH_PTX=7.5 \
      -D WITH_NVCUVID=ON \
      -D WITH_CUFFT=ON \
      -D WITH_OPENGL=ON \
      -D WITH_QT=OFF \
      -D WITH_IPP=ON \
      -D WITH_TBB=OFF \
      -D WITH_EIGEN=OFF \
      -D BUILD_opencv_java=OFF \
      -D BUILD_opencv_python=OFF \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=OFF \
      -D BUILD_opencv_apps=OFF \
      -D BUILD_opencv_aruco=OFF \
      -D BUILD_opencv_bgsegm=OFF \
      -D BUILD_opencv_bioinspired=OFF \
      -D BUILD_opencv_ccalib=OFF \
      -D BUILD_opencv_datasets=OFF \
      -D BUILD_opencv_dnn_objdetect=OFF \
      -D BUILD_opencv_dpm=OFF \
      -D BUILD_opencv_fuzzy=OFF \
      -D BUILD_opencv_hfs=OFF \
      -D BUILD_opencv_java_bindings_generator=OFF \
      -D BUILD_opencv_js=OFF \
      -D BUILD_opencv_img_hash=OFF \
      -D BUILD_opencv_line_descriptor=OFF \
      -D BUILD_opencv_optflow=OFF \
      -D BUILD_opencv_phase_unwrapping=OFF \
      -D BUILD_opencv_python3=OFF \
      -D BUILD_opencv_python_bindings_generator=OFF \
      -D BUILD_opencv_reg=OFF \
      -D BUILD_opencv_rgbd=OFF \
      -D BUILD_opencv_saliency=OFF \
      -D BUILD_opencv_shape=OFF \
      -D BUILD_opencv_stereo=OFF \
      -D BUILD_opencv_stitching=OFF \
      -D BUILD_opencv_structured_light=OFF \
      -D BUILD_opencv_superres=OFF \
      -D BUILD_opencv_surface_matching=OFF \
      -D BUILD_opencv_ts=OFF \
      -D BUILD_opencv_cudacodec=ON \
      -D BUILD_opencv_xobjdetect=OFF \
      -D BUILD_opencv_xphoto=OFF \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D OPENCV_GENERATE_PKGCONFIG=ON \
      -D WITH_QT=OFF \
      -D WITH_GTK=ON \
      -D WITH_CUDA=ON \
      -D WITH_CUDNN=ON \
      -D WITH_OPENGL=ON \
      -D OPENCV_DNN_CUDA=ON \
      -D WITH_CUBLAS=ON \
      -D CUDA_ARCH_BIN=7.5 \
      -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-4.7.0/modules \
      -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
      -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs \
      -D OpenCL_LIBRARY=/usr/local/cuda-11.8/lib64/libOpenCL.so \
      -D OpenCL_INCLUDE_DIR=/usr/local/cuda-11.8/include/ \
      -D CMAKE_BUILD_TYPE=RELEASE ..

RUN make -j16 && make install && ldconfig

# Extra libs for minIO
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y curl libcurl4-openssl-dev libcurlpp-dev
RUN apt-get install -y libinih-dev

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES video,compute,utility

WORKDIR /workspace/
