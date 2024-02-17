#!/bin/bash

# Start EtherCAT
sudo systemctl start ethercat

# Set EtherCAT state to PREOP
sudo ethercat states preop

# Wait for 3 seconds
sleep 3

# EtherCAT SDO Configuration
sudo ethercat download -p 0 -t uint16 0x1C12 0 0
sudo ethercat download -p 0 -t uint16 0x1C13 0 0
sudo ethercat download -p 0 -t uint16 0x1A00 0 0
sudo ethercat download -p 0 -t uint16 0x1A00 1 0x60410010
sudo ethercat download -p 0 -t uint16 0x1A00 2 0x60640020
sudo ethercat download -p 0 -t uint16 0x1A00 3 0x60B90010
sudo ethercat download -p 0 -t uint16 0x1A00 4 0x60BA0020
sudo ethercat download -p 0 -t uint16 0x1A00 5 0x60FD0020
sudo ethercat download -p 0 -t uint16 0x1A00 0 0x05

sudo ethercat download -p 0 -t uint16 0x1A01 0 0
sudo ethercat download -p 0 -t uint16 0x1A01 1 0x60410010
sudo ethercat download -p 0 -t uint16 0x1A01 2 0x60400020
sudo ethercat download -p 0 -t uint16 0x1A01 3 0x606C0020
sudo ethercat download -p 0 -t uint16 0x1A01 0 0x03

sudo ethercat download -p 0 -t uint16 0x1A02 0 0
sudo ethercat download -p 0 -t uint16 0x1A02 1 0x60410010
sudo ethercat download -p 0 -t uint16 0x1A02 2 0x60400020
sudo ethercat download -p 0 -t uint16 0x1A02 3 0x606C0020
sudo ethercat download -p 0 -t uint16 0x1A02 0 0x03

sudo ethercat download -p 0 -t uint16 0x1A03 0 0
sudo ethercat download -p 0 -t uint16 0x1A03 1 0x60410010
sudo ethercat download -p 0 -t uint16 0x1A03 2 0x60640020
sudo ethercat download -p 0 -t uint16 0x1A03 3 0x60770010
sudo ethercat download -p 0 -t uint16 0x1A03 0 0x03

sudo ethercat download -p 0 -t uint16 0x1600 0 0
sudo ethercat download -p 0 -t uint16 0x1600 1 0x60400010
sudo ethercat download -p 0 -t uint16 0x1600 2 0x607A0020
sudo ethercat download -p 0 -t uint16 0x1600 3 0x60600008
sudo ethercat download -p 0 -t uint16 0x1600 4 0x60B80010
sudo ethercat download -p 0 -t uint16 0x1600 0 0x04

sudo ethercat download -p 0 -t uint16 0x1601 0 0
sudo ethercat download -p 0 -t uint16 0x1601 1 0x60400010
sudo ethercat download -p 0 -t uint16 0x1601 2 0x607A0020
sudo ethercat download -p 0 -t uint16 0x1601 3 0x60FF0020
sudo ethercat download -p 0 -t uint16 0x1601 0 0x03

sudo ethercat download -p 0 -t uint16 0x1602 0 0
sudo ethercat download -p 0 -t uint16 0x1602 0 0x60400010
sudo ethercat download -p 0 -t uint16 0x1602 0 0x60FF0020
sudo ethercat download -p 0 -t uint16 0x1602 0 0x02

sudo ethercat download -p 0 -t uint16 0x1603 0 0
sudo ethercat download -p 0 -t uint16 0x1603 0 0x60400010
sudo ethercat download -p 0 -t uint16 0x1603 0 0x60710020
sudo ethercat download -p 0 -t uint16 0x1603 0 0x02

sudo ethercat download -p 0 -t uint16 0x1C12 1 0x1601
sudo ethercat download -p 0 -t uint16 0x1C12 0 0x01
sudo ethercat download -p 0 -t uint16 0x1C13 1 0x1A01
sudo ethercat download -p 0 -t uint16 0x1C13 0 0x01

sudo ethercat download -p 0 -t uint16 0x6060 0 8
sudo ethercat download -p 0 -t uint16 0x60C2 1 0x04
sudo ethercat download -p 0 -t uint16 0x60C2 2 0xFD

# Set EtherCAT state to OP
sudo ethercat states op

# Wait for 3 seconds
sleep 3
