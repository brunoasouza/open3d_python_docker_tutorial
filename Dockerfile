FROM ubuntu:22.04


RUN apt-get update 
RUN apt install -y xvfb 
RUN apt-get install -y python3.10 python3-pip curl

RUN apt-get install --no-install-recommends -y \
    libegl1 \
    libgl1 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://archive.ubuntu.com/ubuntu focal main universe" > /etc/apt/sources.list
RUN apt-get update 
RUN apt-get install -y --no-install-recommends libgl1-mesa-glx \
    libgl1-mesa-dri \
    libllvm10 \
    libpq-dev \
    gcc 

WORKDIR /src


# Install dependences
RUN pip install open3d

RUN mkdir output

# copy files
COPY mesh.py .  
COPY startup.sh .

RUN chmod +x ./startup.sh


CMD ["/bin/bash", "./startup.sh"]

