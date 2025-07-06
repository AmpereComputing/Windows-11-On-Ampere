![Ampere Computing](https://avatars2.githubusercontent.com/u/34519842?s=400&u=1d29afaac44f477cbb0226139ec83f73faefe154&v=4)

# Windows-11-On-Ampere

## Summary

This repo contains scripts and documents to assist in the installation of Windows on Ampere Platforms. It also contain applications that currently supported on this platform and how to develop applications natively on Ampere for ARM64. 

## Table of Contents
* [Introduction](#introduction)
* [Requirements](#requirements)
  * [Hardware](#hardware)
  * [Operating System](#operating-system)
* [Hardware](#hardware-environment) 
  * [Monitors connected to builtin VGA](#monitors-connected-to-builtin-vga)
* [Install Windows 11 via ISO](#install-windows-via-iso)
  * [Create Bootable USB Drive on Linux](#create-bootable-usb-on-linux)
  * [Create Bootable USB Drive on Windows with Rufus](#create-bootable-usb-on-windows-with-rufus)
  * [Install Windows on Ampere Workstation](#install-windows-on-ampere-workstation)
* [Peripheral](#peripheral)
* [Applications](#applications)
* [Application Development](#applictation-development)
* [References](#references)

## Introduction
Currently Arm based client devices like Microsoft Surface Pro 9, Lenovo ThinkPad X13s, etc., are all based on Arm SOC like Snapdragon. These devices are good for portable or mobile scenario like pads or laptops running low demanding applications. The SOCs include CPU and other components and are well supported by VHDX images, which is available on the Microsoft Insider preview program. 

On Ampere CPU based Arm workstations, on the other hand, there is a dedicated Arm based CPU without other components. Installation of these systems should follow normal ISO approaches used on installing Windows 11 on PCs, although VHDX could work too with extra driver components not needed.

As of the time of this preparing this documents, there are no updated Windows 11 ISO available on Windows 11 preview program. But there are other approaches to create Windows 11 installation ISO, which can be used to install Windows 11 on Ampere CPU based workstations normally.

Note: This is part of Ampere's [Arm Native Solutions](https://amperecomputing.com/solutions/arm-native) including cloud gaming, cloud phone, [Jetson 11 on Ampere](https://github.com/AmpereComputing/Jetson-on-Ampere), and [edge solutions](https://amperecomputing.com/home/edge). 
## Requirements

### Hardware
* An Ampere CPU based workstation to be installed Windows 11
  * ADLINK Ampere Altra Developer Platform[^1]
  * ADLINK Ampere Altra Dev Kit[^1]
  * ASRock Rack ALTRAD8UD-1L2T
  * ASRock Rack ALTRAD8UD2-1L2Q
  * ASRock Rack AMPONED8-2T/BCM

#### TPM Module

Unless it's disabled via the tool used to write the USB drive, a TPM module is required to boot Windows 11.
ADLINK boards have one built-in; on ASRock Rack boards you need the TPM-SPI module that plugs into a header.
It can be purchased via Newegg or MITXPC:

https://www.newegg.com/asrock-rack-tpm-spi/p/N82E16816775069?Item=9SIAMNEJZY1413
https://mitxpc.com/products/tpm-spi

### Software

Linux, or Windows 11 with Rufus

## Hardware Environment
ADLINK: AADP revision A1 has bug related to GRUB and **A2** revision is recommended.

### Monitors connected to builtin VGA
One monitor can connect to builtin VGA output is required.

## Install Windows 11 via ISO

Download the Windows 11 ISO via [Download Windows 11 for Arm-based PCs](https://www.microsoft.com/en-us/software-download/windows11arm64).

### Create Bootable USB Drive on Linux

Insert a USB drive which you'd like to use to install Windows. It will be erased, so make sure you don't want any of the data on it.
Run the following commands, where 'sdx' is the drive device name and '#' represents the root shell prompt (you can also run commands with 'sudo'):
```
# wipefs -a /dev/sdx
# parted /dev/sdx mklabel gpt
# parted -a optimal /dev/sdx mkpart primary fat32 0% 1GB
# parted -a optimal /dev/sdx mkpart primary fat32 1GB 100%
# mkdir win11iso usb-boot usb-install
# mkfs.vfat /dev/sdxp1
# mkfs.ntfs --fast /dev/sdxp2
# mount Win11_24H2_English_Arm64.iso win11iso
# mount /dev/sdxp1 usb-boot
# mount /dev/sdxp2 usb-install
# cp -r win11iso/{boot,bootmgr.efi,efi,setup.exe,support} usb-boot
# mkdir usb-boot/sources
# cp win11iso/sources/boot.wim usb-boot/sources
# cp -r win11iso/sources usb-install
# umount usb-boot
# umount usb-install
# umount win11iso
# rmdir usb-boot usb-install win11iso
```

### Create Bootable USB Drive on Windows with Rufus
If you don't have a TPM installed, you can remove the requirement for Secure Boot. Currently there is only one tool, rufus[^3], which has this feature to remove the Secure Boot.

**Note**: Bootable USB drives created with `dd` can boot into installation UI, but aren't able to find any installation media. 
If there is an Ampere or other Arm based client running Windows for Arm, download the 'arm64' version, e.g. [rufus-4.9_arm64.exe](https://github.com/pbatard/rufus/releases/download/v4.9/rufus-4.9_arm64.exe). Otherwise, download x86 or x64 version for non-arm based clients.

When creating the USB drive, disable TPM (default).

1. Click the Select button next to Disk or ISO image > Browse to and select the Windows 11 ISO file.
![D](images/rufus-device.png)
2. After clicking the Start button, a "Customize Windows Installation" dialog will appear. Check all check boxes, including `Remove requirement for 4GB+RAM, Secure Boot and TPM2.0` and `Remove required for an online Microsoft account`.
![D](images/rufus-tpm.png)

### Install Windows on Ampere Workstation

Following the document[^4], boot the system from the USB drive created above and install Windows 11 as normal.

Again, if no installation media found after boot into installation UI, the USB drive need to be recreated with TPM removed.

### Update VGA Driver 
Download the latest VGA driver and install it. With the latest VGA driver, Windows 11 can support 1920x1080 monitors.

## Peripheral
### NIC
Currently the builtin NIC is not supported by Windows 11, but certain USB based NICs are found to be working well with Windows 11.
Here is the list of NICs tested.

| Brand              | Chip | Type | Tested Date | Working |
| :---------------- | :------: | :------: | :----: | :----: |
| Diamond       |   RealTek   |   USB   | May 23, 2023 | Yes |
| Benfei       |   RealTek   | USB | May 25, 2023 | Yes |
| Intel       |   Intel   | PCI | May 23, 2023 | No |

## Applications
### SSH Server on Windows 11
The SSH server can be installed on Windows 11 and enable remote access[^7].

Open PowerShell terminal with Administrator and run the following commands.
```
> Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'

Name  : OpenSSH.Client~~~~0.0.1.0
State : Installed

Name  : OpenSSH.Server~~~~0.0.1.0
State : NotPresent

> Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
> Start-Service sshd
> Get-Service sshd
> Set-Service -Name sshd -StartupType 'Automatic'
```

After that, the port 22 need to be opened from firewall settings.

### WSL
```
C:\Users\My Name>wsl --list --online
The following is a list of valid distributions that can be installed.
The default distribution is denoted by '*'.
Install using 'wsl --install -d <Distro>'.

  NAME                   FRIENDLY NAME
* Ubuntu                 Ubuntu
  Debian                 Debian GNU/Linux
  Ubuntu-18.04           Ubuntu 18.04 LTS
  Ubuntu-20.04           Ubuntu 20.04 LTS
  Ubuntu-22.04           Ubuntu 22.04 LTS
  openSUSE-Tumbleweed    openSUSE Tumbleweed

C:\Users\My Name>wsl --install
The requested operation requires elevation.
Installing: Virtual Machine Platform
Virtual Machine Platform has been installed.
Installing: Windows Subsystem for Linux
Windows Subsystem for Linux has been installed.
Installing: Ubuntu
Ubuntu has been installed.
The requested operation is successful. Changes will not be effective until the system is rebooted.
```

## Applications Development

WIP[^5]

PCIDRV[^6]

## References
[^1]: https://www.ipi.wiki/products/ampere-altra-developer-platform

[^2]: https://uupdump.net/known.php?q=windows+11+arm

[^3]: https://rufus.ie/en/

[^4]: https://www.ipi.wiki/pages/comhpc-docs?page=index.html

[^5]: https://learn.microsoft.com/en-us/windows/arm/dev-kit/
[^6]: https://learn.microsoft.com/en-us/samples/microsoft/windows-driver-samples/pcidrv---wdf-driver-for-pci-device/
[^9]: CMake for windows arm64
[^10]: Python 3.11 for Windows ARM
TortoiseSVN
Git
[^7]: https://www.hanselman.com/blog/how-to-ssh-into-a-windows-10-machine-from-linux-or-windows-or-anywhere
