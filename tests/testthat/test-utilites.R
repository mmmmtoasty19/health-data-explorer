box::use(
  testthat[expect_equal, test_that],
  DBI,
  RSQLite,
  here[here],
)

box::use(
  app/logic/utilites[create_patient_list],
)


test_that("Test that creating patient list generates correct length", {
  con <- con  <- DBI$dbConnect(
    RSQLite$SQLite(),
    here("app", "synthea.sqlite")
  )
  row_count <- nrow(DBI$dbGetQuery(con, "SELECT * FROM patients"))
  DBI$dbDisconnect(con)
  expect_equal(length(create_patient_list()), row_count)
})
