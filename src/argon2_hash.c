/*  Copyright (c) 2016-2017 Drew Schmidt
    Copyright (c) 2023 Bruno Gonçalves
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


#include "argon2/argon2.h"
#include "common.h"

void secure_wipe_memory(void *v, size_t n);

SEXP R_argon2_hasher(SEXP pass_, SEXP nonce_, SEXP type, SEXP iterations,
                     SEXP space, SEXP nthreads, SEXP len)

{
  SEXP ret;
  int check = -99; // Initialized to 'unknown error'
  const char *pass = CHARPT(pass_, 0);
  const int passlen = strlen(pass);

  const int saltlen = length(nonce_);
  uint8_t salt[saltlen];
  for (size_t i=0; i<saltlen; i++)
    salt[i] = RAW(nonce_)[i];

  size_t hashlen = INT(len);
  uint8_t hash[hashlen];

  size_t t = INT(type);
  switch(t)
  {
    case 0:
      check = argon2d_hash_raw(INT(iterations), INT(space), INT(nthreads),
                               pass, passlen, salt, saltlen, hash, hashlen);
      break;

    case 1:
      check = argon2i_hash_raw(INT(iterations), INT(space), INT(nthreads),
                               pass, passlen, salt, saltlen, hash, hashlen);
      break;

    case 2:
      check = argon2id_hash_raw(INT(iterations), INT(space), INT(nthreads),
                                pass, passlen, salt, saltlen, hash, hashlen);
      break;
  }

  if (check != ARGON2_OK) error("%s\n", argon2_error_message(check));

  PROTECT(ret = allocVector(RAWSXP, hashlen));
  for (size_t i=0; i<hashlen; i++)
    SET_RAW_ELT(ret, i, hash[i]);

  secure_wipe_memory(salt, saltlen*sizeof(*salt));
  secure_wipe_memory(hash, hashlen*sizeof(*hash));

  UNPROTECT(1);
  return ret;
}
