box::use(
  DBI,
  RSQLite,
  here[here],
)

#need to make this more generic as I develop

#' @export
retrieve_patients  <- function() {
  con  <- DBI$dbConnect(
    RSQLite$SQLite(),
    here("app", "synthea.sqlite")
  )
  patients  <- DBI$dbGetQuery(con, "SELECT * FROM patients")
  DBI$dbDisconnect(con)
  return(patients)
}

