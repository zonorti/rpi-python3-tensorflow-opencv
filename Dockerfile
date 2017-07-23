FROM resin/armv7hf-debian-qemu

RUN [ "cross-build-start" ]

MAINTAINER Sergey Melnik <admin.sa@gmail.com>

RUN apt-get update && \
    apt-get -q -y install --no-install-recommends python3 \
      python3-dev python3-pip build-essential cmake \
      pkg-config libjpeg-dev libtiff5-dev libjasper-dev \
      libpng12-dev libavcodec-dev libavformat-dev libswscale-dev \
      libv4l-dev libxvidcore-dev libx264-dev python3-yaml \
      python3-scipy python3-h5py git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Keras Tensorflow
RUN pip3 install keras
ADD https://github.com/samjabrahams/tensorflow-on-raspberry-pi/releases/download/v1.0.0/tensorflow-1.0.0-cp34-cp34m-linux_armv7l.whl /tensorflow-1.0.0-cp34-cp34m-linux_armv7l.whl
RUN pip3 install /tensorflow-1.0.0-cp34-cp34m-linux_armv7l.whl && rm /tensorflow-1.0.0-cp34-cp34m-linux_armv7l.whl

# OpenCV
ENV OPENCV_VERSION="3.2.0"
ENV OPENCV_DIR="/opt/opencv/"

ADD https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz ${OPENCV_DIR}

RUN cd ${OPENCV_DIR} && \
    tar -xzf ${OPENCV_VERSION}.tar.gz && \
    rm ${OPENCV_VERSION}.tar.gz && \
    mkdir ${OPENCV_DIR}opencv-${OPENCV_VERSION}/build && \
    cd ${OPENCV_DIR}opencv-${OPENCV_VERSION}/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && make -j4 && make install && \
    mv /usr/local/lib/python3.4/dist-packages/cv2.cpython-34m.so /usr/local/lib/python3.4/dist-packages/cv2.so && \
    rm -rf ${OPENCV_DIR}

RUN [ "cross-build-end" ] 