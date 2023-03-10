#include <stdio.h>
#include <stdint.h>
#include "params.h"
#include "ntt.h"

int16_t roots[120] = {
	2285,1493,2970,287,2571,1422,1812,202,2285,2970,2571,1812,2285,2571,2285,1223,2036,2777,3047,652,1491,1015,1785,573,264,2004,383,3158,622,1493,573,2500,264,1727,2004,1458,383,3199,3158,1577,622,182,1493,1422,2970,2476,107,3058,3082,3239,1908,830,2378,2648,732,1017,608,962,2127,287,3158,962,1577,1855,622,2127,182,1468,1493,287,1422,202,2970,1812,2571,516,1711,3009,126,3321,2167,2663,1469,2500,1727,1458,3199,1577,182,1422,2648,1787,732,3124,1017,411,608,1758,962,1855,2127,1468,287,202,1812,2931,448,1821,677,961,2264,2604,2054,1787,3124,411,1758,1855,1468,202
	};

int16_t inv_roots[127] ={
	1571,1275,2652,1701,1807,1460,2371,205,1065,2881,2338,2333,308,108,2918,725,1508,2851,870,854,1510,1542,2368,398,2535,1278,1530,1185,2721,951,247,1659,1187,3109,874,2597,1421,3222,1335,2111,136,1215,2312,2499,271,2945,1465,1285,2007,681,90,853,2719,2726,2232,2512,130,1860,3203,75,156,3000,2911,1602,1162,1618,2980,872,2685,1590,1871,666,320,2210,602,1846,777,829,8,2813,147,2170,2551,246,2946,1544,282,1676,1755,460,291,3065,1838,1293,235,3152,2742,2907,1325,2314,552,3224,1779,2458,1251,2756,2677,2106,2486,2774,2899,1103,758,1517,359,3127,3042,1907,1836,1861,1474,1202,2367,3147,1752,2707,171
};

int16_t pairmul_roots[128] = {
	2226,1103,430,2899,555,2774,843,2486,2078,1251,871,2458,1550,1779,105,3224,422,2907,587,2742,177,3152,3094,235,3038,291,2869,460,1574,1755,1653,1676,3083,246,778,2551,1159,2170,3182,147,2552,777,1483,1846,2727,602,1119,2210,1739,1590,644,2685,2457,872,349,2980,418,2911,329,3000,3173,156,3254,75,817,2512,1097,2232,603,2726,610,2719,1322,2007,2044,1285,1864,1465,384,2945,2114,1215,3193,136,1218,2111,1994,1335,2455,874,220,3109,2142,1187,1670,1659,2144,1185,1799,1530,2051,1278,794,2535,1819,1510,2475,854,2459,870,478,2851,3221,108,3021,308,996,2333,991,2338,958,2371,1869,1460,1522,1807,1628,1701
};


int16_t tmp1[256]={};
int16_t tmp2[256]={};

int16_t twist[128] ={2285,2226,1223,817,573,3083,2476,2144,3158,422,516,2114,2648,1739,2931,3221,1493,2078,2036,1322,2500,2552,107,1819,962,3038,1711,2455,1787,418,448,958,2970,555,2777,603,264,1159,3058,2051,1577,177,3009,1218,732,2457,1821,996,287,1550,3047,1864,1727,2727,3082,2459,1855,1574,126,2142,3124,3173,677,1522,2571,430,652,1097,2004,778,3239,1799,622,587,3321,3193,1017,644,961,3021,1422,871,1491,2044,1458,1483,1908,2475,2127,2869,2167,220,411,329,2264,1869,1812,843,1015,610,383,3182,830,794,182,3094,2663,1994,608,349,2604,991,202,105,1785,384,3199,1119,2378,478,1468,1653,1469,1670,1758,3254,2054,1628};


/*************************************************
* Name:        ntt
*
* Description: Inplace number-theoretic transform (NTT) in Rq
*              input is in standard order, output is in bitreversed order
*
* Arguments:   - int16_t r[256]: pointer to input/output vector of elements
*                                of Zq
**************************************************/
/*
void ntt(int16_t r[256]){
        NTT_forward_1234(r, root_table_Rfield_1234, OP1, Prime, BarrettV);
    	NTT_forward_5678(r, root_table_Rfield_5678, OP1, Prime, BarrettV);
}
*/

void ntt(int16_t r[256]){
	NTT_pre(r, twist);
	NTT_forward(r, roots, tmp1);
}

/*************************************************
* Name:        invntt_tomont
*
* Description: Inplace inverse number-theoretic transform in Rq and
*              multiplication by Montgomery factor 2^16.
*              Input is in bitreversed order, output is in standard order
*
* Arguments:   - int16_t r[256]: pointer to input/output vector of elements
*                                of Zq
**************************************************/
/*
void invntt_tomont(int16_t r[256]){
            NTT_backward_8765(r, root_table_forInverse_Rfield_8765, OP1, Prime, BarrettV);
	    NTT_backward_4321(r, root_table_forInverse_Rfield_4321, OP1, Prime, BarrettV);
	    MultiplyLenN_inv(r,  Prime, OP1, BarrettV, INV2);	
}
*/

void invntt(int16_t r[256]){
	NTT_backward(r, inv_roots, tmp2);
}

/*************************************************
* Name:        basemul
*
* Description: Multiplication of polynomials in Zq[X]/(X^2-zeta)
*              used for multiplication of elements in Rq in NTT domain
*
* Arguments:   - int16_t r[2]:       pointer to the output polynomial
*              - const int16_t a[2]: pointer to the first factor
*              - const int16_t b[2]: pointer to the second factor
*              - int16_t zeta:       integer defining the reduction polynomial
**************************************************/
/*
void basemul(int16_t r[256],int16_t a[256],int16_t b[256]){
        POLYMUL(a, b, root_pairmul_7_4Kred, r, Prime, BarrettV);
}
*/

void basemul(int16_t r[256],int16_t a[256],int16_t b[256]){
        BaseMul(a, b, pairmul_roots, r);
}

void basemul_add(int16_t r[256],int16_t a[256],int16_t b[256]){
        BaseMulAdd(a, b, pairmul_roots, r);
}