
test_that("'gen_nonce' produces output with the right length and type", {
  x = gen_nonce()
  expect_identical(length(x), 64L)
  expect_identical(typeof(x), "raw")

  x = gen_nonce(32)
  expect_identical(length(x), 32L)
  expect_identical(typeof(x), "raw")
})

test_that("'gen_nonce' produces expected output", {
  set.seed(1234)
  x = gen_nonce(8)
  expect_identical(as.character(x),
                   c("1d", "9f", "9b", "9f", "dc", "a3", "02", "3b"))
})
