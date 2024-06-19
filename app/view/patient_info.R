box::use(
  shiny[moduleServer, NS],
)


#' @export
ui <- function(id) {
  ns <- NS(id)
  shiny::h3("Patient Info")
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    print("Patient server part works!")
  })
}
