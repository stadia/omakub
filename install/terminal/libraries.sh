#!/bin/bash

sudo pacman -S --noconfirm \
  base-devel autoconf bison clang rust python-pipx \
  openssl readline zlib libyaml ncurses libffi gdbm jemalloc \
  libvips imagemagick mupdf mupdf-tools \
  redis sqlite mariadb-libs postgresql-libs postgresql
