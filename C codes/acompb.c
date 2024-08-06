#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

FILE *a_fpr;
FILE *b_fpr;
FILE *y_fpr;

float sign_flip(int mode, float a){
    if (mode){
        return -a;
    }
    else{
        return a;
    }
    
}

int main() {
    srand((unsigned int)time(NULL));
    
    a_fpr = fopen("a.mem", "w");
    b_fpr = fopen("b.mem", "w");
    y_fpr = fopen("y.mem", "w");
    float bound = 10000.0;//upper bound

    float a ;
    float b ;
    int y ;

    int a_hex ;
    int b_hex ;
    int y_hex ;

    int rand_a;
    int rand_b;
    int eq_rand;

    for (int i = 0; i < 100; i++)
    {
        a = ((float)rand()/(float)(RAND_MAX)) * bound;
        b = ((float)rand()/(float)(RAND_MAX)) * bound;

        rand_a = rand() & 1;
        rand_b = rand() & 1;
        eq_rand = rand() & 1;

        a = sign_flip(rand_a,a);
        b = sign_flip(rand_b,b);

        if (eq_rand)
        {
            b=a;
        }
        
        y = ((a==b)<<1) | (a > b);

        a_hex = *(int*)(&a);
        b_hex = *(int*)(&b);
        
        //printf("0x%x \n",*(int*)(&sqrt_num));
        if (1){
            printf("%d = %f > %f\n",y,a,b);
        }

        //file write
        fprintf(a_fpr, "%x\n", a_hex);
        fprintf(b_fpr, "%x\n", b_hex);
        fprintf(y_fpr, "%x\n", y);
    }

    fclose(a_fpr);
    fclose(b_fpr);
    fclose(y_fpr);
    return 0;
}