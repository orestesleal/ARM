#! /bin/sh

# script to get the temp in an ODROID-XU4 SBC and convert it to grades
# centrigrades showing the current temp every 1 second and warning with
# a sound if the temp exceeds a certain (configurable) threshold.
#
# Orestes Leal Rodriguez, 2018
#

while true
 do

   DROID=$(cat /proc/cpuinfo | sed -n 's/^Hardware *\t*: *//p')


   # top header
   CPU_state=$(cat /proc/cpuinfo | sed -n '/^processor/,/^Bogo/{
      s/processor.*:[^0-9]/CPU: /
      /model name/d
      s/\n//
      s/BogoMIPS *[^0-9]//
      s/://
      p
}')

   echo $CPU_state


   if [ $DROID = "ODROID-XU4" ]; then

     TEMP=$(sudo cat /sys/devices/virtual/thermal/thermal_zone0/temp)
     echo $DROID: $TEMP \
      |
     awk '{

       threshold = 80;    # something higher than this will require attention
                          # "configure" your desired value here (in celsius)
       temp = $2/1000
     
        if (temp > threshold)  {
           print "### WARNING: your odroid have a hight temp!", temp, "�C"
  
           # you can configure the action to whatever you want, email, etc
           # here is going to play an alarm using aplay(1) by repeating 
           # the sound using a loop, alarm.wav should be in the same directory
           # from where the script is running


           # NOTE: an alarm might be a transient hight temp due to compiling, etc
           # it should go away if the temps drops, this loop warns 6 times. Adjust
           # accordinly

           for (i = 0; i <= 5; i++)
              system("aplay alarm.wav")
        
        }
        else
           print $1, "temp = ", temp, "�C"
           print "### current CPU frequencies.."
           for (i = 0; i <=7; i++) {
              printf "%s %d %s\n", "sudo cat /sys/devices/system/cpu/cpu", $i, "/cpufreq/cpuinfo_max_freq"
           }
     }'
   else
     echo "## Error: this board is NOT an ODROID-XU4"
     exit 1
   fi

   sleep 1
   clear

done
