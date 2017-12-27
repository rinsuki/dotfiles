FROM ubuntu:17.04

RUN sed -i -e 's/archive.ubuntu.com/ftp.jaist.ac.jp/g' /etc/apt/sources.list && \
    sed -i -e 's/security.ubuntu.com/ftp.jaist.ac.jp/g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y ffmpeg python3 nano && \
    apt-get clean

RUN useradd -m user && \
    echo "user ALL=(ALL) ALL" >> /etc/sudoers && \
    chsh -s /bin/bash user

ADD . /home/user/dotfiles
RUN chown -R user:user /home/user/dotfiles

USER user
RUN cd ~/dotfiles && ./install.py

CMD ["bash"]