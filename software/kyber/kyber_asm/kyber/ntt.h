#include <stdio.h>
#include <stdint.h>


#define L 3
#define LL 9

#define R 4294967296
#define Prime 3329
#define Prime_inv_neg 1806234369
/*
extern void NTT_forward_1234(int32_t * , int32_t * , int32_t, int32_t, int32_t);
extern void NTT_forward_5678(int32_t * , int32_t * , int32_t, int32_t, int32_t);
extern void NTT_backward_8765(int32_t * , int32_t * , int32_t, int32_t, int32_t);
extern void NTT_backward_4321(int32_t * , int32_t * , int32_t, int32_t, int32_t);
extern void MultiplyLenN_inv(int32_t* , int32_t , int32_t , int32_t, int32_t);
extern void POLYMUL(int32_t * , int32_t * , int32_t, int32_t *, int32_t, int32_t);


void ntt(int32_t r[256]);
void invntt_tomont(int32_t r[256]);
void basemul(int32_t r[256],int32_t a[256],int32_t b[256]);
*/

/**********************************************************************************/
extern void BaseMul(int16_t *, int16_t *, int16_t * , int16_t * );
extern void NTT_forward(int16_t *, int16_t * );
extern void NTT_backward(int16_t *, int16_t * );
//extern void NTT_forward(int16_t *, int16_t * );
//extern void NTT_backward(int16_t *, int16_t * );


void ntt(int16_t r[256]);
void invntt_tomont(int16_t r[256]);
void basemul(int16_t r[256],int16_t a[256],int16_t b[256]);
