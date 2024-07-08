box::use(
  shiny[moduleServer, NS, selectizeInput, updateSelectizeInput, reactive],
)

box::use(
  app/logic/database_actions[retrieve_data],
  app/logic/utilites[create_patient_list],
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
    patient_list  <- create_patient_list()

    updateSelectizeInput(
      session,
      inputId = "selectinput",
      choices = patient_list
    )

    reactive(input$selectinput)

  })
}
