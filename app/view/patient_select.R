box::use(
  shiny[moduleServer, NS, selectizeInput, updateSelectizeInput, reactive],
)

box::use(
  app/logic/database_actions[retrieve_data],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  selectizeInput(
    inputId = ns("selectinput"),
    label = "Select Patient",
    choices = NULL
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    patient_list  <- retrieve_data(c("FIRST", "LAST", "Id"), "patients") |>
      tidyr::unite(col = NAME, FIRST, LAST, sep = " ", remove = TRUE) |>
      tibble::deframe()

    updateSelectizeInput(
      session,
      inputId = "selectinput",
      choices = patient_list
    )

    reactive(input$selectinput)

  })
}
