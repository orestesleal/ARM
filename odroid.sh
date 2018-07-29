#! /bin/sh
# script to get the temp in an ODROID-XU4 SBC and convert it to grades
# centrigrades showing the current temp every 1 second and warning with
# a sound if the temp exceeds a certain (configurable) threshold.
#
# Orestes Leal Rodriguez, 2018
#
DELAY=2     # delay betwen refreshes, default 2 sec
while true
 do
   if [ $(sed -n 's/^Hardware *\t*: *//p' /proc/cpuinfo) = "ODROID-XU4" ]; then
     sudo cat /sys/devices/virtual/thermal/thermal_zone0/temp \
      |
     cut -b -2 \
      |
     awk '{
       threshold = 80;    # something higher than this will require attention
        if ($1 > threshold)  {
          print "### WARNING: your odroid have a hight temp!", $1, "°C"
           for (i = 0; i <= 5; i++)
             system("aplay alarm.wav")
        }
        else
          print "ODROID-XU4:", "temp = ", $1, "°C"
     }'
   else
     echo "## Error: this board is NOT an ODROID-XU4"; exit 1
   fi
   for cpu in 0 1 2 3 4 5 6 7; do
     sudo cat /sys/devices/system/cpu/cpu$cpu/cpufreq/cpuinfo_cur_freq 
    done \
     |
    awk '{ print "\tCPU"NR-1,$1/1000,"MHz" }'
   sleep $DELAY
   clear
 done
