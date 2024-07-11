box::use(
  shiny[moduleServer, NS],
)

box::use(
  app/logic/database_actions[get_labs],
)

# TODO make select input its own reusable module

#' @export
ui <- function(id) {
  ns <- NS(id)
  shiny::selectizeInput(
    inputId = ns("selectinput"),
    label = "Select Labs",
    choices = NULL,
    multiple = TRUE
  )
}

#' @export
server <- function(id, patient_id) {
  moduleServer(id, function(input, output, session) {

    test_list <- shiny::reactive({
      get_labs(patient_id()) |>
        dplyr::distinct(DESCRIPTION) |>
        dplyr::pull(DESCRIPTION)
    })

    shiny::observe({
      shiny::updateSelectizeInput(
        session,
        inputId = "selectinput",
        choices = test_list()
      )
    })
  })
}
