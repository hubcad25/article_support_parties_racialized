#' Compute Relative Confidence Index (RCI)
#'
#' This function calculates the Relative Confidence Index for each party based on
#' feeling thermometers or other party evaluation scores.
#'
#' @param df A data frame containing party evaluation variables
#' @param prefix The prefix of the party evaluation variables (e.g., "feeling_")
#' @param id_col The name of the ID column
#'
#' @return A data frame with RCI values for each party
#' @export
compute_rci <- function(df, prefix, id_col) {
  tidyr::pivot_wider(
    dplyr::select(
      dplyr::mutate(
        dplyr::group_by(
          tidyr::pivot_longer(
            dplyr::select(df, dplyr::all_of(id_col), dplyr::starts_with(prefix)),
            cols = dplyr::starts_with(prefix),
            names_to = "party",
            names_prefix = prefix,
            values_to = "potgrowth"
          ),
          dplyr::across(dplyr::all_of(id_col))
        ),
        max_potgrowth = max(potgrowth, na.rm = TRUE),
        leader = as.integer(potgrowth == max_potgrowth),
        trailer = as.integer(potgrowth != max_potgrowth),
        n_leaders = sum(leader),
        potgrowth_trailers = dplyr::if_else(trailer == 1, potgrowth, NA_real_),
        second_potgrowth = dplyr::case_when(
          n_leaders == 1 ~ max(potgrowth_trailers, na.rm = TRUE),
          n_leaders >= 2 ~ max_potgrowth
        ),
        rci = dplyr::case_when(
          leader == 1 ~ potgrowth - second_potgrowth,
          trailer == 1 ~ potgrowth - max_potgrowth
        )
      ),
      dplyr::all_of(id_col),
      party,
      rci
    ),
    id_cols = dplyr::all_of(id_col),
    names_from = party,
    values_from = rci,
    names_prefix = "rci_",
    values_fn = mean
  )
}
