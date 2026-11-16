# NLP Experiment 2 – Movie review classification with Bag of Words (IMDb)

**Aim:** classify movie reviews as positive/negative using BoW features and a classifier; evaluate with accuracy, precision, recall, F1.
**Colab:** `exp2.ipynb`, Python runtime, Run all (~2 min). Dataset: **IMDb** 25k train / 25k test, balanced.
**Expected (real data, approx.):** Logistic Regression ≈ **0.86–0.88** accuracy, Naive Bayes ≈ **0.82–0.84**
(class rep's run: LR 0.859, NB 0.820).

## Concepts from zero
- **Text classification:** assign a text to a predefined class (here positive = 1 / negative = 0). Supervised learning:
  we train on labelled reviews, test on unseen ones.
- **Why features?** ML models need numbers, not text.
- **Bag of Words (BoW):** build a vocabulary of all words; each document = vector of **word counts**.
  "good movie good" with vocabulary [bad, good, movie] → `[0, 2, 1]`. Word **order is ignored** (a "bag").
  Result is a big **sparse** matrix (reviews × vocabulary, mostly zeros).
- `CountVectorizer(lowercase=True, stop_words="english", max_features=20000)` = tokenize + lowercase + drop stop words +
  keep the 20,000 most frequent words.
- **fit_transform on train, transform on test:** the vocabulary is learned only from training data (no peeking at the test set);
  test reviews are counted using the same columns.
- **Logistic Regression:** learns a weight per word; score = sum(weight × count) → sigmoid → probability of positive.
- **Multinomial Naive Bayes:** uses Bayes' theorem with word probabilities per class, assuming words are independent ("naive").
  Very fast, a classic text baseline. (**SVM**: finds the separating boundary with the widest margin – also works well.)
- **Metrics** (positive = class 1):
  - TP = positive predicted positive, FP = negative predicted positive, FN = positive predicted negative, TN.
  - **Accuracy** = (TP+TN)/all. **Precision** = TP/(TP+FP) "of those I called positive, how many were?".
    **Recall** = TP/(TP+FN) "of all real positives, how many did I find?". **F1** = 2·P·R/(P+R) (harmonic mean).
  - **Confusion matrix:** rows = actual, columns = predicted; diagonal = correct.

## Code walkthrough
load IMDb → `CountVectorizer` → `X_train = fit_transform(train)`, `X_test = transform(test)` → show one review's counts →
`LogisticRegression().fit`, `MultinomialNB().fit` → `predict` → metrics function → classification report + heatmap →
predict new sentences with `vectorizer.transform([...])`.

## Viva (manual + extras)
1. **Bag of Words?** Representing text by the frequency (counts) of its words.
2. **Why BoW?** Converts text into numerical features for ML models.
3. **Text classification?** Assigning text to predefined categories.
4. **Classifier?** A model that predicts the class of input data.
5. **Accuracy?** Correct predictions ÷ total predictions.
6. **Precision?** Correctly predicted positives ÷ all predicted positives.
7. **Recall?** Correctly predicted positives ÷ all actual positives.
8. **F1-score?** Harmonic mean of precision and recall.
9. **Classifiers for text?** Naive Bayes, SVM, Logistic Regression.
10. **Limitation of BoW?** Ignores word order and meaning ("not good" ≈ "good not"), huge sparse vectors, no semantics.
- *Why did LR beat NB?* NB's independence assumption is unrealistic; LR learns weights jointly.
- *Train/test split?* Evaluate on data the model never saw → honest estimate of performance.
- *Improvement?* TF-IDF, n-grams (`ngram_range=(1,2)` captures "not good"), word embeddings, transformers.
