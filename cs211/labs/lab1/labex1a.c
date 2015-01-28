#include <stdio.h>

void funct1 (int p1, int *p2);

int main()
{
    int x = 5;
    int *y;

    printf ("Hello World\n");
    
    y = &x;

    printf ("Print line 1: %d\n", x);
    printf ("Print line 2: %d\n", &x);
    printf ("Print line 3: %d\n", y);
    printf ("Print line 4: %d\n", &y);
    printf ("Print line 5: %d\n", *y);
    //printf ("Print line 6: %d\n", *x);

    /* printf ("Print line 6: %d\n", *x); */

    int a = 2;
    int b = 4;
    printf ("Print line 11: For variable a: value: %d, address:  %d\n", a, &a);
    printf ("Print line 12: For variable b: value: %d, address:  %d\n", b, &b);
    funct1 (a, &b);
    printf ("Print line 13: For variable a: value: %d, address:  %d\n", a, &a);
    printf ("Print line 14: For variable b: value: %d, address:  %d\n", b, &b);


}


void funct1 (int p1, int *p2)
{
   printf ("Print line 101: %d\n", p1);
   printf ("Print line 102: %d\n", &p1);
   printf ("Print line 103: %d\n", p2);
   printf ("Print line 104: %d\n", &p2);
   printf ("Print line 105: %d\n", *p2);

   p1 = p1 + 5;
   *p2 = *p2 + 5;
}

