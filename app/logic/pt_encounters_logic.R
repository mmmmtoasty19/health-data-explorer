box::use(
  DBI,
  glue[glue_sql],
)

box::use(
  app/logic/database_actions[get_data]
)

#' @export
get_pt_encounter_data <- function(ID) {
  data <- get_data(
    columns = list(
      DBI$Id("encounters", "Id"),
      DBI$Id("encounters", "START"),
      DBI$Id("encounters", "STOP"),
      DBI$Id("encounters", "DESCRIPTION"),
      glue_sql("`providers`.`NAME` AS Provider"),
      glue_sql("`organizations`.`NAME` AS Organization")
    ),
    table = "encounters",
    ID = ID,
    ID_col = glue_sql("`encounters`.`PATIENT`"),
    joins = "JOIN `providers` ON `encounters`.`PROVIDER` = `providers`.`Id`
    JOIN `organizations` ON `encounters`.`ORGANIZATION` = `organizations`.`Id`"
  ) |> 
    dplyr::mutate(dplyr::across(dplyr::where(is.numeric), lubridate::as_datetime)) |> 
    dplyr::arrange(dplyr::desc(START))
  return(data)
}

#' @export
render_encounter_table <- function(df) {
  reactable::reactable(df, selection = "single", onClick = "select", columns = list(
    .selection = reactable::colDef(
      show = FALSE
    ),
    Id = reactable::colDef(
      show = FALSE
    )
  ),
  theme = reactable::reactableTheme(
    rowSelectedStyle = list(backgroundColor = "#eee", boxShadow = "inset 2px 0 0 0 #ffa62d")
  ),
  defaultPageSize = 5
)
}

  

#TESTING
# ID <-  "4fe88ea1-1627-47d7-8dec-9d11f43faf0a" #for testing