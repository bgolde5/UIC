#include <stdio.h>
#include <stdlib.h>

void print(void *p) {
  size_t *mem = (size_t *)p;
  mem -= 1;
  size_t val = *mem;

  printf("The actual value: %lu\n", val);
  printf("Masked value with ~15: %lu\n", (val & ~15) );
}

int main(int argc, char **argv) {
  char *p = (char *)malloc(100);

  printf("Sizeof size_t %lu\n", sizeof(size_t));
  printf("The starting address of p is %lu\n", p);
  print(p);

  char *p1 = (char *)malloc(200);
  printf("The starting address of p1 is %lu\n", p1);
  print(p1);



  return 0;
}
