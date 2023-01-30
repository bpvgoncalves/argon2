hex_string_1a <- "029a6d228fff880096"
hex_string_1b <- "02 9a 6d 22 8f ff 88 00 96"
hex_string_2a <- "029A6D228FFF880096"
hex_string_2b <- "02 9A 6D 22 8F FF 88 00 96"
known_good <- as.raw(c(2, 154, 109, 34, 143, 255, 136, 0, 150))

test_that("char_as_raw correctly parses hex string as raw vector", {

  r_1a <- char_as_raw(hex_string_1a)
  expect_true(is.raw(r_1a))
  expect_equal(length(r_1a), 9)
  expect_identical(r_1a, known_good)

  r_1b <- char_as_raw(hex_string_1b)
  expect_true(is.raw(r_1b))
  expect_equal(length(r_1b), 9)
  expect_identical(r_1b, known_good)

  r_2a <- char_as_raw(hex_string_2a)
  expect_true(is.raw(r_2a))
  expect_equal(length(r_2a), 9)
  expect_identical(r_2a, known_good)

  r_2b <- char_as_raw(hex_string_2b)
  expect_true(is.raw(r_2b))
  expect_equal(length(r_2b), 9)
  expect_identical(r_2b, known_good)
})

test_that ("parameters checking", {

  expect_error(char_as_raw(123456))
  expect_error(char_as_raw(NULL))

  expect_error(char_as_raw("029a6d228fff880096a"))

  expect_error(char_as_raw("029a6d228fgg880096"))
})
