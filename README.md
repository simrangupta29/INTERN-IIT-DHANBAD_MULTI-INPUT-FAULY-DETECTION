This repository presents a comprehensive methodology for detecting single parametric faults in multi-input analog circuits using polynomial regression modelling.

Analog circuits—particularly in mixed-signal systems—are difficult to test due to their nonlinear behavior, limited test access, and high sensitivity to manufacturing variations. Traditional specification-based methods often fall short in terms of fault coverage and cost-efficiency.

To address these challenges, we propose a regression-based fault detection approach, where the output of the Circuit Under Test (CUT) is modeled as a polynomial function of multiple input variables, derived using Taylor series expansion. The polynomial coefficients are estimated using least squares fitting, and fault-free (FF) bounds for each coefficient are established via Monte Carlo simulations under nominal tolerance variations. During testing, any deviation of the estimated coefficients beyond the FF bounds indicates a parametric fault.

🔍 To the best of our knowledge, parametric fault detection in multi-input analog circuits using polynomial regression modelling is attempted for the first time in the literature.

✅ Key Features
Supports multi-input linear and nonlinear analog circuits

Robust against additive noise

Validated on:

Lead-lag filter

Four-quadrant analog multiplier

PI compensator in a buck converter

Tested under:

Sine wave inputs

Slow ramp/DC sweep inputs

Uses MATLAB for regression modelling and OrCAD/PSpice for simulations

📌 Conclusion
This approach provides a low-cost, simulation-based test framework for analog and mixed-signal fault detection. It successfully detects small parametric deviations with high accuracy, making it suitable for practical applications in post-manufacturing testing, fault diagnosis, and design validation.
