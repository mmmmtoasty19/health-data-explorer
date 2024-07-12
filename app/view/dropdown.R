box::use(
  shiny[moduleServer, NS, reactive],
)


#' @export
ui <- function(id, label,  ...) {
  ns <- NS(id)
  shiny::selectizeInput(
    inputId = ns("selectinput"),
    choices = NULL,
    label = label,
    ...
  )
}

#' @export
server <- function(id, ...) {
  moduleServer(id, function(input, output, session) {
    shiny::observe({
      shiny::updateSelectizeInput(
        session,
        inputId = "selectinput",
        ...
      )
    })

    reactive(input$selectinput)
  })
}
