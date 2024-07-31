box::use(
  tidyr[unite],
  tibble[deframe],
)

box::use(
  app/logic/database_actions[retrieve_data],
)

# TODO fix imports

#' @export
create_patient_list <- function() {
  data <- retrieve_data(c("FIRST", "LAST", "Id"), "patients") |>
    tidyr::unite(col = NAME, FIRST, LAST, sep = " ", remove = TRUE) |>
    tibble::deframe()
  return(data)
}

#' Create dropdown list
#'
#' Creates a vector of unique values to be used in a shiny select input. 
#' 
#' @param df A dataframe containing the column to create dropdown list from
#' @param distinct_col The column to pull list from
#'
#' @export
create_dropdown_list <- function(df, distinct_col) {
  data <- df |> 
    dplyr::distinct(!!rlang::ensym(distinct_col)) |>
    dplyr::pull(!!rlang::ensym(distinct_col))
  return(data)
}
