#!/usr/bin/env bash

# Run zerofree to zero out any free space on the disk
init 1
mount -o remount,ro /dev/sda1
zerofree /dev/sda1

shutdown -h now
