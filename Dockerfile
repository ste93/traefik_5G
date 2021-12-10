FROM randaz81/r1slam:ros2galactic
LABEL maintainer="daniele.domenichelli@iit.it"

ARG username
ARG uid
ARG gid

USER root

# Fix the user
RUN groupmod -g $gid $username && \
    usermod -u $uid -g $gid -G adm,users,sudo,root $username && \
    find / -uid 33334 -exec chown -h $uid '{}' \; 2> /dev/null || true && \
    find / -gid 33334 -exec chgrp $gid '{}' \; 2> /dev/null || true && \
    chown -R $username: /home/$username && \
    mkdir -p /run/user/$uid && \
    chown $username: /run/user/$uid && \
    chmod 700 /run/user/$uid && \
    mkdir -p /run/user/$uid/dconf && \
    chown $username: /run/user/$uid/dconf && \
    chmod 700 /run/user/$uid/dconf && \
    mkdir -p /home/$username/.ros && \
    mkdir -p /home/$username/.config/yarp && \
    mkdir -p /home/$username/.local/share/yarp && \
    chown -R $username: /home/$username/

RUN apt update -qq && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    python3-tornado swig


RUN cd /home/$username/ycm/build && \
    make uninstall && \
    cd .. && \
    git fetch --all --prune && \
    git checkout v0.13.0 && \
    cd build && \
    cmake . -DCMAKE_BUILD_TYPE=Debug && \
    make -j4 && \
    make install && \
    chown -R $username: /home/$username/ycm

RUN cd /home/$username/yarp/build && \
    make uninstall && \
    cd .. && \
    git fetch --all --prune && \
    git checkout master && \
    git reset --hard origin/master && \
    cd build && \
    cmake . -DCMAKE_BUILD_TYPE=Debug -DYARP_COMPILE_BINDINGS=ON -DCREATE_PYTHON=ON && \
    make -j4 && \
    make install && \
    chown -R $username: /home/$username/yarp


RUN cd /home/$username &&  \
    git clone https://github.com/elandini84/yarp-web-teleop && \
    echo 202112091 && \
    chown -R $username: /home/$username/yarp-web-teleop

# RUN cd /usr/local/src && \
#     wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz && \
#     tar xzf noip-duc-linux.tar.gz && \
#     rm -rf noip-duc-linux.tar.gz && \
#     cd no-ip-2.1.9* && \
#     make -j16 && \
#     make -j16 install



USER $username
WORKDIR /home/$username
