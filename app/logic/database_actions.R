box::use(
  DBI,
  RSQLite,
  here[here],
  glue[glue_sql],
)

#' @export
retrieve_data <- function(columns, table) {
  con  <- DBI$dbConnect(
    RSQLite$SQLite(),
    here("app", "synthea.sqlite")
  )
  query <- glue_sql("SELECT {`columns`*} FROM {`table`}", columns = columns, .con = con )
  data <- DBI$dbGetQuery(con, query)
  DBI$dbDisconnect(con)
  return(data)
}


#' @export
get_patient_data  <- function(columns, table, ID) {
  con  <- DBI$dbConnect(
    RSQLite$SQLite(),
    here("app", "synthea.sqlite")
  )
  if (is.list(columns)) {
    query <- glue_sql("SELECT {`columns`*} FROM {`table`} WHERE Id = {ID}", .con = con)
  } else {
    query <- glue_sql("SELECT * FROM {`table`} WHERE Id = {ID}", .con = con)
  }

  data <- DBI$dbGetQuery(con, query)
  DBI$dbDisconnect(con)
  return(data)
}


# ID  <- "1c60a5da-1843-1978-d31a-ee5c060a43d2"
# columns  <- list("FIRST", "LAST")
# table  <- "patients"

# test  <- get_patient_data(columns, table, ID)

# tidyr::pivot_longer(test, tidyselect::everything())
