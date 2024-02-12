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
  * [Create UUP Dump File for Windows 11](#create-uup-dump-file-for-windows-11)
  * [Building Windows 11 ISO on Ampere Platform](#build-windows-11-iso-on-ampere-platform)
  * [Create Bootable USB for Windows 11 with Rufus](#create-bootable-usb-for-windows-11-with-rufus)
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
  * Ampere Altra Developer Platform[^1]
  * Ampere Altra Dev Kit[^1]
* An additional client for (1) downloading UUP dump file and (2) creating a bootable USB drive running
  * Windows 11 on ARM, or 
  * Windows 11 on x64.

### Software 
1. UUP Dump
2. Rufus
3. Windows 11 ARM or X64

## Hardware Environment
AADP revision A1 has bug related to GRUB and **A2** revision is recommended.

### Monitors connected to builtin VGA
One monitor can connect to builtin VGA output is required.

## Install Windows 11 via ISO

### Create UUP Dump File for Windows 11
There are multiple sites which can assist with building Windows 11 ISOs. UUP Dump[^2] site is one of them, and is documented here.

On one of the additional clients, browse to [https://uupdump.net/known.php?q=windows+11+arm](https://uupdump.net/known.php?q=windows+11+arm), and then follow the steps to create and download a UUP Dump file.
1. Select the base image on the following page.
![Select base image](images/uud-dump-p1.png)
2. Select the language and click `next`.
![Select language and click next](images/uud-dump-p2.png)
3. Select the edition and click `next`.
![Select edition and click next](images/uud-dump-p3.png)
4. Select the `Download method` and `Conversion options` and download the zip file.
![Select the `Download method` and `Conversion options` and download the zip file](images/uud-dump-p4.png)

### Build Windows 11 ISO on Windows running on x64 or ARM CPU

Download the zip file, e.g.
22631.3085_arm64_en-us_professional_ebde6b33_convert.zip and save it to
a folder such as the Desktop. Unzip it, then launch a Command Prompt and `cd`
to the directory containing the files. Next, run:

```
uup_download_windows.cmd
```

### Create Bootable USB for Windows 11 with Rufus
As the ISO has a Secure Boot option, this need to be removed. Currently there is only one tool, rufus[^3], which has this feature to remove the Secure Boot.

**Note**: Bootable USB created with `dd` command can boot into installation UI, but not able to find any installation media. 
If there is an Ampere or other Arm based client running Windows for Arm, download the Arm version, saying [rufus-4.0_arm64.exe](https://github.com/pbatard/rufus/releases/download/v4.0/rufus-4.0_arm64.exe). Otherwise, download x86 or x64 version for non-arm based clients.

When creating the USB, disable TPM (default).

1. Click the Select button next to Disk or ISO image > Browse to and select the generated Windows 11 ISO file.
![D](images/rufus-device.png)
2. After clicking the Start button, a "Customize Windows Installation" dialog will appear. Check all check boxes, including `Remove requirement for 4GB+RAM, Secure Boot and TPM2.0` and `Remove required for an online Microsoft account`.
![D](images/rufus-tpm.png)

### Install Windows on Ampere Workstation

Following the document[^4], boot the system from the USB created above and install Windows 11 as normal.

Again, if no installation media found after boot into installation UI, the USB need to be recreated with TPM removed.

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
Not supported yet.
```
PS> wsl --install
...
Error
```

## Applications Development

WIP[^5]

PCIDRV[^6]

## References
[^1]: https://www.ipi.wiki/products/ampere-altra-developer-platform

[^2]: https://uupdump.net/known.php?q=windows+11+arm

[^3]: https://rufus.ie/de/

[^4]: https://www.ipi.wiki/pages/comhpc-docs?page=index.html

[^5]: https://learn.microsoft.com/en-us/windows/arm/dev-kit/
[^6]: https://learn.microsoft.com/en-us/samples/microsoft/windows-driver-samples/pcidrv---wdf-driver-for-pci-device/
[^9]: Cmake for windows arm64
[^10]: Python 3.11 for Windows ARM
TortoiseSVN
Git
[^7]: https://www.hanselman.com/blog/how-to-ssh-into-a-windows-10-machine-from-linux-or-windows-or-anywhere
