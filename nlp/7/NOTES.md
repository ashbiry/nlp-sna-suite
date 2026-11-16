# NLP Experiment 7 – Summarization with a pre-trained Transformer (T5) + ROUGE

**Aim:** fine-tune a pre-trained Transformer on a summarization dataset, generate abstractive and extractive summaries,
evaluate with ROUGE.
**Colab:** `exp7.ipynb`, Runtime → Change runtime type → **T4 GPU**, Run all (~5–8 min: downloads + 1 epoch on 2,000 articles).
No GPU → skip the training cell; the pre-trained t5-small still summarises (slightly lower ROUGE).
**Expected (approx.):** T5 ROUGE-1 ≈ **0.30–0.36**, ROUGE-2 ≈ 0.12–0.15, ROUGE-L ≈ 0.22–0.26 (class rep: R1 0.316);
extractive baseline a bit lower on ROUGE-2.
⚠ Not run in my sandbox (Hugging Face is blocked there); extractive + ROUGE code was tested. Run it once in Colab before the exam.

## Why T5 and not BERT/GPT? (say this if asked)
The manual says "BERT or GPT". **BERT** is an encoder-only model (understanding: classification, NER) – it cannot write text
by itself. **GPT** is decoder-only (generation). Summarization = read a long text **and** write a new short one →
an **encoder–decoder** Transformer fits best: **T5** (or BART). T5-small (60M parameters) trains on a free Colab GPU.

## Concepts from zero
- **Summarization:** shorter text keeping the important information.
  - **Extractive:** select important sentences from the original (copy). Our method: score each sentence by the average
    frequency of its words, keep the top 3 in original order.
  - **Abstractive:** generate **new** sentences (paraphrase) – needs a language-generation model.
- **Transformer:** architecture based on **attention** instead of recurrence. **Self-attention:** every word looks at every
  other word and decides how much each matters (e.g. "it" attends to the noun it refers to). Processes all words in parallel → fast, long context.
  **Encoder** reads the input; **decoder** generates output word by word, attending to the encoder.
- **Pre-trained model:** already trained on huge text corpora → knows language. **Fine-tuning:** continue training on our
  task-specific data (CNN/DailyMail article → highlights) with a small learning rate. Needs far less data/time than training from scratch.
- **T5 (Text-to-Text Transfer Transformer):** every task is text in → text out; the task is given as a prefix: `"summarize: ..."`.
- **Tokenizer:** splits text into sub-word pieces and maps them to ids (`input_ids`); `labels` = ids of the reference summary.
  `max_length=512, truncation=True` cuts long articles.
- **Generation:** `model.generate(num_beams=4)` – **beam search** keeps the 4 best partial summaries at each step;
  `min_length/max_length` bound the length.
- **ROUGE (Recall-Oriented Understudy for Gisting Evaluation):** compares a generated summary with a human **reference**.
  - ROUGE-1 = overlap of single words, ROUGE-2 = overlap of word pairs, ROUGE-L = longest common subsequence (order-aware).
  - Each gives precision, recall, **F-measure**; 0–1, higher = better. Measures word overlap, not meaning.
- **Dataset CNN/DailyMail:** ~300k news articles with bullet-point "highlights" as reference summaries.

## Code walkthrough
installs → load CNN/DailyMail (2,000 train, 20 test) + `t5-small` → `tokenize()` adds the prefix, makes `input_ids` and
`labels` → `Seq2SeqTrainingArguments` (batch 8, 1 epoch, lr 3e-4) + `Seq2SeqTrainer` + `DataCollatorForSeq2Seq` (pads each batch)
→ `trainer.train()` → `abstractive_summary()` (tokenize, generate, decode) → `extractive_summary()` → ROUGE for both
on 20 test articles → table + bar chart.
(fp16 deliberately off: T5 is known to give NaN loss in half precision.)

## Viva (manual + extras)
1. **Transformer?** Neural architecture using (self-)attention to process sequences in parallel.
2. **BERT?** Pre-trained encoder-only Transformer for language understanding (bidirectional).
3. **GPT?** Decoder-only Transformer for text generation (left-to-right).
4. **Summarization?** Producing a shorter version of a document keeping the important information.
5. **Extractive?** Selecting important sentences/phrases directly from the original text.
6. **Abstractive?** Generating new text that conveys the important information.
7. **ROUGE?** Metric for evaluating generated summaries by overlap with references.
8. **What does ROUGE compare?** Generated summary vs reference (human-written) summary.
9. **Why pre-trained?** Already learned language patterns from large data → less data and training needed.
10. **Fine-tuning?** Further training a pre-trained model on a specific task/dataset.
- *Attention in one line?* A weighted average where weights say how relevant each other word is to the current word.
- *Why not RNN for summarization?* Struggles with long documents; Transformers handle long context and train in parallel.
- *Limitation of ROUGE?* Rewards word overlap; a correct paraphrase with different words scores low.
