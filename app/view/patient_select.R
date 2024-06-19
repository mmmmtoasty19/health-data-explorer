box::use(
  shiny[moduleServer, NS, selectizeInput,updateSelectizeInput],
)

box::use(
  app/logic/database_actions[retrieve_patients],
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
    patient_list  <- retrieve_patients() |>
      dplyr::select(Id)

    updateSelectizeInput(
      session,
      inputId = "selectinput",
      choices = patient_list
    )
  })
}
