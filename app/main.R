box::use(
  shiny[moduleServer, NS, renderUI, tags, fluidRow, icon],
  bs4 = bs4Dash[tabItem, box, menuItem],
)

box::use(
  app/view/patient_info,
  app/view/patient_select,
  app/view/patient_encounters,
  app/view/pt_observations,
  app/view/pt_labs,
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
            box(
              title = "Patient Demographics",
              patient_info$ui(ns("patient_info"))
            ),
            box(
              title = "Patient Encounters",
              patient_encounters$ui(ns("pt_encounters"))
            )
          ),
          fluidRow(
            box(
              title = "Observations",
              pt_observations$ui(ns("pt_observations"))
            ),
            box(
              title = "Patient Labs",
              pt_labs$ui(ns("pt_labs"))
            )
          )
        )
      )
    )
  )
}



#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    patient_id <- patient_select$server("patient_select")
    patient_info$server("patient_info", patient_id)
    encounter_id <- patient_encounters$server("pt_encounters", patient_id)
    pt_observations$server("pt_observations")
    pt_labs$server("pt_labs", patient_id)
  })
}
