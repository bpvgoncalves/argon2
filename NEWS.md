# **argon2**
Secure Password Hashing

-----------------------

### **dev**
#### Bug fixes
* Fixed bug on parameter validation for `blake2b` hashing.

#### Miscellaneous
* Added github actions for testing code coverage and auto package checking.
* Added new test cases: 100% of the R code (and 75% overall) is executed during the tests. 


### **0.5.0**
#### New features
* Added 'Argon2_id' variant support.


### **0.4-0**
#### New features
* Update argon2 internals to release 20190702.


### **0.3-0**
#### New features
* Expose argon2 secondary inputs to users. 
* Changed argument "type" to "variant" in pw_hash().

#### Bug fixes
* Fixed a bad error message.


### **0.2-0**
#### Breaking changes
* Renamed raw_to_char() to raw_as_char().

#### Bug fixes
* Fixed several memory errors flagged by Valgrind. 

#### Miscellaneous
* Added Wikipedia link to `DESCRIPTION`. 


### **0.1-0**
#### New features
* Added pw_hash() and pw_check() 
* Added blake2b() 
* Added raw_to_char() 
* Added gen_nonce()
