/*
 * Support script for odroid.sh
 * will read the temperature and return the converted value
 * as the return value of the function
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int
main(void)
{
    char *thermal = "/sys/devices/virtual/thermal/thermal_zone0/temp";
    char buf[8];
    ssize_t r;
    int temp;

    int fd = open(thermal, NULL);
  
    if (fd == -1) {
       fprintf(stderr, "open(2): Couln't open %s\n", thermal);
       return EXIT_FAILURE;
    }

    r = read(fd, &buf, 7);
    if (r < 0) {
       fprintf(stderr, "read(2): failed, couln't read from the file into the buffer\n");
       return EXIT_FAILURE;
    }

    buf[r] = '\0';
    temp = (atoi((const char *)&buf)/1000);
    close(fd);
    
 return temp;
}
