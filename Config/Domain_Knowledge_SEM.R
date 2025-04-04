# Charité - Universitätsmedizin Berlin, Institut für Public Health
# Mascha Kern
# March 26, 2025

# Common outcome regressions: Potential pre-Dx risk factors and pre-Dx behavior(s)
m_dx <- "
  migraine_incidence ~ sex_binary + gender + sex_or + partner + age_10y + immigration_history +
                       smoke_before_migraine + diabetes_before_migraine + hypertension_before_migraine"
s_dx <- "
  stroke_incidence   ~ sex_binary + gender + sex_or + partner + age_10y + immigration_history +
                       smoke_before_stroke   + diabetes_before_stroke   + hypertension_before_stroke"

# SEM: all endogenous variables are continuous, outcomes (cf. appended Dx regressions) are dichotomous
sem_measurement_model <- "
  # measurement model for latent variable gender
  gender =~ daily_hours_housework_weekdays + daily_hours_childcare_weekdays +
            current_monthly_gross_labor_income + gross_hourly_wage + employment_status_imp +
            highest_educational_degree + risk_taking_scale + political_interest + current_mat_parent_leave + num_physician_visits
"

sem_regressions_model <- "
  # hypothesis: sex at birth -> gender, fix scale for gender, comparable to sex_binary
  gender ~ 1.0 * sex_binary

  # regressions between other exogeneous variables and gender predictors
  # hypotheses: +children => +housework, +partner => -housework (shares) or +housework
  # hypotheses: +children => +childcare, +partner => -childcare (shares)
  # hypotheses: +east => -income, -wage, +age => +income, +wage
  daily_hours_housework_weekdays     ~ num_children_in_household + partner
  daily_hours_childcare_weekdays     ~ num_children_in_household + partner
  current_monthly_gross_labor_income ~ east_german_residence + age_10y
  gross_hourly_wage                  ~ east_german_residence + age_10y
"

# remove age_10y from models that will be computed by age_group
sem_measurement_model_wo_age <- str_replace_all(sem_measurement_model, c("[+] *age_10y *" = "", " *age_10y *[+]" = ""))
sem_regressions_model_wo_age <- str_replace_all(sem_regressions_model, c("[+] *age_10y *" = "", " *age_10y *[+]" = ""))
m_dx_wo_age                  <- str_replace_all(m_dx,                  c("[+] *age_10y *" = "", " *age_10y *[+]" = ""))
s_dx_wo_age                  <- str_replace_all(s_dx,                  c("[+] *age_10y *" = "", " *age_10y *[+]" = ""))

# combine SEM pieces, noting lavaan syntax for group-specific models, for group_by = "age_group", with 4 => [65,Inf)
# remove current_mat_parent_leave from gender measurement model for oldest age group 65+
sem_model <- paste(sem_measurement_model, sem_regressions_model, m_dx, s_dx, sep = "")
sem_model_wo_age <-
  paste("group: 4\n", str_replace_all(sem_measurement_model_wo_age, c("[+] *current_mat_parent_leave *" = "", " *current_mat_parent_leave *[+]" = "")),
                      sem_regressions_model_wo_age, m_dx_wo_age, s_dx_wo_age, "\n",
        "group: 3\n", sem_measurement_model_wo_age, sem_regressions_model_wo_age, m_dx_wo_age, s_dx_wo_age, "\n",
        "group: 2\n", sem_measurement_model_wo_age, sem_regressions_model_wo_age, m_dx_wo_age, s_dx_wo_age, "\n",
        "group: 1\n", sem_measurement_model_wo_age, sem_regressions_model_wo_age, m_dx_wo_age, s_dx_wo_age, sep = "")

# GDM model (logistic regression for sex_binary, same predictors as in SEM for gender, including 2nd level predictors)
gdm_model <- "
  sex_binary ~ age_group * ((daily_hours_housework_weekdays + daily_hours_childcare_weekdays) * (num_children_in_household + partner) +
                            (current_monthly_gross_labor_income + gross_hourly_wage) * east_german_residence + employment_status_imp +
                            highest_educational_degree + risk_taking_scale + political_interest + current_mat_parent_leave + num_physician_visits)
"
