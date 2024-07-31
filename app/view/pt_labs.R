box::use(
  bs4 = bs4Dash[box],
  ec = echarts4r,
  shiny[moduleServer, NS],
)

box::use(
  app/logic/database_actions[get_labs],
  app/logic/utilites[create_dropdown_list],
  app/view/dropdown,
)

# TODO make select input its own reusable module
# TODO call the dropdown module from within this module
# TODO dropdown module not working, try placing input directly in this modele

#' @export
ui <- function(id) {
  ns <- NS(id)
  box(
    title = "Patient Labs",
    # shiny::selectizeInput(
    #   inputId = ns("selectinput"),
    #   choices = NULL,
    #   multiple = TRUE,
    #   label = "Select Labs"
    # ),
    dropdown$ui(ns("pt_labs_dropdown"), label = "Select Tests", multiple = TRUE),
    ec$echarts4rOutput(ns("chart"))
  )
}

#' @export
server <- function(id, patient_id) {
  moduleServer(id, function(input, output, session) {
    values <- shiny::reactiveValues(
      test_list = NULL,
      tests_selected = NULL
    )

    shiny::observeEvent(patient_id(), {
      values$test_list <- get_labs(patient_id()) |> 
        create_dropdown_list("DESCRIPTION")
    })

    tests_selected <- dropdown$server("pt_labs_dropdown", shiny::reactive(values$test_list))

    output$chart <- ec$renderEcharts4r({
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
