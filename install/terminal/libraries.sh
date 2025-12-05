#!/bin/bash

sudo pacman -S --noconfirm \
  base-devel autoconf bison clang rust python-pipx \
  openssl readline libyaml ncurses libffi gdbm jemalloc \
  libvips imagemagick mupdf mupdf-tools \
  mariadb-libs postgresql-libs
