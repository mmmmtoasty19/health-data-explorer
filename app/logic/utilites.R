box::use(
  tidyr[unite],
  tibble[deframe],
)

box::use(
  app/logic/database_actions[retrieve_data],
)


#' @export
create_patient_list <- function() {
  data <- retrieve_data(c("FIRST", "LAST", "Id"), "patients") |>
    tidyr::unite(col = NAME, FIRST, LAST, sep = " ", remove = TRUE) |>
    tibble::deframe()
  return(data)
}
