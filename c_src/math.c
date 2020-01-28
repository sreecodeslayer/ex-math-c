// C++ program to illustrate some of the
// above mentioned functions

#include <math.h>
#include "erl_comm.h"
#include <stdio.h>
#include <string.h>

int bytes_read;
int serial_bytes_read;
int serial_fd = 0;
char serial_buf[5];
typedef unsigned char byte;

void reset_state() {
  bytes_read = 0;
  serial_bytes_read = 0;
  strcpy(serial_buf, "");
}

// Functions that maps : just for the sake of it [not really required]

double sine(double x){
  return sin(x);
}

double cosine(double x){
  return cos(x);
}

double tangent(double x){
  return tan(x);
}

double square_root(double x){
  return sqrt(x);
}

// The main logic function that maps stdin input to a particular fuction to get a result
void process_command(byte *buf, int bytes_read) {
  int fn = buf[0];
  double arg = get_double_from_string(buf, bytes_read);
  char answer[75];

  if(bytes_read > 0) {
    switch(fn) {
      case 1:
        sprintf(answer, "%e", sine(arg));
        break;
      case 2:
        sprintf(answer, "%e", cosine(arg));
        break;
      case 3:
        sprintf(answer, "%e", tangent(arg));
        break;
      case 4:
        sprintf(answer, "%e", square_root(arg));
        break;
      default:
        fprintf(stderr, "Not a valid fn %i\n", fn);
        break;
    }
  }
  else if(bytes_read <= 0) {
    exit(1);
  }
  // send this to Elixir
  write_back(answer);
}

// Poll stdin to prevent zombie process eating up CPU
// If there is no input or stdin is closed, we exit(1) gracefully

void poll_serial_data(int serial_fd) {
  serial_bytes_read = read(serial_fd, serial_buf, 5);

  if(serial_bytes_read > 0) {
    write_cmd( (byte*) serial_buf, 5);
  }
}

int main() {
  byte buf[100];
  char answer;

  while (1) {
    reset_state();

    if(input_available() > 0 ) {
      bytes_read = read_cmd(buf);
      process_command(buf, bytes_read);
    }

    if(serial_fd > 0) {
      poll_serial_data(serial_fd);
    }
  }
}

