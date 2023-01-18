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
