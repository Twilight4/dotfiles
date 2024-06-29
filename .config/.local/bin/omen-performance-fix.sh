#!/bin/bash

# Run this script as root
# Script fixes performance issues by setting the EC register 0x95 to value of 0x31

modprobe -r ec_sys
modprobe ec_sys write_support=1
echo -n -e "\0x31" | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=149 count=1 conv=notrunc
