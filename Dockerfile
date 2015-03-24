FROM       cine/base-image-docker

MAINTAINER Jeffrey Wescott <jeffrey@cine.io>

# install additional media tools
RUN apt-get install -y gpac flvmeta

# install ffmpeg-related libaries
RUN apt-get install -y libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev libx264-dev libfdk-aac-dev libvpx-dev libspeex-dev libmp3lame-dev libfaac-dev libxvidcore-dev libopus-dev

# get sources for cine.io custom ffmpeg (master always clean)
# when we want to update FFmpeg, update cine-io/ffmpeg#master
WORKDIR /usr/src
RUN git clone git@github.com:ffmpeg/FFmpeg.git

# make sure we're on the right branch
WORKDIR /usr/src/FFmpeg
RUN git checkout tags/n2.6.1

# build ffmpeg
WORKDIR /usr/src/FFmpeg
RUN ./configure \
  --prefix=/usr/local \
  --enable-shared \
  --enable-pthreads \
  --enable-gpl \
  --enable-version3 \
  --enable-nonfree \
  --enable-hardcoded-tables \
  --enable-avresample \
  --enable-vda \
  --enable-libass \
  --enable-libx264 \
  --enable-libfaac \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libspeex \
  --enable-libxvid
RUN make install
RUN make distclean

# rehash LD_LIBRARY_PATH
RUN ldconfig
