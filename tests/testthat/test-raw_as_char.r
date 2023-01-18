
x = charToRaw("asdfZ")
truth = utils::capture.output(print(x))
truth = substr(truth, 5, nchar(truth))

test_that("'raw_as_char' produces the right output when spaces are expected", {

  test = raw_as_char(x, upper=FALSE, spaces=TRUE)
  expect_identical(test, truth)

  test = raw_as_char(x, upper=TRUE, spaces=TRUE)
  expect_identical(test, toupper(truth))
})

test_that("'raw_as_char' produces the right output when spaces are not expected", {

  truth = paste0(unlist(strsplit(truth, split=" ")), collapse="")
  test = raw_as_char(x, upper=FALSE, spaces=FALSE)
  expect_identical(test, truth)

  test = raw_as_char(x, upper=TRUE, spaces=FALSE)
  expect_identical(test, toupper(truth))
})
