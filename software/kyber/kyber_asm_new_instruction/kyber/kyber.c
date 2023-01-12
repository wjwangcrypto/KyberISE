#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "rng.h"
#include "api.h"
#include "hbird_sdk_soc.h"

#define	MAX_MARKER_LEN		50
#define KAT_SUCCESS          0
#define KAT_FILE_OPEN_ERROR -1
#define KAT_DATA_ERROR      -3
#define KAT_CRYPTO_FAILURE  -4

void	fprintBstr(char *S, unsigned char *A, unsigned long long L);

int
main(){
    unsigned char       seed[48];
    unsigned char       entropy_input[48];
    unsigned char       ct[CRYPTO_CIPHERTEXTBYTES], ss[CRYPTO_BYTES], ss1[CRYPTO_BYTES];
    int                 count;
    int                 done;
    unsigned char       pk[CRYPTO_PUBLICKEYBYTES], sk[CRYPTO_SECRETKEYBYTES];
    int                 ret_val;
    unsigned long long  i;
    unsigned int begin_kem_keypair, end_kem_keypair, count_kem_keypair;
    unsigned int begin_kem_enc, end_kem_enc, count_kem_enc;
    unsigned int begin_kem_dec, end_kem_dec, count_kem_dec;

    for (int i=0; i<48; i++)
        entropy_input[i] = i;
    randombytes_init(entropy_input, NULL, 256);
    randombytes(seed, 48);
    fprintBstr("seed = ", seed, 48);
    printf("# %s\n\n", CRYPTO_ALGNAME);

    randombytes_init(seed, NULL, 256);
    
    begin_kem_keypair = __get_rv_cycle();
    // Generate the public/private keypair
    ret_val = crypto_kem_keypair(pk, sk);
    end_kem_keypair = __get_rv_cycle();
    count_kem_keypair = end_kem_keypair - begin_kem_keypair;
    printf("COUNT_KEM_KEYPAIR = %d\n",count_kem_keypair);

    fprintBstr("pk = ", pk, CRYPTO_PUBLICKEYBYTES);
    fprintBstr("sk = ", sk, CRYPTO_SECRETKEYBYTES);
    
    begin_kem_enc = __get_rv_cycle();
    ret_val = crypto_kem_enc(ct, ss, pk);
    end_kem_enc = __get_rv_cycle();
    count_kem_enc = end_kem_enc - begin_kem_enc;
    printf("COUNT_KEM_ENC = %d\n",count_kem_enc);

    fprintBstr("ct = ", ct, CRYPTO_CIPHERTEXTBYTES);
    fprintBstr("ss = ", ss, CRYPTO_BYTES);
    
    begin_kem_dec = __get_rv_cycle();
    ret_val = crypto_kem_dec(ss1, ct, sk);
    end_kem_dec = __get_rv_cycle();
    count_kem_dec = end_kem_dec - begin_kem_dec;
    printf("COUNT_KEM_DEC = %d\n",count_kem_dec);

}

void fprintBstr(char *S, unsigned char *A, unsigned long long L)
{
	unsigned long long  i;
        
	printf("%s", S);

	for ( i=0; i<L; i++ )
		printf( "%02X", A[i]);

	if ( L == 0 )
		printf("00");

	printf("\n");
}
