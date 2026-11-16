# SNA Experiment 4 – Introduction to text analysis (mentions, regex, correlation)

**Aim:** analyse senator tweets: count @mentions, correlate with favorites, average by gender.
**Colab:** open `exp4.ipynb` → Runtime → Change runtime type → **R** → Run all.

| Part | Answer (from our run) |
|---|---|
| (a) correlation mentions vs favorites | **r = −0.0185**, p = 0.56 → no relationship |
| (b) avg mentions per tweet by gender | F **0.52**, M **0.70** |

## Concepts from zero
- **Text analysis:** turning unstructured text into numbers we can analyse (counts, frequencies, sentiment…).
- **Mention:** `@username` in a tweet = referring to/notifying another account (e.g. `@POTUS`).
- **Regular expression (regex):** a pattern that describes text. `@\\S+`:
  - `@` = a literal @
  - `\\S` = any character that is **not whitespace** (in R strings the backslash is written twice: `\\S`)
  - `+` = one or more of the previous
  → "@" followed by non-whitespace characters, exactly the manual's definition.
  `"On @AmericaNewsroom Wednesday, @SenJohnKennedy said"` → 2 matches.
  Other regex basics: `\\s` whitespace, `\\d` digit, `\\w` word character, `*` zero or more, `^` start, `$` end, `[abc]` any of.
- **`str_count(text, pattern)`** (stringr) = number of matches in each string.
- **Favorites (`favorite_count`)** = number of likes a tweet got.
- **Correlation:** see Exp 2. **cor.test** adds a p-value and 95% confidence interval.
- **Correlation does not imply causation:** even a strong correlation doesn't prove mentions *cause* likes.

## The code, traced
```r
tweets <- senator_tweet_sample %>% mutate(mentions = str_count(text, "@\\S+"))   # new column
cor(tweets$mentions, tweets$favorite_count)                                      # (a) r = -0.0185
```
(b) Tweets only have the handle; gender is in `congress`. Join through `congress_contact$twitter` (both lowercased),
then `group_by(gender) %>% summarise(avg_mentions = mean(mentions))`.

**Interpretation:** r ≈ 0 and p = 0.56 → the number of mentions has no linear relationship with likes.
Men mention other accounts slightly more per tweet (0.70 vs 0.52) in this sample.

## Viva (manual questions)
1. **Text analysis?** Extracting useful, measurable information from text data.
2. **Mention?** An `@username` reference to another account in a tweet.
3. **Regular expression?** A pattern used to search/match text (`@\\S+`).
4. **`@` here?** Marks the start of a mention.
5. **Correlation?** Strength and direction of the linear relationship between two numeric variables.
6. **Positive correlation?** Both increase together. 7. **Negative?** One increases as the other decreases.
8. **Average mentions?** Total mentions ÷ number of tweets (per gender group).
9. **Why group by gender?** To compare tweeting patterns between groups.
10. **Does correlation imply causation?** No – other factors (popularity of the senator, topic, timing) may drive both.
