# Attempt at adapting the Association of Aanesthetists Calculators into app:
# Lawrence Li
# 09.06.2021


# FiO2 and FGF ------------------------------------------------------------

fgf <- 4
fio2 <- 0.25
sevo <- 2
MW <- 200
GWP <- 130
density <- 0.00152
unit_vol <- 250
unit_cost <- 48



o2_per_min_with_air <- (fio2 - 0.209)*fgf/0.791

o2_per_min_with_n2o <- fio2*fgf

air_per_min <- fgf - o2_per_min_with_air

fgf_with_vapour <- fgf + (sevo/100*fgf)

calc_fio2_with_air <- (o2_per_min_with_air + (air_per_min * 0.209))/fgf_with_vapour

calc_fio2_with_n2o <- o2_per_min_with_n2o/fgf_with_vapour

co2e_o2_air <- o2_per_min_with_air * 0.0004 * 60

co2e_o2_n2o <- o2_per_min_with_n2o* 0.0004 * 60

sevo_ml_per_min <- (fgf * 1000) * (sevo/100)

sevo_mols_per_min <- sevo_ml_per_min/24400

sevo_kg_per_min <- MW*sevo_mols_per_min/1000

sevo_kg_per_hr <- sevo_kg_per_min * 60

co2e_sevo <- sevo_kg_per_hr * GWP

co2e_total_air <- co2e_o2_air + co2e_sevo

sevo_vol_per_hr <- sevo_kg_per_hr/density

sevo_fraction_bottle <- sevo_vol_per_hr/unit_vol

sevo_cost_per_hr <- sevo_fraction_bottle * unit_cost



# Nitrous -----------------------------------------------------------------

o2_per_min_with_n2o <- fio2 * fgf

calc_fio2_with_n2o <- o2_per_min_with_n2o/fgf_with_vapour

n2o_per_min <- (1 - fio2)* fgf

n2o_per_hr <- n2o_per_min * 60

n2o_mols_per_hr <- n2o_per_hr/24.4

n2o_kg_per_hour <- (n2o_mols_per_hr * 44)/1000

co2e_n20 <- n2o_kg_per_hour * 310

co2e_o2_with_n2o <- co2e_o2_n2o + co2e_n20

co2e_total_n2o <- co2e_o2_with_n2o + co2e_sevo














