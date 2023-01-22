testlen = 10
key = "itsasecrettoeverybody"
rawkey = charToRaw(key)

test_that("Empty string hashing with 'blake2b'", {
  str = ""

  truth = "786A02F742"
  hash= blake2b(str)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)

  truth = "4D571CE893"
  hash = blake2b(str, key=key)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)

  hash = blake2b(str, key=rawkey)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)
})

test_that("Character string hashing with 'blake2b'", {

  str = "The quick brown fox jumps over the lazy dog"

  truth = "A8ADD4BDDD"
  hash = blake2b(str)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)

  truth = "38F9A5A918"
  hash = blake2b(str, key=key)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)

  hash = blake2b(str, key=rawkey)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)
})

test_that("Raw vector hashing with 'blake2b'", {
  str = charToRaw("letters")

  truth = "CA121F037B"
  hash = blake2b(str)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)

  truth = "C61E3D64CF"
  hash = blake2b(str, key=key)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)

  hash = blake2b(str, key=rawkey)
  test = substr(raw_as_char(hash), 1, testlen)
  expect_identical(test, truth)
})

test_that("Hashing with arbitrary length output", {

  hash = blake2b("Hello", len=8)
  expect_identical(raw_as_char(hash, upper = FALSE),
                   "3c5c8a1fdb206886")

  hash = blake2b("Hello", len=16)
  expect_identical(raw_as_char(hash, upper = FALSE),
                   "ad10196e1159e75dd6be7d03f75be04f")

  hash = blake2b("Hello", key="key", len=32)
  expect_identical(raw_as_char(hash, upper = FALSE),
                   "e029c6d76a8512d336da1e80a123081f5cdd9fb5fb3f8123f8498a54b3504f0b")

  hash = blake2b("Hello", key=charToRaw("key"), len=48)
  expect_identical(raw_as_char(hash, upper = FALSE),
                   "b04b69e6542ee59a4cde6c832cf82de1b8a6db98abb8f0c91b58d9e7dd16353340dd1af4eb3a4b651666d9cd400956ca")

})

test_that("error thrown on wrong parameter type", {

  expect_error(blake2b(8888L, key=rawkey))
  expect_error(blake2b("abcd", key=123))
  expect_error(blake2b("abcd", key=raw(65)))
  expect_error(blake2b("abcd", len = "ten"))
  expect_error(blake2b("abcd", len = -1))
  expect_error(blake2b("abcd", len = 128))
  expect_error(blake2b("abcd", key=raw(49), len = 32))

})
