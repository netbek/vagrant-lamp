# vagrant-lamp

Base box build script for Debian 7 (wheezy)

## Download

http://debian.mirror.ac.za/debian-cd/7.8.0/i386/iso-cd/debian-7.8.0-i386-CD-1.iso
http://dlc-cdn.sun.com/virtualbox/4.3.26/virtualbox-4.3_4.3.26-98988~Debian~wheezy_i386.deb
http://dlc-cdn.sun.com/virtualbox/4.3.26/VBoxGuestAdditions_4.3.26.iso

## Create new VM in VirtualBox 

Name: wheezy32-lamp
Type: Linux
Version: Debian 32-bit
Memory: 512 MB
Select: Create a virtual hard drive now
Select: VMDK
Select: Dynamically allocated
File location: wheezy32-lamp
Size: 8 GB
Change settings

Motherboard:

* Base memory: 512 MB
* Boot order: CD/DVD, hard disk
* Enable I/O APIC
* Hardware clock in UTC time

Processor:

* 1 CPU
* Enable PAE/NX

Disable audio, USB

Storage: Go to CD/DVD and insert debian-7.8.0-i386-CD-1.iso

Start VM

## Install Debian

Set your hostname (vagrant-debian-wheezy)
Set the domain name (vagrantup.com)
Set the root password (vagrant)
Set up a user (vagrant with vagrant as the password too)
Follow the defaults to set up the disk, all one partition

Deselect all tasks except "Standard system utilities" and continute to allow the system to install the required packages.

Next the installer asks about GRUB. Just take all the defaults and install it to the root of the drive.

Shutdown VM

Remove Debian ISO from CD/DVD and insert VBoxGuestAdditions ISO (VirtualBox > vm > Settings > Storage > CD/DVD)

## Install LAMP

Start VM

Log in as root

Remove cdrom from APT sources:
```
nano /etc/apt/sources.list
```

Update APT, install git, clone repo, start build:
```
apt-get update
apt-get install -y git
cd ~
git clone https://github.com/netbek/vagrant-lamp
cd ~/vagrant-lamp
chmod 0700 build.sh
bash build.sh
```

Shutdown VM

Remove VBoxGuestAdditions ISO (VirtualBox > vm > Settings > Storage > CD/DVD)

## Package base box

Start VM

Log in as root

Zero free disk space:
```
cd ~/vagrant-lamp
chmod 0700 package.sh
bash package.sh
```

Shutdown VM

On host, package the base box:
```
cd "~/VirtualBox VMs"
vagrant package --base wheezy32-lamp --output wheezy32-lamp.box
```
