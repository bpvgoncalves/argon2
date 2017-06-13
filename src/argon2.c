/*  Copyright (c) 2016-2017 Drew Schmidt
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    
    2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
    TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
    PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
    CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
    EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
    LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
    NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


#include "common.h"
#include "argon2/argon2.h"

#define CHECKRET(check) if (check != ARGON2_OK) error("%s\n", argon2_error_message(check))

#define ENTROPY 64 // 64, 128, 256...
#define SALTLEN ENTROPY
#define HASHLEN ENTROPY
#define ENCOLEN ENTROPY*4

uint8_t salt[SALTLEN];
uint8_t hash[HASHLEN];
char    enco[ENCOLEN];

#define VERSION  ARGON2_VERSION_13


static inline void clearmem()
{
  for (int i=0; i<SALTLEN; i++)
    salt[i] = 0;
  
  for (int i=0; i<HASHLEN; i++)
    hash[i] = 0;
  
  for (int i=0; i<ENCOLEN; i++)
    enco[i] = '\0';
}

static inline int chartype2inttype(const char ctype)
{
  int itype;
  
  switch (ctype)
  {
    case 'i':
      itype = Argon2_i;
      break;
    case 'd':
      itype = Argon2_d;
      break;
    default:
      error(ERR_IMPOSSIBLE);
  }
  
  return itype;
}



SEXP R_argon2_hash(SEXP pass_, SEXP type_, SEXP iterations, SEXP space, SEXP nthreads)
{
  SEXP ret;
  int check;
  const char *pass = CHARPT(pass_, 0);
  const int passlen = strlen(pass);
  const int type = chartype2inttype(CHARPT(type_, 0)[0]);
  
  random_uchars(salt, SALTLEN);
  
  check = argon2_hash(INT(iterations), INT(space), INT(nthreads), pass, passlen,
    salt, SALTLEN, hash, HASHLEN, enco, ENCOLEN, type, VERSION);
  
  CHECKRET(check);
  
  PROTECT(ret = allocVector(STRSXP, 1));
  SET_STRING_ELT(ret, 0, mkChar(enco));
  
  clearmem();
  
  UNPROTECT(1);
  return ret;
}



SEXP R_argon2_verify(SEXP hash_, SEXP pass_)
{
  int check;
  const char *hash = CHARPT(hash_, 0);
  const char *pass = CHARPT(pass_, 0);
  
  const char ctype = hash[7];
  if (strncmp(hash, "$argon2", 7) != 0 || (ctype!='d' && ctype!='i'))
    error("invalid argon2 hash");
  
  const int type = chartype2inttype(ctype);
  
  check = argon2_verify(hash, pass, strlen(pass), type);
  
  return ScalarLogical(check == ARGON2_OK);
}
