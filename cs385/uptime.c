//#include "param.h"
#include "types.h"
//#include "stat.h"
#include "user.h"
//#include "fs.h"
//#include "fcntl.h"
//#include "syscall.h"
//#include "traps.h"
//#include "memlayout.h"

#define TICKS_PER_SEC 100.0
#define HOURS 1
#define MINUTES 2
#define SECONDS 3
#define SECONDS_PER_HOUR (60.0*60.0)
#define MINUTES_PER_HOUR 60.0
#define SECONDS_PER_MINUTE 60.0

int stdout = 1;

int * calc_uptime() {
  int total_ticks, total_seconds;
  double hours, minutes, seconds;
  int *uptime_arr = (int*)malloc(sizeof(int)*3);

  total_ticks = uptime();
  total_seconds = total_ticks / TICKS_PER_SEC;

  hours = total_seconds / SECONDS_PER_HOUR; // done
  minutes = (hours-(int)hours) * MINUTES_PER_HOUR;
  seconds = (minutes-(int)minutes) * SECONDS_PER_MINUTE;

  uptime_arr[HOURS] = (int)hours;
  uptime_arr[MINUTES] = (int)minutes;
  uptime_arr[SECONDS] = (int)seconds;

  return uptime_arr;
}

int main(int argc, char* argv[]){

  int *uptime_arr = calc_uptime();
  printf(stdout, "current uptime is %d:%d:%d\n", uptime_arr[HOURS], uptime_arr[MINUTES], uptime_arr[SECONDS]);

  exit();
}
