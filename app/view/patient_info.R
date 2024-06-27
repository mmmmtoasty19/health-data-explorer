box::use(
  shiny[moduleServer, NS, uiOutput, renderUI],
)

box::use(
  app/logic/database_actions[get_patient_data],
  app/logic/patient_info_logic[pt_demo_table],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("pt_demo"))
}

#' @export
server <- function(id, patient_id) {
  moduleServer(id, function(input, output, session) {
    output$pt_demo  <- renderUI({
      columns  <- list("BIRTHDATE", "FIRST", "MIDDLE", "LAST", "GENDER",  "RACE", "ETHNICITY")
      table  <- "patients"
      ID  <- patient_id()

      df  <- get_patient_data(columns,table,ID)

      return(pt_demo_table(df))
    })

  })
}
