test_that("check.is.string.or.null ", {
  expect_true(check.is.string.or.null("aaa"))
  expect_true(check.is.string.or.null(NULL))
  expect_error(check.is.string.or.null(1234))
  expect_error(check.is.string.or.null(NA))
})

test_that("is.hex", {
  expect_true(is.hex("00010203FCFDFEFF"))
  expect_true(is.hex("00 01 02 03 FC FD FE FF"))

  expect_false(is.hex("00010203FCFDFEFF0"))
  expect_false(is.hex("00 01 02 03 FC FD FE FF 0"))
  expect_false(is.hex("00010203FCFDFEFG"))
  expect_false(is.hex(TRUE))
  expect_false(is.hex(FALSE))
  expect_false(is.hex(1234))
  expect_false(is.hex(NULL))
  expect_false(is.hex(NA))
})
