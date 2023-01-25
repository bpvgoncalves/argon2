pass <- "myPassw0rd!"

test_that("Argon2_i password encoding works", {
  hash <- argon2_encode(pass, type="i", iterations=5, memory=2, threads=1)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, type="i", iterations=10, memory=4, threads=1)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, charToRaw("tinysalt"), type="i", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash2 <- argon2_encode(pass, "tinysalt", type="i", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash2, "argon2.encoded"))
  expect_true(argon2_verify(hash2, pass))
  expect_false(argon2_verify(hash2, "wrong_password"))
  expect_identical(hash, hash2)

  hash <- argon2_encode(pass, NULL, type="i", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, 8L, type="i", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

})

test_that("Argon2_d password encoding works", {
  hash <- argon2_encode(pass, type="d", iterations=5, memory=2, threads=1)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, type="d", iterations=10, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, charToRaw("tinysalt"), type="d", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash2 <- argon2_encode(pass, "tinysalt", type="d", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash2, "argon2.encoded"))
  expect_true(argon2_verify(hash2, pass))
  expect_false(argon2_verify(hash2, "wrong_password"))
  expect_identical(hash, hash2)

  hash <- argon2_encode(pass, NULL, type="d", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, 8L, type="d", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))
})

test_that("Argon2_id password encoding works", {
  hash <- argon2_encode(pass, type="id", iterations=5, memory=2, threads=1)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, type="id", iterations=10, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, charToRaw("tinysalt"), type="id", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash2 <- argon2_encode(pass, "tinysalt", type="id", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash2, "argon2.encoded"))
  expect_true(argon2_verify(hash2, pass))
  expect_false(argon2_verify(hash2, "wrong_password"))
  expect_identical(hash, hash2)

  hash <- argon2_encode(pass, NULL, type="id", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

  hash <- argon2_encode(pass, 8L, type="id", iterations=5, memory=4, threads=2)
  expect_true(inherits(hash, "argon2.encoded"))
  expect_true(argon2_verify(hash, pass))
  expect_false(argon2_verify(hash, "wrong_password"))

})

known_good <- c("Argon2 Encoded Hash:",
                "$argon2id$v=19$m=16384,t=2,p=4$c21hbGxzYWx0$VMLGGh5t7cTbShJgAJP4gw")
test_that("Printing works as intended.", {
  hash <- argon2_encode("password", "smallsalt", threads = 4, iterations = 2, memory = 16, len = 16)

  expect_identical(utils::capture.output(print(hash)), known_good)
  expect_identical(print(hash), print(hash$encoded_hash))


})

test_that("Wrong parameters' circuit breakers work", {
  expect_error(argon2_encode(pass, type="x", iterations=1, memory=1, threads=1))

  expect_error(argon2_encode(pass, type="i", iterations=-1, memory=8, threads=1))
  expect_error(argon2_encode(pass, type="i", iterations=2^32, memory=8, threads=1))
  expect_error(argon2_encode(pass, type="i", iterations=1, memory=-8, threads=1))
  expect_error(argon2_encode(pass, type="i", iterations=1, memory=2^32, threads=1))
  expect_error(argon2_encode(pass, type="i", iterations=1, memory=8, threads=-1))
  expect_error(argon2_encode(pass, type="i", iterations=1, memory=8, threads=2^25))

  expect_error(argon2_encode(1234, type="i", iterations=1, memory=8, threads=1))
  expect_error(argon2_encode("1234", 1234, type="i", iterations=1, memory=8, threads=1))
  expect_warning(argon2_encode(pass, 1234L, type="i", iterations=1, memory=8, threads=1))


})
