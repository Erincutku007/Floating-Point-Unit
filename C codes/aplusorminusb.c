#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

FILE *a_fpr;
FILE *b_fpr;
FILE *y_fpr;
FILE *op_fpr;

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
    op_fpr = fopen("op.mem", "w");
    float bound = 10000.0;//upper bound

    float a ;
    float b ;
    float y ;

    int a_hex ;
    int b_hex ;
    int y_hex ;

    int rand_a;
    int rand_b;
    int op ;
    char operation;

    for (int i = 0; i < 100000; i++)
    {
        a = ((float)rand()/(float)(RAND_MAX)) * bound;
        b = ((float)rand()/(float)(RAND_MAX)) * bound;

        rand_a = rand() & 1;
        rand_b = rand() & 1;
        op = rand() & 1;

        a = sign_flip(rand_a,a);
        b = sign_flip(rand_b,b);

        if (op) {
            y = a-b;
            operation = '-';
        }
        else {
            y = a+b;
            operation = '+';
        }

        a_hex = *(int*)(&a);
        b_hex = *(int*)(&b);
        y_hex = *(int*)(&y);
        
        //printf("0x%x \n",*(int*)(&sqrt_num));
        if (i%10){
            printf("%f = %f %c %f\n",y,a,operation,b);
        }

        //file write
        fprintf(a_fpr, "%x\n", a_hex);
        fprintf(b_fpr, "%x\n", b_hex);
        fprintf(y_fpr, "%x\n", y_hex);
        fprintf(op_fpr, "%d\n", op);
    }

    fclose(a_fpr);
    fclose(b_fpr);
    fclose(y_fpr);
    return 0;
}