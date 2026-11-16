# NLP + SNA Practical Exam – Google Colab Setup

Both subjects run in **Google Colab** (colab.research.google.com): nothing to install on the lab PC,
only a browser and your Google account.
- **SNA** notebooks use the **R** runtime.
- **NLP** notebooks use the **Python** runtime (NLP 6 and 7 want a **GPU**).

## 1. Open a notebook (3 ways – use whichever works on the lab PC)
1. **From your Google Drive (fastest):** drive.google.com → `Colab Notebooks` → `NLP-SNA Practicals` →
   double-click the notebook → it opens in Colab.
2. **From GitHub (any Google account):**
   `https://colab.research.google.com/github/ashbiry/nlp-sna-suite/blob/main/sna/1/exp1.ipynb`
   (change `sna/1/exp1` to the practical you need, e.g. `nlp/4/exp4`). Or in Colab: File → Open notebook → GitHub tab →
   paste `ashbiry/nlp-sna-suite`.
3. **Upload:** download the repo files with the install script (README) → Colab → File → Upload notebook.

Writing from scratch in the exam: File → **New notebook**, then set the runtime (below) before typing.

## 2. Set the runtime
Runtime → **Change runtime type**:
| Practical | Runtime type | Hardware accelerator |
|---|---|---|
| SNA 1–4 | **R** | CPU |
| NLP 1–5 | **Python 3** | CPU |
| NLP 6 (RNN/LSTM/GRU) | Python 3 | **T4 GPU** (CPU works, much slower) |
| NLP 7 (T5 summarisation) | Python 3 | **T4 GPU** (needed for fine-tuning) |
Then Runtime → **Run all** (Ctrl+F9). Run a single cell: **Shift+Enter**.
Opening an R notebook already sets R; a **new** notebook defaults to Python → change it.

## 3. SNA (R) specifics
- Packages: `dplyr`, `ggplot2`, `stringr`, `httr`, `jsonlite` come preinstalled in Colab's R runtime.
  `igraph` and `ggraph` (Exp 1) are installed by the first cell: **~2–4 minutes**, once per session. Start that cell first.
  ```r
  install.packages(c("igraph", "ggraph"))
  ```
- Data loads straight from the web: `load(url("https://dssoc.github.io/datasets/congress.RData"))`.
  **If that site is down:** click the folder icon (left sidebar) → Upload → the `.RData` files from `data/`
  (or get them with the install script, option D) → then `load("congress.RData")`.
- Plots appear under the cell. If a plot is cramped: `options(repr.plot.width = 12, repr.plot.height = 8)`.

## 4. NLP (Python) specifics
- Install extra packages with `!pip install -q <package>` in a cell (the notebooks do this themselves).
- After `!python -m spacy download en_core_web_sm`, if loading fails: Runtime → **Restart session**, run again.
- Datasets download from Hugging Face / Kaggle / TensorFlow servers on first run (needs internet).
- If GPU quota is exhausted ("Cannot connect to GPU backend"): use CPU; in NLP 7 skip the training cell (the pre-trained T5 still summarises).

## 5. Sessions and saving
- A Colab session resets after ~90 min idle / 12 h max: packages and variables are lost → **Run all** again.
- Your edits to a notebook opened from Drive are saved automatically. Notebooks opened from GitHub are copies:
  File → **Save a copy in Drive** to keep changes.
- Files you upload to the session (left sidebar) disappear when the session ends.

## 6. Common errors
| Error | Fix |
|---|---|
| `there is no package called 'igraph'` | run the install cell first; wait for it to finish |
| `could not find function "%>%"` | `library(dplyr)` not run → run the setup cell |
| `cannot open URL ... dssoc.github.io` | upload the `.RData` files and `load("file.RData")` |
| R code in a Python notebook (`SyntaxError` on `<-`) | wrong runtime: Runtime → Change runtime type → R |
| `ModuleNotFoundError` | `!pip install -q <module>` then re-run |
| `Can't find model 'en_core_web_sm'` | run the spacy download cell, then Restart session |
| CUDA / GPU out of memory | smaller `per_device_train_batch_size`, or Restart session |
| Very slow training | check Runtime → Change runtime type → T4 GPU |
