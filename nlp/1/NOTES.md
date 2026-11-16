# NLP Experiment 1 – Tokenization, cleaning, stemming/lemmatization, frequent terms

**Aim:** preprocess news articles (lowercase, remove stop words/punctuation, tokenize, stem/lemmatize) and find the most frequent terms.
**Colab:** `exp1.ipynb`, Python runtime, Run all (~1 min). Dataset: **AG News** (5,000 articles used).
**Expected (real data):** top terms like *said, new, reuters, year, company, first, two, world, oil…* (bar chart).

## Concepts from zero
- **NLP (Natural Language Processing):** making computers process and analyse human language.
- **Why preprocess?** Raw text is messy; models need clean, uniform units. Preprocessing reduces noise and vocabulary size.
- **Normalization – lowercase:** "News", "NEWS", "news" → one word `news`.
- **Remove punctuation & special characters:** `re.sub(r"[^a-z\s]", " ", text)` = replace every character that is
  *not* a–z or whitespace with a space (`^` inside `[...]` = NOT). Removes `. , ! ( ) - ' $ 5 …`.
- **Tokenization:** splitting text into units (**tokens**):
  - word tokens `word_tokenize` → `['wall', 'st', 'bears', …]`
  - sentence tokens `sent_tokenize` → list of sentences (uses punctuation, so run it **before** removing punctuation)
  - character tokens `list(text)` → `['w', 'a', 'l', 'l', …]`
- **Stop words:** very common words (*the, is, of, and, to*) carrying little meaning; NLTK has a list of ~179 English ones.
- **Stemming (PorterStemmer):** chops suffixes with rules; fast but may give non-words: studies → *studi*, companies → *compani*.
- **Lemmatization (WordNetLemmatizer):** looks the word up in a dictionary (WordNet) → real base word: studies → *study*,
  companies → *company*. Needs the part of speech for verbs: `lemmatize("running", pos="v")` → *run*
  (default is noun, so "running" stays "running").
- **Frequency analysis:** count each term (`collections.Counter`) → `most_common(20)`.

## Code walkthrough
1. `nltk.download(...)` – tokenizer models (punkt), stop-word list, WordNet dictionary.
2. Load AG News → `text = title + ". " + description`.
3. Steps shown on one article: lower → regex clean → sentence/word/char tokens → stop-word removal → stem vs lemma.
4. `preprocess(text)` does all steps; `df["text"].apply(preprocess)` runs it on every article.
5. Flatten all token lists → `Counter(all_words).most_common(20)` → table + bar chart.

## Writing it from scratch (order)
imports + nltk downloads → load data → lowercase → regex → tokenize → stop words → stem/lemma → `preprocess()` →
`apply` → Counter → bar chart. Without internet for datasets, any list of sentences works: `docs = ["...", "..."]`.

## Viva (manual + extras)
1. **NLP?** Field of AI that processes and analyses human language (text/speech).
2. **Tokenization?** Breaking text into smaller units (tokens): words, sentences or characters.
3. **Stop words?** Common words (the, is, and) usually removed because they add little meaning.
4. **Stemming?** Reducing a word to its root by cutting suffixes (studies → studi).
5. **Lemmatization?** Converting a word to its meaningful dictionary base form (studies → study).
6. **Stemming vs lemmatization?** Stemming: rule-based, fast, may produce invalid words. Lemmatization: dictionary-based,
   slower, always a valid word, uses part of speech.
7. **Why lowercase?** So "News" and "news" count as the same word.
8. **Frequency analysis?** Counting how often each term occurs.
9. **Why remove punctuation?** Reduce noise and unnecessary characters.
10. **Token?** A single unit produced by tokenization.
- *Corpus?* The collection of documents. *Vocabulary?* Set of unique tokens.
- *Regex `\s+`?* One or more whitespace characters (used to collapse spaces).
- *Why remove stop words before counting?* Otherwise "the", "of" top every frequency list.
