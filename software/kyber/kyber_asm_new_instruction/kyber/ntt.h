#ifndef NTT_H
#define NTT_H

#include <stdint.h>
#include "params.h"

extern void NTT_forward(int16_t *, int16_t *, int16_t *);
extern void NTT_backward(int16_t *, int16_t *, int16_t *);
extern void BaseMul(int16_t *, int16_t *, int16_t *, int16_t *);
extern void BaseMulAdd(int16_t *, int16_t *, int16_t *, int16_t *);
extern void NTT_pre(int16_t *, int16_t *);



void ntt(int16_t r[256]);
void invntt_tomont(int16_t r[256]);
void basemul(int16_t r[256],int16_t a[256],int16_t b[256]);
void basemul_add(int16_t r[256],int16_t a[256],int16_t b[256]);

#endif
