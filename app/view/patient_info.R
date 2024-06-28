box::use(
  shiny[moduleServer, NS, uiOutput, renderUI, req, div, tagList],
)

box::use(
  app/logic/database_actions[get_patient_data],
  app/logic/patient_info_logic[pt_demo_table, get_pt_img],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("pt_picture")),
    uiOutput(ns("pt_demo"))
  )
}

#' @export
server <- function(id, patient_id) {
  moduleServer(id, function(input, output, session) {
    output$pt_picture <- renderUI({
      req(patient_id())
      div(
        class = "container",
        div(
          class = "row justify-content-center",
          get_pt_img(patient_id())
        )
      )
    })

    output$pt_demo <- renderUI({
      columns  <- list("BIRTHDATE", "FIRST", "MIDDLE", "LAST", "GENDER",  "RACE", "ETHNICITY")
      table  <- "patients"
      ID  <- patient_id() #nolint
      df  <- get_patient_data(columns, table, ID)
      return(
        div(
          class = "container",
          pt_demo_table(df)
        )
      )
    })
  })
}

