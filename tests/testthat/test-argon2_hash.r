pass <- "The quick brown fox jumps over the lazy dog."
nonce <- "saltsalty"

type <- "i"
known_good <- "d706659da3e9914ba1fa9da93da6a0d22c10a92b7a43c3e8695bde92cd58beb2"
test_that("Argon2_i password raw hash works", {
  hash <- argon2_hash(pass, type=type, iterations=5, memory=2, threads=2)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "raw")
  expect_true(typeof(hash$salt) == "raw")
  expect_identical(hash,
                   argon2_hash(pass, hash$salt, type=type, iterations=5, memory=2, threads=2))

  hash <- argon2_hash(pass, nonce, type=type, iterations=5, memory=2, threads=2, len = 32)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "raw")
  expect_true(typeof(hash$salt) == "raw")
  expect_equal(raw_as_char(hash$raw_hash), toupper(known_good))

  hash <- argon2_hash(pass, nonce, type=type, iterations=5, memory=2, threads=2, len = 32, as_raw = F)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "character")
  expect_true(typeof(hash$salt) == "character")
  expect_equal(as.character(hash$raw_hash), toupper(known_good))
})

type <- "d"
known_good <- "740037b8768f28697956da4fd6b2f7aa26bc3c316d5357a675656a6bf701c9a4"
test_that("Argon2_d password raw hash works", {
  hash <- argon2_hash(pass, type=type, iterations=5, memory=2, threads=2)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "raw")
  expect_true(typeof(hash$salt) == "raw")
  expect_identical(hash,
                   argon2_hash(pass, hash$salt, type=type, iterations=5, memory=2, threads=2))

  hash <- argon2_hash(pass, nonce, type=type, iterations=5, memory=2, threads=2, len = 32)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "raw")
  expect_true(typeof(hash$salt) == "raw")
  expect_equal(raw_as_char(hash$raw_hash), toupper(known_good))

  hash <- argon2_hash(pass, nonce, type=type, iterations=5, memory=2, threads=2, len = 32, as_raw = F)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "character")
  expect_true(typeof(hash$salt) == "character")
  expect_equal(as.character(hash$raw_hash), toupper(known_good))
})

type <- "id"
known_good <- "1ccca784c1aff03bbfe44c4427176b991e00ea9b73571f017ef0a2ce22e69d84"
test_that("Argon2_id password raw hash works", {
  hash <- argon2_hash(pass, type=type, iterations=5, memory=2, threads=2)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "raw")
  expect_true(typeof(hash$salt) == "raw")
  expect_identical(hash,
                   argon2_hash(pass, hash$salt, type=type, iterations=5, memory=2, threads=2))

  hash <- argon2_hash(pass, nonce, type=type, iterations=5, memory=2, threads=2, len = 32)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "raw")
  expect_true(typeof(hash$salt) == "raw")
  expect_equal(raw_as_char(hash$raw_hash), toupper(known_good))

  hash <- argon2_hash(pass, nonce, type=type, iterations=5, memory=2, threads=2, len = 32, as_raw = F)
  expect_true(class(hash) == "argon2.raw")
  expect_true(class(hash$raw_hash) == "argon2.raw.hash")
  expect_true(class(hash$salt) == "argon2.raw.salt")
  expect_true(typeof(hash$raw_hash) == "character")
  expect_true(typeof(hash$salt) == "character")
  expect_equal(as.character(hash$raw_hash), toupper(known_good))
})

known_good <- "Argon2 Raw Hash: BB0B90B8A65A72C50815FD2DFE984DB2"
test_that("Printing works as intended.", {
  hash <- argon2_hash(pass, nonce, type="id", iterations=2, memory=32, threads=4, len=16)

  expect_identical(utils::capture.output(print(hash)), known_good)
  expect_identical(print(hash), print(hash$raw_hash))

  hash <- argon2_hash(pass, nonce, type="id", iterations=2, memory=32, threads=4, len=16, as_raw = F)
  expect_identical(utils::capture.output(print(hash)), known_good)
  expect_identical(print(hash), print(hash$raw_hash))
})

test_that("Wrong parameters' circuit breakers work", {

  expect_error(argon2_hash(pass, type="x", iterations=1, memory=1, threads=1))

  expect_error(argon2_hash(pass, type="i", iterations=-1, memory=8, threads=1))
  expect_error(argon2_hash(pass, type="i", iterations=2^32, memory=8, threads=1))
  expect_error(argon2_hash(pass, type="i", iterations=1, memory=-8, threads=1))
  expect_error(argon2_hash(pass, type="i", iterations=1, memory=2^32, threads=1))
  expect_error(argon2_hash(pass, type="i", iterations=1, memory=8, threads=-1))
  expect_error(argon2_hash(pass, type="i", iterations=1, memory=8, threads=2^25))

  expect_error(argon2_hash(1234, type="i", iterations=1, memory=8, threads=1))
  expect_error(argon2_hash(pass, 1234, type="i", iterations=1, memory=8, threads=1))

})
