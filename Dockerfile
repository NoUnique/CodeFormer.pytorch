FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

# To remove debconf build warnings
ARG DEBIAN_FRONTEND=noninteractive

# Change locale to fix encoding error on mail-parser install
ARG LC=ko_KR.UTF-8
RUN apt-get update \
 && apt-get install --no-install-suggests -y \
    locales \
 && locale-gen en_US.UTF-8 \
 && locale-gen ${LC} \
    ;
# Set default locale for the environment
ENV LC_ALL=C \
    LANG=${LC}

# Change the timezone
ARG TZ=Asia/Seoul
RUN ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    ;

RUN apt-get install --no-install-suggests -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ;

RUN pip install \
    ipython==8.4.0 \
    future==0.18.2 \
    lmdb==1.3.0 \
    scikit-image==0.19.3 \
    torch==1.11.0 --extra-index-url=https://download.pytorch.org/whl/cu113 \
    torchvision==0.12.0 --extra-index-url=https://download.pytorch.org/whl/cu113 \
    scipy==1.9.0 \
    gdown==4.5.1 \
    pyyaml==6.0 \
    tb-nightly==2.11.0a20220906 \
    tqdm==4.64.1 \
    yapf==0.32.0 \
    lpips==0.1.4 \
    Pillow==9.2.0 \
    opencv-python==4.6.0.66 \
    gradio==3.20.1 \
    markupsafe==2.0.1 \
    ;

WORKDIR /app

COPY ./CodeFormer ./CodeFormer
RUN cd CodeFormer \
 && python basicsr/setup.py develop \
 && cd -

ENV GRADIO_SERVER_NAME=0.0.0.0
ENV GRADIO_SERVER_PORT=8080
EXPOSE 8080
CMD ["python", "CodeFormer/web-demos/hugging_face/app.py"]
