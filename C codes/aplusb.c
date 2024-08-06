#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

FILE *a_fpr;
FILE *b_fpr;
FILE *y_fpr;

int main() {
    srand((unsigned int)time(NULL));
    
    a_fpr = fopen("a.mem", "w");
    b_fpr = fopen("b.mem", "w");
    y_fpr = fopen("y.mem", "w");
    float bound = 10000.0;//upper bound

    float a ;
    float b ;
    float y ;

    int a_hex ;
    int b_hex ;
    int y_hex ;
    
    for (int i = 0; i < 1000; i++)
    {
        a = ((float)rand()/(float)(RAND_MAX)) * bound;
        b = ((float)rand()/(float)(RAND_MAX)) * bound;
        y = a+b;

        a_hex = *(int*)(&a);
        b_hex = *(int*)(&b);
        y_hex = *(int*)(&y);
        
        //printf("0x%x \n",*(int*)(&sqrt_num));
        printf("%f = %f + %f\n",y,a,b);

        //file write
        fprintf(a_fpr, "%x\n", a_hex);
        fprintf(b_fpr, "%x\n", b_hex);
        fprintf(y_fpr, "%x\n", y_hex);
    }

    fclose(a_fpr);
    fclose(b_fpr);
    fclose(y_fpr);
    return 0;
}