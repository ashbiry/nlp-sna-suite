# NLP Experiment 4 – Named Entity Recognition with spaCy (+ custom medical entities)

**Aim:** (a) extract named entities from a news article with spaCy's pre-trained NER; (b) customise it for domain entities.
**Colab:** `exp4.ipynb`, Python runtime, Run all. If `spacy.load` fails after the download cell → Runtime → Restart session → Run all.

## Results (tested here)
(a) Apple Inc.→ORG, 1 September 2026→DATE, $5 billion→MONEY, California→GPE, Tim Cook→PERSON, Pune/India→GPE,
Infosys→ORG, Salil Parekh→PERSON …
(b) **Before** customisation the model gets medical words wrong: Metformin→PERSON, Amlodipine→NORP.
**After** the EntityRuler: diabetes/hypertension→DISEASE, Metformin/Amlodipine→MEDICATION (Mumbai still GPE).
Trained model on a new sentence: diabetes→DISEASE, Insulin→MEDICATION, chemotherapy→TREATMENT.

**Bug fixed vs class rep:** his character offsets were off by 1–2 (e.g. "diabetes" at 30–38 instead of 31–39), so spaCy
printed warning W030 and **ignored every entity** → the custom model found nothing. We compute offsets with `text.find()`.

## Concepts from zero
- **Named entity:** a real-world object with a name: person, organisation, place, date, amount…
- **NER (Named Entity Recognition):** find entity spans in text **and** classify them. Unstructured text → structured data.
- **spaCy:** fast open-source NLP library. `nlp = spacy.load("en_core_web_sm")` loads a pipeline:
  tok2vec → tagger → parser → attribute_ruler → lemmatizer → **ner**. `doc = nlp(text)`; entities in `doc.ents`,
  each with `.text`, `.label_`, `.start_char`, `.end_char`. `spacy.explain("GPE")` describes a label.
- **Common labels:** PERSON, ORG (companies, agencies), **GPE** (geo-political entity: countries, cities, states), LOC (non-GPE
  locations: mountains, rivers), DATE, TIME, MONEY, PERCENT, CARDINAL (numbers), ORDINAL (first), NORP (nationalities,
  religious/political groups), PRODUCT, EVENT, LAW.
- **displacy:** spaCy's visualiser; `style="ent"` highlights entities in colour.
- **Domain-specific NER:** pre-trained models were trained on news/web text → don't know DISEASE, MEDICATION.
  1. **EntityRuler** – rule/pattern-based: list of `{"label": ..., "pattern": ...}`; added `before="ner"` so its labels win.
     Exact, no training, but only finds words in the list.
  2. **Training** – statistical: labelled examples `(text, {"entities": [(start, end, label)]})`; `spacy.blank("en")` +
     `add_pipe("ner")` + `add_label` → loop: `Example.from_dict` + `nlp.update` (with dropout); loss falls → learned.
     Can generalise to unseen words with enough data (we only have 8 sentences → demo only).
- **Character offsets:** `start` = index of first character, `end` = index after the last one; `text[start:end]` must equal the
  entity exactly, and must align with token boundaries.

## Writing it from scratch (order)
`!python -m spacy download en_core_web_sm` → `nlp = spacy.load(...)` → `doc = nlp(text)` → loop `doc.ents` →
(`displacy.render`) → EntityRuler: `add_pipe("entity_ruler", before="ner")` + `add_patterns` → print again.
(Training part is a bonus; the EntityRuler alone answers (b).)

## Viva (manual + extras)
1. **NER?** Identifying and classifying named entities in text.
2. **spaCy?** Open-source Python NLP library.
3. **Examples of entities?** Person, organisation, location, date, money, product.
4. **Purpose?** Extract structured information from unstructured text (search, knowledge graphs, resumes, medical records).
5. **PERSON?** People's names. 6. **ORG?** Organisations: companies, institutions. 7. **GPE?** Countries, cities, states.
8. **Can a pre-trained model recognise every entity type?** No – needs customisation for domain-specific entities.
9. **Domain-specific NER?** NER customised for a specific field's entities.
10. **Medical NER example?** Identifying diseases, medicines, symptoms, procedures in clinical text.
- *Rule-based vs statistical NER?* Rules: precise, no data needed, no generalisation. Statistical: learns from examples, generalises, needs labelled data.
- *Why mistakes (Modi → GPE, Kyiv → PERSON)?* Small model, ambiguous context; larger models (en_core_web_lg/trf) are better.
- *BIO / IOB tags?* Token-level labels: B-ORG (begin), I-ORG (inside), O (outside) – how NER training data is often stored.
