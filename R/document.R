# Becasue Rhino apps are not a package Roxygen will not work correctly
# This function was found at https://stackoverflow.com/questions/18923405/possible-to-create-rd-help-files-for-objects-not-in-a-package
# Allows roxygen style documentation to be produced without creating a package

moxygenise <- function(codepath, manpath) {
  apply_at_level <- function(l, f, n, ...) {
    ## function to apply a function at specified level of a nested list
    if (n < 0) {
      stop("Invalid parameter - n should be integer >= 0 -- APPLY_AT_LEVEL")
    } else if (n==0) {
      return(l)
    } else if (n == 1) {
      return(lapply(l, f, ...))
    } else {
      return(lapply(l, function(x) {apply_at_level(x, f, n-1)}))
    }
  }

  list.files.paths <- function(path, pattern) {
    ## function to list absolute path of all files under specified path matching certain pattern
    path <- normalizePath(path)
    return(file.path(path, list.files(path=path, pattern=pattern)))
  }

  sourcefiles <- list.files.paths(codepath, "\\.R$")
  source_envs <- lapply(sourcefiles, roxygen2::env_file)
  rd_blockss <- mapply(roxygen2::parse_file, sourcefiles, source_envs)

  help_topicss <- mapply(function(rdblock, sourceenv, sourcefile) {
      return(roxygen2::roclet_process(
          roxygen2::rd_roclet(), 
          rdblock, sourceenv, 
          dirname(sourcefile)))},
          rd_blockss, source_envs, sourcefiles)

  rd_codes <- purrr::flatten(apply_at_level(help_topicss, format, 2))

  mapply(function(text, topic, outpath=manpath) {
    cat("Write", topic, "to", outpath, "\n")
    write(text, file=file.path(outpath, topic))
    }, rd_codes, names(rd_codes))
  return(NULL)
}

code_path = here::here("app", "logic")
out_path = here::here("man")

moxygenise(code_path, out_path)

