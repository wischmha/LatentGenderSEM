# Charité - Universitätsmedizin Berlin, Institut für Public Health
# Mascha Kern
# March 26, 2025
# Draft SEM with mediators

# SEM: all endogenous variables are continuous, outcomes (cf. appended Dx regressions) are dichotomous
sem_model <- "
  # measurement model for latent variable gender
  gender =~ daily_hours_housework_weekdays + daily_hours_childcare_weekdays +
            current_monthly_gross_labor_income + gross_hourly_wage + employment_status_imp +
            highest_educational_degree + risk_taking_scale + political_interest + current_mat_parent_leave + num_physician_visits

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

  # mediators
  smoke_before_migraine        ~~ A * sex_binary + B * gender + C * age_10y
  diabetes_before_migraine     ~~ D * sex_binary + E * gender + F * age_10y
  hypertension_before_migraine ~~ G * sex_binary + H * gender + I * age_10y
  smoke_before_stroke          ~~ J * sex_binary + K * gender + L * age_10y
  diabetes_before_stroke       ~~ M * sex_binary + N * gender + O * age_10y
  hypertension_before_stroke   ~~ P * sex_binary + Q * gender + R * age_10y

  # medical Dx outcomes
  migraine_incidence ~ MB * sex_binary + MG * gender + MO * sex_or + MP * partner + MA * age_10y + MI * immigration_history +
                       MS * smoke_before_migraine + MD * diabetes_before_migraine + MH * hypertension_before_migraine
  stroke_incidence   ~ SB * sex_binary + SG * gender + SO * sex_or + SP * partner + SA * age_10y + SI * immigration_history + 
                       SS * smoke_before_stroke   + SD * diabetes_before_stroke   + SH * hypertension_before_stroke
                     
  # total effects
  t_mig_sex := MB + (A * MS) + (D * MD) + (G * MH)
  t_mig_gen := MG + (B * MS) + (E * MD) + (H * MH)
  t_mig_age := MA + (C * MS) + (F * MD) + (I * MH)
  t_str_sex := SB + (J * SS) + (M * SD) + (P * SH)
  t_str_gen := SG + (K * SS) + (N * SD) + (Q * SH)
  t_str_age := SA + (L * SS) + (O * SD) + (R * SH)
"
