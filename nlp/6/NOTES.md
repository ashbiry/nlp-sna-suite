# NLP Experiment 6 – Text generation with RNN, LSTM, GRU (Shakespeare)

**Aim:** prepare character sequences, train an RNN to generate text from a seed, compare with LSTM and GRU.
**Colab:** `exp6.ipynb`, Runtime → Change runtime type → **T4 GPU**, Run all (~3–5 min on GPU; 5 epochs each).
**Expected:** validation loss roughly 1.5–2.0 after 5 epochs; LSTM/GRU usually ≤ SimpleRNN; generated text has
Shakespeare-like layout ("first citizen:", line breaks) and mostly real short words, but no real meaning.

## Concepts from zero
- **Language model:** predicts the next token from the previous ones. **Character-level:** tokens are characters
  (small vocabulary ~40, no unknown words).
- **Encoding:** `char_to_index` maps each character to a number (`'a' → 11`); the text becomes an array of numbers.
- **Training sequences:** input = 40 characters, target = the same 40 characters **shifted by one**:
  input `"to be or no"` → target `"o be or not"`. The model learns "after these characters, this one comes next" at every position.
  `step = 3`: a new sequence starts every 3 characters.
- **Embedding layer:** turns each character id into a learned vector of 64 numbers.
- **RNN (Recurrent Neural Network):** reads the sequence one step at a time and keeps a **hidden state** (memory) that is
  updated at each step: `h_t = tanh(W·x_t + U·h_(t-1) + b)`. Same weights at every step.
  `return_sequences=True` → output at **every** step (we predict the next char at each position).
- **Dense(vocab_size, softmax):** probability for each possible next character.
- **Loss = sparse categorical cross-entropy:** penalises low probability for the correct next character. Optimiser **Adam**.
- **Vanishing gradient:** in a SimpleRNN the training signal shrinks as it goes back through many steps → it forgets long-range context.
- **LSTM (Long Short-Term Memory):** adds a **cell state** (long-term memory) and 3 **gates**: forget gate (what to erase),
  input gate (what to add), output gate (what to output). Gates let information flow far → long dependencies.
- **GRU (Gated Recurrent Unit):** simpler: 2 gates (update, reset), no separate cell state; fewer parameters, often as good as LSTM, faster.
- **Seed sentence:** starting text; the model repeatedly predicts a character, appends it, and predicts again.
- **Temperature:** divides log-probabilities before sampling. < 1 (e.g. 0.5) = safer, more repetitive; > 1 = more random/creative.
- **Overfitting:** training loss keeps falling while validation loss rises (seen in the class rep's 10-epoch run) → model memorises;
  fix with fewer epochs, more data, dropout.

## Code walkthrough
download text → lowercase, first 300k chars → vocabulary + mappings → encode → build X, y (sliding window) →
`build_model(layer)` = Embedding → RNN layer → Dense softmax, compile → fit SimpleRNN 5 epochs → `generate(model, seed)` →
same for LSTM and GRU → plot validation loss of all three → generate from "love is" with each.

## Viva (manual + extras)
1. **RNN?** Neural network for sequential data with a hidden state carried between steps.
2. **Why suited to text generation?** Uses information from previous characters/words to predict the next.
3. **Seed sentence?** Initial text given to start generation.
4. **Text generation?** Automatically producing new text with a trained model.
5. **LSTM?** RNN with memory cell and gates to learn long-term dependencies.
6. **GRU?** Simpler gated RNN (update and reset gates).
7. **Why LSTM/GRU over RNN?** Handle long-term dependencies better, reduce vanishing gradients.
8. **Training sequence?** A fixed-length chunk of text used as input during training.
9. **What does the model predict?** The next character (or word) in the sequence.
10. **Limitation of basic RNN?** Vanishing gradient → can't learn long-term dependencies.
- *Character vs word level?* Character: tiny vocabulary, can invent words, needs longer sequences. Word: bigger vocabulary, more fluent.
- *Why GPU?* Training = huge matrix multiplications; GPUs do them in parallel.
