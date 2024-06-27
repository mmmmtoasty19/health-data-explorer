box::use(
  ,
)

box::use(
  app/logic/database_actions[get_patient_data],
)

# ID  <- "1c60a5da-1843-1978-d31a-ee5c060a43d2"
# columns  <- list("BIRTHDATE", "FIRST", "MIDDLE", "LAST", "GENDER",  "RACE", "ETHNICITY")
# table  <- "patients"

# df  <- get_patient_data(columns, table, ID)


#' @export
pt_demo_table  <- function(df) {
  df |>
    dplyr::mutate(dplyr::across(BIRTHDATE, as.character)) |>
    tidyr::pivot_longer(tidyselect::everything()) |>
    purrr::pmap(function(name, value) {
      shiny::tagList(
        shiny::fluidRow(
          shiny::h3(name),
          shiny::p(value)
        ),
        shiny::hr()
      )
    })

}

