box::use(
  shiny[moduleServer, NS],
)




#' @export
ui <- function(id) {
  ns <- NS(id)
  shiny::h3("Observations")
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {


  })
}
