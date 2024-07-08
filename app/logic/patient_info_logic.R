box::use(
  dplyr[mutate, across, everything, pull],
  tidyr[pivot_longer],
  purrr[pmap],
  shiny[div, tagList, strong, p, img],
)

box::use(
  app/logic/database_actions[get_patient_data],
)

# ID  <- "1c60a5da-1843-1978-d31a-ee5c060a43d2"

#' @export
pt_demo_table  <- function(df) {
  df |>
    mutate(across(BIRTHDATE, as.character)) |>
    pivot_longer(everything()) |>
    pmap(function(name, value) {
      name <- name
      value <- value

      if (name == "BIRTHDATE") {
        value <- lubridate::as_date(as.numeric(value))
      }


      tagList(
        div(
          class = "row justify-content-between pt-demo",
          strong(name),
          p(value)
        )
      )
    })
}

#' @export
get_pt_img  <- function(id) {
  pt_sex  <- get_patient_data("GENDER", "patients", id) |>
    pull()
  if (pt_sex == "M") {
    src  <- "https://cdn-icons-png.flaticon.com/512/1814/1814263.png"
  } else {
    src  <- "https://cdn-icons-png.flaticon.com/512/1814/1814235.png"
  }
  return(img(src = src, height = "125", width = "125", style = "border-radius: 50%"))
}
