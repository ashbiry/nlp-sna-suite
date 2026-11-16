# SNA Experiment 3 – Modeling a network (box plot, scatter + trendline, linear regression)

**Aim:** analyse Congress members statistically with plots and a linear regression model.
**Colab:** open `exp3.ipynb` → Runtime → Change runtime type → **R** → Run all.

| Part | Answer (from our run) |
|---|---|
| (a) average age by gender | F **60.6**, M **60.5** → almost identical (`plot-a-boxplot.png`) |
| (b) age vs accounts | upward trendline: older members have more accounts (`plot-b-scatter.png`) |
| (c) age coefficient | **+0.035**, p < 0.001 |

**How to communicate (c):** *"Controlling for type, party and gender, each additional year of age is associated with
about 0.035 more social media accounts – roughly one extra account per 30 years of age. The effect is
statistically significant (p < 0.001)."* (Senators have 0.25 more accounts than representatives; R² = 0.28.)

## Concepts from zero
- **Approximate age** = 2022 − birthyear (dataset is a 2022 snapshot).
- **Number of social media accounts** = count of twitter/facebook/youtube that are not empty (0–3).
  In R, `TRUE + TRUE + FALSE = 2`, so adding the three logical columns counts them.
- **Box plot:** shows a distribution in 5 numbers: minimum, Q1 (25%), **median** (thick line), Q3 (75%), maximum;
  box = middle 50% (IQR = Q3 − Q1); dots beyond the whiskers (1.5×IQR) = **outliers**. Good for comparing groups.
- **Scatter plot:** one dot per member (x = age, y = accounts) → shows the relationship between two numeric variables.
  `geom_jitter(height = 0.1)` shifts dots slightly up/down so the 0/1/2/3 rows don't overlap.
- **Trendline:** `geom_smooth(method = "lm")` = best-fitting straight line (least squares) + grey 95% confidence band.
- **Linear regression:** models y as a straight-line combination of x's:
  `accounts = b0 + b1·type + b2·age + b3·party + b4·gender + error`.
  - **Dependent variable (y):** what we predict → number of social media accounts.
  - **Independent variables (x):** type, age, party, gender.
  - **Coefficient:** change in y for a 1-unit increase in that x, **holding the others constant**.
  - **Categorical variables** (type, party, gender) become **dummy (0/1) variables**; one level is the **reference**:
    `typesen` = senators vs representatives, `genderM` = men vs women, `partyRepublican` = vs Democrats.
  - **Controlling for** other variables = comparing members who are the same on those variables, so the age effect
    isn't mixed up with, e.g., senators being older.
  - **p-value:** probability of seeing an effect this big if the true effect were 0. < 0.05 → significant.
  - **R²:** share of the variation in y explained by the model (0.28 = 28%).
  - **Least squares:** chooses coefficients minimising the sum of squared errors (residuals).

## The code, traced
```r
members <- congress %>%
  inner_join(congress_contact, by = "bioguide_id") %>%             # add twitter/facebook/youtube
  mutate(age = 2022 - birthyear,
         has_twitter = !is.na(twitter) & twitter != "", ...,
         n_accounts = has_twitter + has_facebook + has_youtube)
```
(a) `ggplot(members, aes(x = gender, y = age)) + geom_boxplot()` (+ grouped mean table).
(b) `ggplot(members, aes(age, n_accounts)) + geom_jitter(...) + geom_smooth(method = "lm")`.
(c) `model <- lm(n_accounts ~ type + age + party + gender, data = members)`; `summary(model)`;
`coef(model)["age"]` reads the age coefficient.
Reading `summary()`: **Estimate** column = coefficients; **Pr(>|t|)** = p-values; stars = significance;
**Multiple R-squared** at the bottom.

## Viva (manual questions)
1. **Box plot?** Plot of a distribution: median, quartiles, whiskers and outliers – compares groups.
2. **Scatter plot?** Dots for pairs of numeric values, showing the relationship between two variables.
3. **Trendline?** Best-fit line through the scatter showing the overall direction of the relationship.
4. **Linear regression?** Model predicting a numeric outcome as a linear combination of predictors.
5. **Dependent variable?** Number of social media accounts.
6. **Independent variables?** Type, age, party, gender.
7. **Age coefficient?** Expected change in number of accounts per extra year of age, others held constant (+0.035).
8. **Why control other variables?** To isolate age's own effect from confounders (e.g. senators are older and have more accounts).
9. **Correlation vs regression?** Correlation = one number for the strength/direction between two variables, symmetric.
   Regression = an equation predicting y from one or more x's, gives the size of each effect while controlling others.
10. **Categorical variables in regression?** Converted to 0/1 dummies so group differences (party, gender, type)
    can be estimated relative to a reference group.
