# Charité - Universitätsmedizin Berlin, Institut für Public Health
# Hans-Aloys Wischmann
# July 07, 2025

  # ensure consistency across systems, define presets, set default figure size
  Sys.setlocale("LC_ALL", 'de_DE.UTF-8')
  Sys.setenv(LANG = "de_DE.UTF-8")
  knitr::opts_chunk$set(echo = FALSE, fig.width = 6, fig.cap = TRUE, dpi = 1200, eval.after = "fig.cap", comment = NA)
  knitr::opts_knit$set(root.dir = getwd())

  # paths and file names
  data_path       <- "../Data/"
  domain_dag_file <- "../Config/Domain_Knowledge_DAG.txt"
  domain_sem_file <- "../Config/Domain_Knowledge_SEM.R"
  data_dict_file  <- "../Config/Variables.xlsx"
  data_vpos_file  <- "../Config/Positions.xlsx"
  data_prep_file  <- "./Preprocess.Rdata"

  # select number of imputations
  m_mice <- 20

  # required generic libraries
  library(tidyverse)
  library(flextable)
  library(data.table)
  library(table1)
  library(readxl)

  # required DAG/SEM libraries (including install)
  # library(BiocManager)
  # BiocManager::install("graph")
  # BiocManager::install("RBGL")
  library(tidySEM)
  library(dagitty)
  library(lavaan)
  library(lavaan.mi)
  library(ggdag)
  library(pcalg)
  
  # required statistics libraries
  library(mice)
  library(micd)
  library(RhpcBLASctl)
  library(marginaleffects)

  # allow BLAS to use all cores by default
  blas_set_num_threads(get_num_cores())

  # utility function to plot to *.png file and inline
  ggplot_font_size = 10 # font size for all texts except for geom_text, in points
  plot_pdf_png <- function(file_name, aspect_ratio, plot_object, plot_width = 6.7, plot_res = 1200) {
    themed_object <- plot_object + theme(text = element_text(size = ggplot_font_size), plot.title = element_text(size = ggplot_font_size))
    pdf(sprintf("%s.pdf", file_name), plot_width, plot_width * aspect_ratio, paper = "a4")
    print(themed_object)
    ignore <- dev.off()
    png(sprintf("%s.png", file_name), width = plot_width, height = plot_width * aspect_ratio, units = "in", res = plot_res)
    print(themed_object)
    ignore <- dev.off()
    knitr::include_graphics(sprintf("%s.png", file_name), dpi = 1200)
  }

  # convert p.value to stars  
  print_p <- function(p) {
    case_when(p < 0.001 ~ "***", p < 0.01 ~ "**", p < 0.05 ~ "*", TRUE ~ "")
  }

  # utility function for RRs
  rr_with_ci <- function(reg_model, outcome) {
    data.frame(comparisons(reg_model, NULL, comparison = "ratio", by = TRUE)) %>%
      arrange(desc(estimate)) %>%
      mutate(RR = sprintf("%.3f [%.3f, %.3f]", estimate, conf.low, conf.high)) %>%
      mutate(Signif = ifelse(conf.high < 1.0 | conf.low > 1.0, "*", "")) %>%
      mutate(contrast = gsub("mean", "", contrast)) %>%
      select(Variable = term, Contrast = contrast, RR, Signif) %>%
      flextable() %>% set_caption(outcome) %>% autofit()
  }
