box::use(
  shiny[moduleServer, NS, renderUI, tags, fluidRow, icon],
  bs4 = bs4Dash[tabItem, box, menuItem],
)

box::use(
  app/view/patient_info,
  app/view/patient_select
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  bs4$dashboardPage(
    help = NULL, #enable if tooltips should be shown
    header = bs4$dashboardHeader(),
    sidebar = bs4$dashboardSidebar(
      bs4$sidebarMenu(
        id = "sidebarmenu",
        patient_select$ui(ns("patient_select")),
        menuItem(
          "Home",
          tabName = "home",
          icon = icon("house")
        )
      )
    ),
    body = bs4$dashboardBody(
      bs4$tabItems(
        tabItem(
          tabName = "home",
          fluidRow(
            box(patient_info$ui(ns("patient_info")))
          )
        )
      )
    )
  )
}



#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    patient_ID <- patient_select$server("patient_select")
    patient_info$server("patient_info", patient_ID)
  })
}
