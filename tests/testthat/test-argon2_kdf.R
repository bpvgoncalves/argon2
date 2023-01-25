

test_that("Argon2_kdf works", {
  pass <- "The quick brown fox jumps over the lazy dog."
  key <- argon2_kdf(pass)
  expect_true(class(key) == "argon2.kdf")
  expect_true(class(key$key) == "argon2.kdf.key")
  expect_true(typeof(key$key) == "raw")
  expect_equal(length(key$key), 128)
  expect_true(class(key$salt) == "argon2.kdf.salt")
  expect_true(typeof(key$salt) == "raw")
  expect_equal(length(key$salt), 32)
  expect_identical(key,
                   argon2_kdf(pass, key$salt))

  known_good <- paste0("Argon2 Key: ", paste0(rep("*", 16), collapse = ""))
  expect_identical(utils::capture.output(print(key)), known_good)
  expect_identical(print(key), print(key$key))

})
