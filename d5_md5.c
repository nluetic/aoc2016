/*
 * from http://stackoverflow.com/questions/7627723/how-to-create-a-md5-hash-of-a-string-in-c
 *
 * The functions are located in libcrypto.so, which is in Debian package libssl (libssl1.0.0),
 * headers in libssl-dev
 *
 * create a shared library for use with perl native call:
 * cc -L /usr/lib/x86_64-linux-gnu/ -fPIC -c d5_md5.c -lcrypto 
 * cc -shared -L /usr/lib/x86_64-linux-gnu/ d5_md5.o -lcrypto -o libd5_md5.so
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/md5.h>

unsigned char digest[16];
static MD5_CTX context;
static char md5string[33];

char *md5_get(char *to_hash) {
    MD5_Init(&context);
    MD5_Update(&context, to_hash, strlen(to_hash));
    MD5_Final(digest, &context);
    for(int i = 0; i < 16; ++i) 
        sprintf(&md5string[i*2], "%02x", (unsigned int)digest[i]);
    return md5string;
}

