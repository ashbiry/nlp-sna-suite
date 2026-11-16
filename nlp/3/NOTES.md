# NLP Experiment 3 – Tweet sentiment analysis with TF-IDF (Sentiment140)

**Aim:** TF-IDF features + Logistic Regression to classify tweets as positive/negative; visualise results; predict new posts.
**Colab:** `exp3.ipynb`, Python runtime, Run all (~3 min). Dataset: **Sentiment140** (1.6M tweets, Kaggle) – we sample 100k balanced.
**Expected (real data, approx.):** accuracy ≈ **0.76–0.79** (class rep on all 1.6M: 0.784). Tweets are short and noisy → lower than IMDb.

## Concepts from zero
- **Sentiment analysis:** detecting the opinion/emotion in text (positive / negative, sometimes neutral).
- **Sentiment140 labels:** 0 = negative, 4 = positive (we map 4 → 1). Labels were made automatically from emoticons.
- **Tweet cleaning:** remove URLs (`http\S+`), @mentions (`@\w+`), the `#` sign, punctuation/numbers; lowercase.
- **TF-IDF = Term Frequency × Inverse Document Frequency**
  - **TF**(word, doc) = how often the word appears in that tweet.
  - **IDF**(word) = log(N / number of documents containing the word) → **rare words get high IDF**, words in almost every
    document (e.g. "day") get low IDF.
  - TF-IDF is high for words frequent in **this** document but rare **overall** → the informative words.
  - Example: 1000 tweets, "love" in 50 → IDF = log(1000/50) ≈ 3.0; "the" in 900 → log(1000/900) ≈ 0.1.
  - sklearn also normalises each row (L2) so long and short tweets are comparable.
- **TF-IDF vs BoW:** BoW = raw counts; TF-IDF down-weights words common across documents.
- **n-grams:** `ngram_range=(1, 2)` adds word pairs ("not happy") so some word order/negation is captured.
- **Logistic Regression:** linear model → probability of positive; `predict_proba` gives confidence; `coef_` shows which
  words push towards positive (largest weights) or negative (most negative weights).
- **Stratified split:** `stratify=y` keeps the 50/50 class balance in train and test.

## Code walkthrough
kagglehub download → read CSV (no header, latin-1) → map 4→1 → balanced sample (`groupby().sample(n=50000)`) →
`clean_tweet` → `train_test_split` 80/20 → `TfidfVectorizer.fit_transform/transform` → `LogisticRegression.fit` →
metrics + report → confusion-matrix heatmap + predicted-sentiment bar chart → top weighted words →
predict new product reviews with probability.

## If Kaggle download fails in the exam
Use any small labelled list: `texts = ["I love it", "worst ever", ...]; labels = [1, 0, ...]` – the TF-IDF + LR code is identical.

## Viva (manual + extras)
1. **TF-IDF?** Measures how important a word is to a document within a collection.
2. **TF?** Term Frequency. 3. **IDF?** Inverse Document Frequency.
4. **Why TF-IDF?** Convert text to numerical features that emphasise informative words.
5. **Sentiment analysis?** Identifying the sentiment/opinion expressed in text.
6. **Models?** Logistic Regression, SVM (also Naive Bayes).
7. **Classes here?** Positive and negative.
8. **TF-IDF vs BoW?** BoW uses raw frequency; TF-IDF also reduces the weight of words frequent across many documents.
9. **Why visualise?** To understand the distribution of predictions and errors (confusion matrix) at a glance.
10. **Positive example?** "The product is excellent and I really like it."
- *Why is Twitter sentiment harder?* Short texts, slang, sarcasm, misspellings, emojis.
- *Precision vs recall trade-off?* Raising the probability threshold increases precision, lowers recall.
