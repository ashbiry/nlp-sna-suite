# NLP Experiment 5 – Topic modelling with LDA (20 Newsgroups)

**Aim:** preprocess documents, apply LDA to discover topics, visualise topics and their words.
**Colab:** `exp5.ipynb`, Python runtime, Run all (~1–2 min). Dataset: **20 Newsgroups** (4 groups: space, hockey, guns, graphics).
Uses **scikit-learn's LDA** (preinstalled in Colab). The class rep's gensim + pyLDAvis often break on Colab with version
conflicts – sklearn avoids that.
**Expected:** 4 topics close to the 4 newsgroups, e.g. *space, nasa, launch, orbit…* / *game, team, hockey, season…* /
*gun, people, government, law…* / *image, graphics, file, jpeg…* (exact words vary).

## Concepts from zero
- **Topic modelling:** automatically discovering the hidden themes ("topics") in a collection of documents.
- **LDA (Latent Dirichlet Allocation):**
  - each **topic** = a probability distribution over words (topic "space": space 0.08, nasa 0.05, orbit 0.04 …)
  - each **document** = a mixture of topics (doc 0: 95% space, 4% hockey …)
  - **latent** = hidden (topics are never labelled); **Dirichlet** = the probability distribution used as the prior for those mixtures.
  - **unsupervised**: no labels needed; we only choose the number of topics *K*.
  - Intuition: LDA repeatedly reassigns each word to a topic so that documents use few topics and topics use few words;
    words that appear together end up in the same topic.
- **Document-term matrix (DTM):** documents × words, word counts (= Bag of Words). LDA needs **counts**, not TF-IDF.
- `CountVectorizer(max_df=0.5, min_df=5)` drops words in > 50% of documents (too common) and in < 5 documents (too rare).
- **Outputs:** `lda.components_` (topics × words, word weights per topic); `lda.fit_transform(dtm)` (documents × topics, each row sums to 1).
- **Choosing K:** domain knowledge, **topic coherence** (do top words make sense together?), perplexity (lower better), trial and error.

## Code walkthrough
load 4 newsgroups (headers/footers/quotes removed) → `preprocess` (lowercase, letters only, tokenize, remove stop words &
words ≤ 2 letters) → join tokens back into strings → `CountVectorizer` → DTM → `LatentDirichletAllocation(n_components=4)` →
top 10 words per topic (`argsort()[::-1][:10]`) → topic mix of one document → bar charts per topic → documents per dominant topic.
`argsort()[::-1]` = indexes sorted from largest to smallest value.

## gensim version (if asked in viva)
`dictionary = corpora.Dictionary(tokens)`; `corpus = [dictionary.doc2bow(t) for t in tokens]`;
`LdaModel(corpus, num_topics=4, id2word=dictionary, passes=10)`; `print_topics()`; pyLDAvis for an interactive map.

## Viva (manual + extras)
1. **LDA?** Latent Dirichlet Allocation – unsupervised technique for discovering topics in documents.
2. **Topic modelling?** Discovering hidden topics in a collection of documents.
3. **Supervised or unsupervised?** Unsupervised.
4. **Topic in LDA?** A probability distribution over words representing a common theme.
5. **Can a document contain multiple topics?** Yes – each document is a mixture of topics.
6. **Why preprocess?** Remove noise so topics are made of meaningful words.
7. **Why remove stop words?** They appear everywhere and don't distinguish topics.
8. **Output of LDA?** Topics with their top words and probabilities, and each document's topic distribution.
9. **Choosing the number of topics?** Domain knowledge or measures like topic coherence / perplexity.
10. **Advantage?** Discovers hidden themes automatically without labelled data.
- *LDA vs clustering (k-means)?* k-means puts each document in **one** cluster; LDA gives each document a **mix** of topics.
- *Limitation?* Must choose K; ignores word order; topics need human interpretation.
