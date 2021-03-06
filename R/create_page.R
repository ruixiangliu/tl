#' Create Page
#'
#' Function to create template rmd file pre-populated with sections to fill out.
#'
#' @param fun name of function being documented
#' @param namespace the package the function is in
#'
#' @return nothing
#' @export
#'
#' @examples
#' \dontrun{
#' create_page(dplyr::first)
#' }
create_page <- function (fun, namespace = NULL) {

  # 1. open new rmd file
  # Take a copy of the template file and rename and save to the appropriate folder (make a new one if needed)

  # deparse the function & namespace
  fun <- deparse(substitute(fun))
  namespace <- deparse(substitute(namespace))
  fun <- gsub("\"|\'", "", fun)
  namespace <- gsub("\"|\'", "", namespace)

  # If !is.null(namespace) query
  if(!is.null(namespace)){
    f <-  fun
    ns <-  namespace
  }

  # If fun contains namespace, return from specified namespace
  #if !is.null(namespace) warn
  if(grepl("::", fun)) {
    if(!is.null(namespace)) warn = TRUE
    x <- strsplit(fun, "::")[[1]]
    ns <- x[1]
    f <- x[2]
  }

  # Error -
  if(!grepl("::", fun) & namespace == "NULL") {
    stop("No namespace provided")
  }

  dir.create(ns, showWarnings = FALSE)

  file <- paste0(ns, "/", f, ".md")
  template_path <- system.file("pages", "template.md", package = "tl")

  if (!file.exists(file)) {
    file.copy(template_path, file, overwrite = FALSE) #this could be amended to recieve input from console

    template <- readLines(file)
    template[1] <- paste0("# ", ns, "::", f)
    writeLines(template, file)

  }

  testing <-  identical(Sys.getenv("TESTTHAT"), "true")

  # stop the creation of a text file when testing the function
  if (!interactive() || testing) {
    message("File created", file)
  } else {
    open_editor(file)
  }

  # example template
  # # packageName::functionName
  #
  # > description
  #
  # - do an example thing
  # `code for example`
  #
  # - do a different example thing
  # `code for 2nd example`

  # 2. print some brief rules/instructions to the terminal
  msg <- paste0("Rules for making a new page:\n",
          "  1. Keep your description brief\n",
          "  2. Your whole page cannot be longer than 30 lines\n",
          "then you can upload it using tl::submit_page(",
          ns, "::", f, ")")

  message(msg)

}

open_editor <- function (file) {

  # silently find out whether we have the rstudioapi package
  have_rstudioapi <- requireNamespace("rstudioapi", quietly = TRUE)

  # if user is in RStudio, create a .md file im, else open an external text editor
  if (have_rstudioapi && rstudioapi::isAvailable() && rstudioapi::hasFun("navigateToFile")) {
    rstudioapi::navigateToFile(file)
  } else {
    utils::file.edit(file)
  }
}
