# SNA Experiment 1 – Coding Social Networks (igraph + ggraph in R)

**Aim:** create, analyse and visualise a social network of Congress members using igraph and ggraph.
**Colab:** open `exp1.ipynb` → Runtime → Change runtime type → **R** → Run all. Expected numbers in `sample-output.txt`.

| Part | Answer (from our run) |
|---|---|
| (a) vertices, edges | **539** members, **22,453** edges |
| (b) edges with ≥ 3 shared committees | **179** |
| (c) plot | `plot-c-network-3plus.png` (112 connected members, coloured by party) |
| (d) senator-only network | **100** senators, **3,187** edges |

## Concepts from zero
- **Social network** = a set of entities (people, organisations) and the relationships between them.
- **Graph** = mathematical model of a network: **vertices (nodes)** + **edges (links)**.
  Here: vertex = a Congress member; edge = two members sit on at least one common committee.
- **Undirected** edge: the relation goes both ways (if A shares a committee with B, B shares it with A).
- **Weighted** edge: the edge carries a number. Here `n_committees` = how many committees they share.
- **Degree** of a vertex = number of edges touching it = how many colleagues a member is directly connected to.
- **Subgraph** = a graph made of a subset of the vertices (and the edges among them). Part (d) is a subgraph.
- **Edge list / data frame representation:** a graph can be stored as a table with one row per edge (from, to, weight).
  `graph_from_data_frame()` turns such a table into an igraph object.
- **igraph** = R package to create and analyse graphs (vcount, ecount, degree, subgraphs, centrality, communities).
- **ggraph** = ggplot2-style plotting for graphs: `ggraph(g, layout) + geom_edge_link() + geom_node_point()`.
- **Layout "fr" (Fruchterman–Reingold):** force-directed: connected nodes pull together, all nodes push apart,
  so tightly connected groups appear as clusters.

## The data
- `congress`: one row per member (bioguide_id = unique ID, full_name, type = sen/rep, party, gender, birthyear…).
- `committees`: 52 full committees (thomas_id = committee ID). `subcommittees`: 201 subcommittees.
- `committee_memberships`: who sits on which committee or subcommittee (thomas_id, bioguide_id).

## The code, traced
**1. Memberships of full committees only**
```r
memberships <- committee_memberships %>%
  filter(thomas_id %in% committees$thomas_id) %>%      # drop subcommittee rows
  filter(bioguide_id %in% congress$bioguide_id) %>%     # every edge end must be a known vertex
  select(thomas_id, bioguide_id) %>%
  distinct()
```
**2. Pairs of members on the same committee = self-join**
```r
common_committees <- memberships %>%
  inner_join(memberships, by = "thomas_id", relationship = "many-to-many") %>%
  filter(bioguide_id.x < bioguide_id.y) %>%
  count(bioguide_id.x, bioguide_id.y, name = "n_committees")
```
Example: committee SSAF has members A, B, C. Joining the table with itself on thomas_id gives every combination:
(A,A) (A,B) (A,C) (B,A) (B,B) … `x < y` keeps each pair **once** and drops pairs with themselves:
(A,B) (A,C) (B,C). If A and B also share 2 other committees, the pair (A,B) appears 3 times →
`count()` gives `n_committees = 3`. `.x` / `.y` = dplyr's automatic suffixes for the two copies of the column.
`relationship = "many-to-many"` only tells dplyr this many-to-many join is intended (avoids a warning).

**(a)** `graph_from_data_frame(common_committees, directed = FALSE, vertices = congress)`
first two columns = edge ends, other columns (n_committees) become edge attributes;
`vertices = congress` adds every member (even with no edges) and their attributes (party, type…). Then `vcount`, `ecount`.

**(b)** `filter(n_committees >= 3)` before building the graph → only strong ties remain → 179 edges.
Why a threshold of 3? It keeps **stronger** relationships and removes the huge number of weak ties, so the
structure is visible (22,453 edges is an unreadable "hairball").

**(c)** `delete_vertices(g3, degree(g3) == 0)` removes members with no edges (they'd just be scattered dots),
then `ggraph(..., layout = "fr")` with edge width = shared committees and node colour = party.

**(d)** `induced_subgraph(g, senator_ids)` keeps only senator vertices and the edges **between** them.

## Writing it from scratch (order)
libraries → load 2 files → memberships (2 filters, select, distinct) → self-join + filter x<y + count →
graph (a) → filter ≥3 + graph (b) → delete isolated + ggraph (c) → senator ids + induced_subgraph (d).
Shortcut if you forget `induced_subgraph`: filter the edge table so both ends are senators, then
`graph_from_data_frame(edges, directed = FALSE, vertices = congress %>% filter(type == "sen"))`.

## Viva (manual questions)
1. **Social network?** A network representing relationships (edges) between entities (nodes).
2. **Vertex?** A node representing an entity – here a Congress member.
3. **Edge?** A connection representing a relationship between two vertices – here a shared committee.
4. **igraph?** R package for creating and analysing networks.
5. **ggraph?** R package (built on ggplot2) for visualising graphs and networks.
6. **Degree?** Number of edges connected to a vertex. (Weighted degree / strength = sum of edge weights.)
7. **Why a threshold of 3?** Keep only stronger relationships (members sharing ≥ 3 committees) and make the
   network readable.
8. **Subgraph?** A graph formed from a subset of the vertices and/or edges of another graph.
9. **What is a vertex here?** A Congress member.  10. **An edge here?** Two members serving on common committees.

**Other likely questions**
- *Directed vs undirected?* Directed edges have a direction (A follows B on Twitter ≠ B follows A).
  Committee co-membership is mutual → undirected.
- *Density?* Edges present / edges possible = `edge_density(g)`; possible = n(n−1)/2 for undirected.
- *Centrality?* How important a node is: degree (connections), betweenness (lies on many shortest paths, a "bridge"),
  closeness (short distance to all), eigenvector (connected to well-connected nodes).
- *Adjacency matrix vs edge list?* Matrix n×n with 1 where an edge exists (simple, memory-heavy);
  edge list = only existing edges (compact, what we used).
- *Bipartite (2-mode) network?* Two kinds of nodes (members and committees). Our member–member network is its
  **projection** onto one mode (1-mode network).
