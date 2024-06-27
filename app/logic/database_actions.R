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




# tidyr::pivot_longer(test, tidyselect::everything())
