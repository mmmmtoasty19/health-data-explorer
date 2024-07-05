box::use(
  shiny[moduleServer, NS, req],
  reactable[renderReactable, reactableOutput, reactable],
  glue[glue_sql],
  DBI,
)

box::use(
  app/logic/pt_encounters_logic[get_pt_encounter_data],
  app/logic/pt_encounters_logic[render_encounter_table],
)



#' @export
ui <- function(id) {
  ns <- NS(id)
  shiny::tagList(
  reactableOutput(ns("table")),
  shiny::verbatimTextOutput(ns("selected")))
}

#' @export
server <- function(id, patient_id) {
  moduleServer(id, function(input, output, session) {
    df <- shiny::reactive({
      req(patient_id())
      data <- get_pt_encounter_data(patient_id())
      return(data)
    }
  )

    output$table <- renderReactable({
      # req(patient_id())
      # df <- get_pt_encounter_data(patient_id())
      render_encounter_table(df())
    })

    selected <- shiny::reactive(reactable::getReactableState("table", "selected"))

    output$selected <- shiny::renderPrint({
      df() |> 
        dplyr::slice(selected()) |> 
        dplyr::select(Id) |> 
        dplyr::pull()
      # print(selected())
    })
  })
}

