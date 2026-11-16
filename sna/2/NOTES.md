# SNA Experiment 2 – Working with APIs

**Aim:** collect and analyse senators' Twitter data via an API.
**Colab:** open `exp2.ipynb` → Runtime → Change runtime type → **R** → Run all.

## Important: what we did and why (say this if asked)
The task was designed for the free Twitter API, which **became paid in 2023**. So:
- **Part 0** demonstrates a real API call with a free public REST API (JSONPlaceholder): `GET` → JSON → data frame.
- Parts **(a)–(d)** use the data that was already collected from the Twitter API (`senator_tweets.RData`).
- The real `rtweet` calls are shown at the end of the notebook as reference.

| Part | Answer (from our run) |
|---|---|
| (a) | **98** senators list a Twitter handle; **76** of those accounts were found (have tweets in the data) |
| (b) avg tweets per senator | F **9.69** (16 senators), M **9.97** (60 senators) |
| (c) age vs account creation | proxy correlation **0.04** (≈ no relationship) |
| (d) avg retweets of last two tweets | F **200**, M **211** |

## Concepts from zero
- **API (Application Programming Interface):** a defined way for one program to request data/services from another.
  A **web/REST API**: you send an HTTP request to a URL (endpoint), the server replies with data, usually **JSON**.
- **HTTP methods:** GET = read data, POST = send/create data, PUT = update, DELETE = remove.
- **Status codes:** 200 OK, 201 Created, 401 Unauthorized (missing/invalid token), 403 Forbidden,
  404 Not Found, 429 Too Many Requests (rate limit), 500 server error.
- **JSON (JavaScript Object Notation):** text format of key–value pairs and lists, e.g.
  `{"id": 1, "name": "Leanne", "email": "x@y.com"}`. `fromJSON()` turns it into an R data frame.
- **Authentication / API key / bearer token:** proves who is calling; most APIs (Twitter) require it.
- **Rate limit:** maximum number of requests allowed per time window.
- **Correlation (Pearson r):** strength and direction of a *linear* relationship between two numeric variables, −1 to +1.
  +1 perfect positive, −1 perfect negative, ≈ 0 no linear relationship. `cor(x, y)`.
- **Mean / average:** sum ÷ count. **Grouped mean:** `group_by(gender) %>% summarise(mean(...))`.
- **Retweet:** reposting someone else's tweet. **retweet_count:** how many times a tweet was retweeted.

## The code, traced
**Part 0:**
```r
response <- GET("https://jsonplaceholder.typicode.com/users")     # HTTP GET request
status_code(response)                                            # 200 = OK
users <- fromJSON(content(response, "text", encoding = "UTF-8")) # JSON text -> data frame
```
**Linking tweets to senators.** Tweets only have `screen_name` (the handle); gender/age are in `congress`.
`congress_contact` holds each member's Twitter handle → join on it. Both sides `tolower()` so "SenJohnKennedy"
matches "senjohnkennedy". `inner_join` keeps only tweets from senators in our dataset.

**(a)** listed = senators whose `twitter` is not NA/empty (98). found = `n_distinct(screen_name)` among tweets that
matched a senator (76). With the API you'd call `lookup_users()` and count the accounts returned.

**(b)** `count(screen_name, gender)` = tweets per senator, then mean per gender.
(The sample has ~10 tweets per account; the API's `statuses_count` would give the lifetime total.)

**(c)** The data has no account-creation date, so we use the **earliest tweet** of each account as an approximation
(an account must exist before its first tweet). `cor(age, as.numeric(first_seen))` – dates must be numbers for `cor`.
r = 0.04 → essentially no linear relationship between age and when the account (first) appears.

**(d)** `group_by(screen_name) %>% arrange(desc(created_at)) %>% slice_head(n = 2)` = newest two tweets per
account, then mean `retweet_count` by gender.

## Viva (manual questions)
1. **API?** An interface that allows applications to communicate with external services.
2. **Purpose here?** To retrieve Twitter account and tweet data (and we demoed a GET request with a public API).
3. **JSON?** A lightweight text format to exchange data (key–value pairs, arrays).
4. **Correlation?** A statistical measure of the linear relationship between two variables.
5. **r = +1?** Perfect positive linear relationship. 6. **r = −1?** Perfect negative linear relationship.
7. **r ≈ 0?** Little or no linear relationship. 8. **Average?** Sum of values ÷ number of values.
9. **Retweet?** Reposting/sharing a tweet. 10. **Why group by gender?** To compare activity across groups.

**Other likely questions**
- *REST?* Architectural style: resources at URLs, standard HTTP methods, stateless requests.
- *Why can't you call the Twitter API now?* It requires a paid developer plan and a bearer token.
- *Limitation of our (c)?* Earliest sampled tweet ≥ real creation date (the sample is small), so it's only an approximation.
- *Correlation ≠ causation.* Two variables moving together doesn't mean one causes the other.
