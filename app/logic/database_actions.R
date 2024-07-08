box::use(
  DBI,
  RSQLite,
  here[here],
  glue[glue_sql],
)

# should make function to open and close DB

#' @export
retrieve_data <- function(columns, table) {
  con  <- DBI$dbConnect(
    RSQLite$SQLite(),
    here("app", "synthea.sqlite")
  )
  query <- glue_sql("SELECT {`columns`*} FROM {`table`}", columns = columns, .con = con)
  data <- DBI$dbGetQuery(con, query)
  DBI$dbDisconnect(con)
  return(data)
}


#' @export
get_patient_data  <- function(columns, table, id) {
  con  <- DBI$dbConnect(
    RSQLite$SQLite(),
    here("app", "synthea.sqlite")
  )
  query <- glue_sql("SELECT {`columns`*} FROM {`table`} WHERE Id = {id}", .con = con)
  data <- DBI$dbGetQuery(con, query)
  DBI$dbDisconnect(con)
  return(data)
}

#' @export
get_data  <- function(columns, table, id, id_col, joins = NULL) {
  con  <- DBI$dbConnect(
    RSQLite$SQLite(),
    here("app", "synthea.sqlite")
  )
  joins <- joins
  query <- glue_sql(
    "SELECT {`columns`*} FROM {`table`}",
    if (!is.null(joins)) joins,
    "WHERE {id_col} = {id}",
    .con = con,
    .sep = " ")
  data <- DBI$dbGetQuery(con, query)
  DBI$dbDisconnect(con)
  return(data)
}

#TESTING
# ID <-  "4fe88ea1-1627-47d7-8dec-9d11f43faf0a" #for testing
# columns <- list(
#   DBI$Id("encounters", "START"),
#   DBI$Id("encounters", "STOP"),
#   DBI$Id("encounters", "PATIENT"), #this is the patient ID
#   DBI$Id("encounters", "DESCRIPTION"),
#   # DBI$Id("providers", "NAME"),
#   glue_sql("`providers`.`NAME` AS Provider"),  #this works
#   DBI$Id("organizations", "NAME")
# )

# table <- "encounters"

# joins <-
#   "JOIN `providers` ON `encounters`.`PROVIDER` = `providers`.`Id`
#   JOIN `organizations` ON `encounters`.`ORGANIZATION` = `organizations`.`Id`"

# ID_col <- glue_sql("`encounters`.`PATIENT`")

# get_data(columns, table, ID, ID_col, joins)
