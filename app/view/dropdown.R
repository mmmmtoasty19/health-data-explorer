box::use(
  shiny[moduleServer, NS, reactive],
)

# TODO This module not working the way I expect as a nested module.  
# The observe/observe event is just not working as I would like. 

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
server <- function(id, choices, ...) {
  moduleServer(id, function(input, output, session) {
    
    shiny::observeEvent(choices(), {
      shiny::updateSelectizeInput(
        session,
        inputId = "selectinput",
        choices = choices(),
        ...
      )
    })

    return(reactive({
      input$selectinput
    }))


  })
}
