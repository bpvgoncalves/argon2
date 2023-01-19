pass = "myPassw0rd!"

test_that("Argon2_i password encoding works", {
  hash = pw_hash(pass, variant="i", iterations=5, memory=2, nthreads=1)
  expect_true(attr(hash, "hashtype") == "argon2")
  expect_true(pw_check(hash, pass))
  expect_false(pw_check(hash, "wrong_password"))

  hash = pw_hash(pass, variant="i", iterations=10, memory=4, nthreads=1)
  expect_true(attr(hash, "hashtype") == "argon2")
  expect_true(pw_check(hash, pass))
  expect_false(pw_check(hash, "wrong_password"))
})

test_that("Argon2_d password encoding works", {
  hash = pw_hash(pass, variant="d", iterations=5, memory=2, nthreads=1)
  expect_true(attr(hash, "hashtype") == "argon2")
  expect_true(pw_check(hash, pass))
  expect_false(pw_check(hash, "wrong_password"))

  hash = pw_hash(pass, variant="d", iterations=10, memory=4, nthreads=1)
  expect_true(attr(hash, "hashtype") == "argon2")
  expect_true(pw_check(hash, pass))
  expect_false(pw_check(hash, "wrong_password"))
})

test_that("Argon2_id password encoding works", {
  hash = pw_hash(pass, variant="id", iterations=5, memory=2, nthreads=1)
  expect_true(attr(hash, "hashtype") == "argon2")
  expect_true(pw_check(hash, pass))
  expect_false(pw_check(hash, "wrong_password"))

  hash = pw_hash(pass, variant="id", iterations=10, memory=4, nthreads=1)
  expect_true(attr(hash, "hashtype") == "argon2")
  expect_true(pw_check(hash, pass))
  expect_false(pw_check(hash, "wrong_password"))
})
