library("ces", quietly = TRUE)

year <- 2021

cat("Processing", year, "- larger file, this may take a bit longer...")

destination_folder <- paste0("data/raw/ces_", year)

if (!dir.exists(destination_folder)) {
  dir.create(destination_folder, recursive = TRUE)
}

invisible(capture.output(ces::download_pdf_codebook(
  year = year,
  path = file.path(destination_folder),
  overwrite = TRUE,
  verbose = FALSE
)))

ces_uppercase_file <- file.path(destination_folder, paste0("CES_", year, "_codebook.pdf"))
ces_lowercase_file <- file.path(destination_folder, paste0("ces_", year, "_codebook.pdf"))

if (file.exists(ces_uppercase_file) && !file.exists(ces_lowercase_file)) {
  success <- file.rename(ces_uppercase_file, ces_lowercase_file)
  if (!success) {
    cat("Warning: Could not rename", basename(ces_uppercase_file), "to", basename(ces_lowercase_file), "\n")
  }
}

invisible(capture.output(ces::download_ces_dataset(
  year = year,
  path = file.path(destination_folder),
  overwrite = TRUE,
  verbose = FALSE
)))

cat(" ✓\n")

cat("Extract completed for", year, "\n")
