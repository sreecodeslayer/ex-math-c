/* erl_comm.c from http://erlang.org/doc/tutorial/c_port.html#id57564 */

// https://bytefreaks.net/programming-2/c-programming-2/c-implicit-declaration-of-function-read-and-write
#include <unistd.h>
// To handle errors
#include <err.h>
#include <errno.h>

#include <stdlib.h>
#include <string.h>

typedef unsigned char byte;

int read_exact(byte *buf, int len)
{
  int i, got=0;

  do {
    if ((i = read(STDIN_FILENO, buf+got, len-got)) <= 0)
      return(i);
    got += i;
  } while (got<len);

  return(len);
}

int write_exact(byte *buf, int len)
{
  int i, wrote = 0;

  do {
    if ((i = write(STDOUT_FILENO, buf+wrote, len-wrote)) <= 0)
      return (i);
    wrote += i;
  } while (wrote<len);

  return (len);
}

/**
 * Write a len characters, pointed to by msg, to STDIN. The reason is used
 * as debug information should the write fail.
 */
void write_fixed(char *msg, int len, char *reason) {
  int written = 0;
  while(written < len) {
    int this_write = write(STDOUT_FILENO,  msg + written, len - written);
    if (this_write <= 0 && errno != EINTR) {
      err(EXIT_FAILURE, "%s: %d", reason, this_write);
    }
    written += this_write;
  }
}

/**
 * Send the zero-terminated msg back the BEAM by writing to stdout.
 */
void write_back(char *msg) {
  unsigned long len = strlen(msg);
  char size_header[2] = {(len >> 8 & 0xff), (len & 0xff)};
  write_fixed(size_header, 2, "header write");
  write_fixed(msg, len, "data write");
}

int read_cmd(byte *buf)
{
  int len;
  if (read_exact(buf, 2) != 2)
    return(-1);
  len = (buf[0] << 8) | buf[1];
  return read_exact(buf, len);
}

int write_cmd(byte *buf, int len)
{
  byte li;

  li = (len >> 8) & 0xff;
  write_exact(&li, 1);

  li = len & 0xff;
  write_exact(&li, 1);

  return write_exact(buf, len);
}

int input_available()
{
  struct timeval tv;
  fd_set fds;
  tv.tv_sec = 0;
  tv.tv_usec = 500;

  FD_ZERO(&fds);
  FD_SET(STDIN_FILENO, &fds);
  select(STDIN_FILENO+1, &fds, NULL, NULL, &tv);
  return (FD_ISSET(0, &fds));
}

void get_str_arg(byte *buf, char *arg, int bytes_read) {
  buf[bytes_read] = '\0';
  strcpy(arg, (char *) &buf[1]);
}

double get_double_from_string(byte *buf, int bytes_read) {
  char tmp[1024];
  get_str_arg(buf, tmp, bytes_read);
  return atof(tmp);
}


