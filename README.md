# NLP + SNA Lab Suite – Natural Language Processing & Social Network Analysis Practicals

Google Colab notebooks for the NLP and SNA labs. Each practical folder holds the notebook (`expN.ipynb`), a
`NOTES.md` (theory from zero, code walkthrough, how to write it from scratch, viva answers) and a
`sample-output.txt` (plus plots where there are any).

Start with [`SETUP.md`](SETUP.md) (Colab runtimes, R vs Python, GPU, common errors), then open the practical you need.
The setup guide also opens in Colab: [SETUP.ipynb](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/SETUP.ipynb).

**In Colab:** File → Open notebook → **GitHub** tab → `ashbiry/nlp-sna-suite` lists every notebook: `expN.ipynb` = code,
`NOTES.ipynb` = theory and viva answers (read-only, nothing to run).

## Open in Colab (one click)

| # | Practical | Runtime | Notebook | Notes |
|---|---|---|---|---|
| SNA 1 | Coding Social Networks (igraph, ggraph) | R | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/1/exp1.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/1/NOTES.ipynb) |
| SNA 2 | Working with APIs (senator tweets) | R | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/2/exp2.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/2/NOTES.ipynb) |
| SNA 3 | Modeling a Network (box plot, scatter, regression) | R | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/3/exp3.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/3/NOTES.ipynb) |
| SNA 4 | Introduction to Text Analysis (mentions) | R | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/4/exp4.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/4/NOTES.ipynb) |
| SNA 5 | Tools for Social Network Analysis | theory | – | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/5/NOTES.ipynb) |
| NLP 1 | Text Preprocessing & Frequent Terms (AG News) | Python | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/1/exp1.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/1/NOTES.ipynb) |
| NLP 2 | Bag of Words Review Classification (IMDb) | Python | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/2/exp2.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/2/NOTES.ipynb) |
| NLP 3 | TF-IDF Tweet Sentiment Analysis (Sentiment140) | Python | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/3/exp3.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/3/NOTES.ipynb) |
| NLP 4 | Named Entity Recognition (spaCy) | Python | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/4/exp4.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/4/NOTES.ipynb) |
| NLP 5 | Topic Modelling with LDA (20 Newsgroups) | Python | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/5/exp5.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/5/NOTES.ipynb) |
| NLP 6 | Text Generation with RNN, LSTM, GRU (GPU) | Python + GPU | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/6/exp6.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/6/NOTES.ipynb) |
| NLP 7 | Transformer Summarization + ROUGE (GPU) | Python + GPU | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/7/exp7.ipynb) | [Open](https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/nlp/7/NOTES.ipynb) |

## Download files

**Linux / WSL / macOS (bash):**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ashbiry/nlp-sna-suite/main/install.sh)
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/ashbiry/nlp-sna-suite/main/install.ps1 | iex
```
On old Windows PowerShell 5.1, a TLS error is fixed by running
`[Net.ServicePointManager]::SecurityProtocol = 'Tls12'` first.

The menu offers each practical (`s1`–`s5`, `n1`–`n7`), the SNA datasets (`d`, saved to `data/`), `SETUP.md` (`99`) or
everything (`0`).

## Datasets
SNA notebooks load the data directly from `https://dssoc.github.io/datasets/`. Copies are in [`data/`](data/) in case
that site is unreachable (upload them to the Colab session and use `load("congress.RData")`).
NLP notebooks download their datasets (Hugging Face, Kaggle, TensorFlow) when run.
