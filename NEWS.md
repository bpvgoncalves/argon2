# argon2 (development version)
#### New features
* Added `char_as_raw` to convert a string of hexadecimal encoded values to raw.

#### Bug fixes
* A string of hex encoded bytes can now correctly be used as nonce on `argon2_hash` and 
`argon2_encode`.


# argon2 0.7.1
#### Miscellaneous
* Trying to fix compilation issues in Windows.


# argon2 0.7.0
#### New features
* Added `argon2_kdf` for secure key derivation form a password.
* Changed 'nonce' argument on `argon2_hash` and `argon2_encode` to allow for different input types.


# argon2 0.6.0
#### New features
* Changed `blake2b` hash function to allow variable length output.
* Added `argon2_hash` function to compute raw hashes for a given plaintext/password. This function 
accepts all the customization parameters used by the Reference Implementation in C.
* Added `argon2_encode` and `argon2_verify` functions to compute encoded hashes for a given 
plaintext/password. The encoding function accepts all the customization parameters used by the 
Reference Implementation in C.

#### Miscellaneous
* Function `raw_as_char`now implemented in R instead of C.


# argon2 0.5.1
#### Bug fixes
* Fixed bug on parameter validation for `blake2b` hashing.

#### Miscellaneous
* Added github actions for testing code coverage and auto package checking.
* Added new test cases: 100% of the R code (and 75% overall) is executed during the tests. 


# argon2 0.5.0
#### New features
* Added 'Argon2_id' variant support.


# argon2 0.4-0
#### New features
* Update argon2 internals to release 20190702.


# argon2 0.3-0
#### New features
* Expose argon2 secondary inputs to users. 
* Changed argument "type" to "variant" in pw_hash().

#### Bug fixes
* Fixed a bad error message.


# argon2 0.2-0
#### Breaking changes
* Renamed raw_to_char() to raw_as_char().

#### Bug fixes
* Fixed several memory errors flagged by Valgrind. 

#### Miscellaneous
* Added Wikipedia link to `DESCRIPTION`. 


# argon2 0.1-0
#### New features
* Added pw_hash() and pw_check() 
* Added blake2b() 
* Added raw_to_char() 
* Added gen_nonce()
