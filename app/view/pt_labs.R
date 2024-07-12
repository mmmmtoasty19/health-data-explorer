box::use(
  bs4 = bs4Dash[box],
  ec = echarts4r,
  shiny[moduleServer, NS],
)

box::use(
  app/logic/database_actions[get_labs],
  app/view/dropdown,
)

# TODO make select input its own reusable module
# TODO call the dropdown module from within this module

#' @export
ui <- function(id) {
  ns <- NS(id)
  box(
    title = "Patient Labs",
    dropdown$ui(ns("pt_lab_select"), label = "Select Labs", multiple = TRUE),
    ec$echarts4rOutput(ns("chart"))
  )
}

#' @export
server <- function(id, patient_id) {
  moduleServer(id, function(input, output, session) {

    # TODO remove this logic into logic file
    test_list <- shiny::reactive({
      shiny::req(patient_id())
      get_labs(patient_id()) |>
        dplyr::distinct(DESCRIPTION) |>
        dplyr::pull(DESCRIPTION)
    })


    tests_selected <- dropdown$server("pt_lab_select", choices = test_list())

    output$chart <- ec$renderEcharts4r({
      shiny::req(tests_selected)
      get_labs(patient_id()) |>
        dplyr::mutate(dplyr::across(DATE, ~lubridate::as_date(lubridate::as_datetime(.)))) |>
        dplyr::filter(DESCRIPTION %in% tests_selected()) |>
        ec$group_by(DESCRIPTION) |>
        ec$e_charts(x = DATE) |>
        ec$e_line(serie = VALUE) |>
        ec$e_tooltip()
    })


  })
}



# TESTING
# id <-  "4fe88ea1-1627-47d7-8dec-9d11f43faf0a"

# labs_df <- get_labs(id) |>
#   dplyr::mutate(dplyr::across(DATE, ~lubridate::as_date(lubridate::as_datetime(.)))) |>
#   dplyr::filter(DESCRIPTION %in% "Triglycerides") |>
#   ec$group_by(DESCRIPTION) |>
#   ec$e_charts(x = DATE) |>
#   ec$e_line(serie = VALUE)
# labs_df
