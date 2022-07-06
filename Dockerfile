FROM python:bullseye

ARG KLIPPER_VERSION="master"
ARG KLIPPER_PATH="/root/klipper"
ARG CONFIG_PATH="/kubeconfig"

ENV KLIPPER_PATH="${KLIPPER_PATH}"
ENV CONFIG_PATH="${CONFIG_PATH}"

RUN mkdir "${CONFIG_PATH}"
VOLUME "${CONFIG_PATH}"


RUN apt update && \
    apt install -y \
        git sudo \
        python-dev libffi-dev build-essential \
        libncurses-dev \
        libusb-dev \
        avrdude gcc-avr binutils-avr avr-libc \
        stm32flash libnewlib-arm-none-eabi \
        gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0-0 && \
    apt clean

COPY run.sh /run.sh
RUN git clone --depth 1 --branch="${KLIPPER_VERSION}" https://github.com/Klipper3d/klipper.git "${KLIPPER_PATH}"

WORKDIR "${KLIPPER_PATH}"

RUN pip install -r "${KLIPPER_PATH}/scripts/klippy-requirements.txt"

CMD ["sh", "/run.sh"]