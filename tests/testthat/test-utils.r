test_that("check.is.string.or.null ", {
  expect_true(check.is.string.or.null("aaa"))
  expect_true(check.is.string.or.null(NULL))
  expect_error(check.is.string.or.null(1234))
  expect_error(check.is.string.or.null(NA))
})
