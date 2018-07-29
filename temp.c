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
    int threshold = 80;
    int delay = 2;

    while (1) {
    
      // read
      // convert number
      // compare against threshold

      int fd = open(thermal, NULL);
  
      if (fd == -1) {
         fprintf(stderr, "open(2): Couln't open %s\n", thermal);
         return EXIT_FAILURE;
      }

      r = read(fd, &buf, 7);
      if (r < 1) {
         fprintf(stderr, "read(2): failed, couln't read from the file\n");
         return EXIT_FAILURE;
      }

      buf[r] = '\0';
      temp = (atoi((const char *)&buf)/1000);

      if (temp > threshold) {
          printf("##### Warning. hight temp!! %d > %d\n", temp, threshold);
          // more actions here
      }
      else 
        printf("%d\n", temp);
     
      close(fd);
      sleep(delay);
    }
    
 return EXIT_SUCCESS;
}