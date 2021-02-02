#!/bin/bash -x
# gcc `pkg-config --cflags libvlc` `pkg-config --libs libvlc` test_libvlc.c -o test
  gcc `pkg-config --cflags libvlc` libvlc_test1.c  `pkg-config --libs libvlc`  -o libvlc_test1

