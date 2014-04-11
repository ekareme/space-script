#! /bin/sh
if lsmod | grep rtc-ds3232 &> /dev/null ; then
    echo "rtc-ds3232 is loaded!"
    exit 0
else
    # Realtime clock
    modprobe rtc-ds3232
    echo ds3232 0x68 > /sys/bus/i2c/devices/i2c-1/new_device
    driverpath=$(find /sys/bus/i2c/devices/1-0068/ -type d -name 'iio:device*')
    sed -i "s|RTCDS3232PATH=.*|RTCDS3232PATH='$driverpath'|g" /etc/profile        
    export RTCDS3232PATH="$driverpath"
    exit 1 # not sure if driver was loading correctly
fi
