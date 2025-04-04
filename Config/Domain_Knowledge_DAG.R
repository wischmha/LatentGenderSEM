#
# Charité - Universitätsmedizin Berlin, Institut für Public Health
# Mascha Kern
# March 27, 2025
#
DAG_know <- "dag {
bb=\"0,0,1,1\"
\"current maternity or parental leave\" [pos=\"0.126,0.410\"]
\"daily hours childcare\" [pos=\"0.096,0.243\"]
\"daily hours housework\" [pos=\"0.095,0.327\"]
\"east german residence\" [pos=\"0.264,0.543\"]
\"employment status\" [pos=\"0.391,0.066\"]
\"gross hourly wage\" [pos=\"0.250,0.079\"]
\"highest educational degree\" [pos=\"0.485,0.134\"]
\"immigration history\" [pos=\"0.267,0.867\"]
\"migraine incidence\" [outcome,pos=\"0.867,0.495\"]
\"monthly gross labor income\" [pos=\"0.140,0.168\"]
\"num of children\" [pos=\"0.264,0.791\"]
\"num of physician visits\" [pos=\"0.562,0.355\"]
\"political interest\" [pos=\"0.530,0.276\"]
\"risk taking\" [pos=\"0.458,0.205\"]
\"sexual orientation\" [pos=\"0.268,0.949\"]
\"stroke incidence\" [outcome,pos=\"0.862,0.604\"]
age [pos=\"0.261,0.712\"]
diabetes [pos=\"0.528,0.606\"]
gender [exposure,pos=\"0.298,0.277\"]
hypertension [pos=\"0.531,0.528\"]
partner [pos=\"0.264,0.637\"]
sex [exposure,pos=\"0.298,0.439\"]
smoking [pos=\"0.529,0.453\"]
\"east german residence\" -> \"gross hourly wage\"
\"east german residence\" -> \"monthly gross labor income\"
\"immigration history\" -> \"migraine incidence\"
\"immigration history\" -> \"stroke incidence\"
\"immigration history\" -> gender
\"num of children\" -> \"daily hours childcare\"
\"num of children\" -> \"daily hours housework\"
\"sexual orientation\" -> \"migraine incidence\"
\"sexual orientation\" -> \"stroke incidence\"
age -> \"gross hourly wage\"
age -> \"migraine incidence\"
age -> \"monthly gross labor income\"
age -> \"stroke incidence\"
age -> gender
diabetes -> \"migraine incidence\"
diabetes -> \"stroke incidence\"
gender -> \"current maternity or parental leave\"
gender -> \"daily hours childcare\"
gender -> \"daily hours housework\"
gender -> \"employment status\"
gender -> \"gross hourly wage\"
gender -> \"highest educational degree\"
gender -> \"migraine incidence\"
gender -> \"monthly gross labor income\"
gender -> \"num of physician visits\"
gender -> \"political interest\"
gender -> \"risk taking\"
gender -> \"stroke incidence\"
gender -> diabetes
gender -> hypertension
gender -> smoking
hypertension -> \"migraine incidence\"
hypertension -> \"stroke incidence\"
partner -> \"daily hours childcare\"
partner -> \"daily hours housework\"
partner -> \"migraine incidence\"
partner -> \"stroke incidence\"
sex -> \"migraine incidence\"
sex -> \"stroke incidence\"
sex -> diabetes
sex -> gender
sex -> hypertension
sex -> smoking
smoking -> \"migraine incidence\"
smoking -> \"stroke incidence\"
}
"
