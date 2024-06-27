box::use(
  ,
)

box::use(
  app/logic/database_actions[get_patient_data],
)

ID  <- "1c60a5da-1843-1978-d31a-ee5c060a43d2"
columns  <- list("BIRTHDATE", "FIRST", "MIDDLE", "LAST", "RACE", "ETHNICITY")
table  <- "patients"

test_df  <- get_patient_data(columns, table, ID)


#' @export
pt_demo_table  <- function(df) {

}