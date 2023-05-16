# Summary
This repo contains scripts and documents to create Windows 11 ISO and install Windows 11 on Ampere CPU based workstation.
# Create UUP Dump File for Windows 11
Microsoft does not release Windows 11 ISO on a regular bases. Create and download a uud dump convertion file, say 25336.1010_arm64_en-us_professional_16de9bb8_convert.zip, from this [site](https://uupdump.net/known.php?q=windows+11+arm). 

But this section has details on how to prepare UUP dump files for building Windows 11 ISO. 

# Build Windows 11 ISO on Ampere Platform
Copy download zip file to a Ampere system running Ubuntu and create the Windows 11 ISO with the following commands. 
```
sudo apt install unzip -y 
unzip 22621.1555_arm64_en-us_professional_77b56537_convert.zip
cd 22621.1555_arm64_en-us_professional_77b56537_convert
sudo apt install aria2 cabextract wimtools chntpw -y 
sh uup_download_linux.sh
mv 22621xxx.iso iso/
```
# Create Bootable USB for Windows 11 with Rufus
Create bootable usb with [rufus](https://rufus.ie/de/). 

When creating the USB, disable TPM. 
1. Click the Select button next to Disk or ISO image > Browse to and select the downloaded Windows 11 iso file
1. Select Extended Windows 11 Installation (no TPM / no Secure Boot) from the Image option dropdown
1. Select MBR from the Partition scheme dropdown

Note: USB created with `dd` does not work after booting but missing installation media. 

# Install Windows on Ampere Workstation
Boot the system from the USB created above and install Windows 11 as normal.
