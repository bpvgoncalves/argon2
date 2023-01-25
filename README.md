# argon2

  <!-- badges: start -->
  [![R-CMD-check](https://github.com/bpvgoncalves/argon2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bpvgoncalves/argon2/actions/workflows/R-CMD-check.yaml)

  [![Codecov test coverage](https://codecov.io/gh/bpvgoncalves/argon2/branch/master/graph/badge.svg)](https://app.codecov.io/gh/bpvgoncalves/argon2?branch=master)
  <!-- badges: end -->


* **Version:** 0.7.0
* **License:** [BSD 2-Clause](https://opensource.org/licenses/BSD-2-Clause)
* **Project home**: https://github.com/wrathematics/argon2
* **Bug reports**: https://github.com/wrathematics/argon2/issues


**argon2** is an R package for secure password hashing via the argon2 algorithm. It is a relatively new hashing algorithm and is believed to be very secure. The package also includes some utilities that should be useful for digest authentication, including a wrapper of blake2b. For similar R packages, see **sodium** and **bcrypt**.

The package includes a source distribution of the latest implementation from the argon2 developers: https://github.com/P-H-C/phc-winner-argon2. Note that we are unaffiliated with their project; if we break something, don't blame them!



## Installation

You can install the stable version from CRAN using the usual `install.packages()`:

```r
install.packages("argon2")
```

The development version is maintained on GitHub:

```r
remotes::install_github("wrathematics/argon2")
```

If you build the package from source, you can enable CPU vectorization optimizations by using the configure flag `--enable-vec`. This improvement can not be made the default because of CRAN rules which I disagree with.



## Usage

```r
library(argon2)

pass <- "myPassw0rd!"

argon2_hash(pass, len=32)
Argon2 Raw Hash: AE93DFE62C15D439A575E602CFB58F98B820FA5837040812AEB66E5585972830

enc <- argon2_encode(pass, memory=16, len=32)
enc
Argon2 Encoded Hash:
$argon2id$v=19$m=16384,t=1,p=2$JfXhBolUipd6T8KY7s01xw$yXdjXxEgxIutkruaTvZQHtSl6qpyoEhIh87nspPhKyg

argon2_verify(enc, pass)
[1] TRUE

argon2_verify(enc, "password")
[1] FALSE

argon2_verify(enc, "1234")
[1] FALSE


```
