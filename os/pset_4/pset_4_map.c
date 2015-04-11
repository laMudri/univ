#define _XOPEN_SOURCE 500

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/mman.h>

void die(const char* loc, int err) {
  printf("%s: %s\n",loc,strerror(err));
  exit(1);
}

int pagemaps_fd() {
  int fd = -1;

  while (fd == -1) {
    fd = open("/proc/self/maps",O_RDONLY);
    if (fd == -1) {
      die("open",errno);
    } else {
      break;
    }
  }
  return fd;
}

off_t read_max_until_eof(int fd, char* buf, int max) {
  ssize_t sz;

  sz = read(fd,buf,max);
  if (sz == -1) {
    die("read",errno);
  }

  buf[sz] = 0;
  return sz;
}

void print_pagemaps() {
  int fd;
  char buf[4096];

  fd = pagemaps_fd();
  read_max_until_eof(fd,buf,4096);

  printf("%s\n",buf);

  if (close(fd)) {
    die("close",errno);
  }
}

int main() {
  int fd;
  void *mptr;
  char *ptr,*p;
  long int s = 1 << 16;

  print_pagemaps();

  ptr = p = malloc(s);

  while(s > 0) {
    *(++p) = 0xff;
    s--;
  }

  print_pagemaps();
  free(ptr);

  fd = open("pset_4_map_mmap",O_CREAT,0600);
  mptr = mmap((void *) 0x10000,0x1000,PROT_EXEC,MAP_PRIVATE,fd,0);

  print_pagemaps();
  munmap(mptr,0x1000);
  
  return 0;
}
