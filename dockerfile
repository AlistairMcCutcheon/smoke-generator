FROM nvcr.io/nvidia/pytorch:20.12-py3

ENV DEBIAN_FRONTEND noninteractive
ENV FORCE_CUDA="1"
ENV MMCV_WITH_OPS=1

# Install general requirements
RUN apt-get update

# Install opencv-python dependencies
RUN apt-get install ffmpeg libsm6 libxext6 -y

# Set working directory and permissions
RUN addgroup --gid 1024 mygroup
RUN useradd -rm -d /home/worker -g 1024 -u 1024 worker
# RUN useradd -rm -d /home/worker worker
WORKDIR /home/worker
# COPY . /home/worker

RUN chown -R 1001:1001 .

# RUN pip install openmim
# RUN mim install mmcv-full
RUN pip install mmcv-full -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.8.0/mmcv_full-1.7.1-cp39-cp39-manylinux1_x86_64.whl

RUN pip install mmcls
RUN pip install prettytable


# RUN adduser --disabled-password --gecos "" --force-badname --ingroup 1024 worker 
USER worker



# CMD ["python", "hello_world.py"]
# CMD ["/bin/bash", "sleep.sh"]
CMD ["/bin/bash", "mmgeneration/tools/dist_train.sh", "mmgeneration/configs/styleganv3/stylegan3_t_noaug_fp16_gamma2.0_ffhq_256_b4x8_dfire.py", "1"]