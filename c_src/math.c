// C++ program to illustrate some of the
// above mentioned functions

#include <math.h>
#include "erl_comm.h"
#include <stdio.h>


typedef unsigned char byte;

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


int main() {
  // http://erlang.org/doc/tutorial/c_port.html#c-program
  int fn, arg;
  double res;
  byte buf[100];

  while (read_cmd(buf) > 0) {
    fn = buf[0];
    arg = buf[1];

    printf("fn: %d arg: %d\n", fn, arg);

    switch(fn) {
      case 1:
        res = sine(arg);
        break;
      case 2:
        res = cosine(arg);
        break;
      case 3:
        res = tangent(arg);
        break;
      case 4:
        res = square_root(arg);
        break;
      default:
        break;
    }

    printf("%f\n", res);

    buf[0] = res;
    write_cmd(buf, 1);
  }
}

