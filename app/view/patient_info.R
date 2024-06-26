box::use(
  shiny[moduleServer, NS, uiOutput, renderUI],
)

box::use(
  app/logic/database_actions[get_patient_data],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  shiny::verbatimTextOutput(ns("value"))
  renderUI(ns("pt_demo"))

}

#' @export
server <- function(id, patient_id) {
  moduleServer(id, function(input, output, session) {
    output$value <- shiny::renderPrint(patient_id())

    output$pt_demo  <- renderUI({
      "It Worked"
    })

  })
}
