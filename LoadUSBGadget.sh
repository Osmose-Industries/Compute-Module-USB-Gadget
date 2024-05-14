#!/bin/bash

. gadget.config

SYSDIR=/sys/kernel/config

# Probe libcomposite if not probe
if [ ! -d $SYSDIR ]; then
    modprobe libcomposite
    mount -t configfs none /sys/kernel/config
fi

# Create the USB Gadget
cd $SYSDIR/usb_gadget/
mkdir -p $address
cd $address

# Set the VendorID and ProductID
echo $vendorId > idVendor
echo $productId > idProduct

# Set serial number, manufacturer and product name in English locale
mkdir -p strings/0x409
echo $serialnumber > strings/0x409/serialnumber
echo $manufacturer > strings/0x409/manufacturer
echo $product > strings/0x409/product

# Add config
mkdir -p configs/c.1/strings/0x409
echo $configuration > configs/c.1/strings/0x409/configuration
echo $maxpower > configs/c.1/MaxPower

# Define HID function
mkdir functions/hid.usb0
echo $protocol > functions/hid.usb0/protocol
echo $subclass > functions/hid.usb0/subclass
echo $reportlength > functions/hid.usb0/report_length

# Set HID Report Description
cat $reportdescpath > functions/hid.usb0/report_desc

# Bind configuration
ln -s functions/hid.usb0 configs/c.1

# Activate the gadget
echo $address > UDC