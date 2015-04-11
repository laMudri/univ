#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>

int main() {
  int fd, k;
  char buf[256];
  
  unlink("tmpdir/file");
  mkdir("tmpdir",0777);
  printf("mkdir tmpdir\n");
  system("ls -la tmpdir");
  printf("\n\n");

  fd = open("tmpdir/file",O_CREAT | O_RDWR,0600);

  printf("open O_CREAT\n");
  system("ls -la tmpdir");
  printf("\n\n");

  // begin write
  k = write(fd,"hello\0",6);
  printf("wrote %d bytes\n",k);
  k = fsync(fd);
  printf("fsync %d\n\n",k);
  // end write

  printf("fsync\n");
  system("ls -la tmpdir");
  printf("\n\n");
  lseek(fd,0,SEEK_SET);
  k = read(fd,buf,6);
  printf("read %d bytes: <%s>\n\n",k,buf);

  unlink("tmpdir/file");

  printf("unlink\n");
  system("ls -la tmpdir");
  printf("\n\n");
  lseek(fd,0,SEEK_SET);
  k = read(fd,buf,6);
  printf("read %d bytes: <%s>\n",k,buf);  

  rmdir("tmpdir");
  
  return 0;
}
