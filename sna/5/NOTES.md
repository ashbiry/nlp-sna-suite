# SNA Experiment 5 – Tools for Social Network Analysis (theory)

**Aim:** explore five tools used for SNA in different contexts. No code: be ready to describe 5 tools,
compare them, and say which fits which dataset. (Write-up = table below + conclusion.)

## The five to present (manual's choice)
| Tool | What it is | Strengths | Typical use |
|---|---|---|---|
| **UCINet** | Commercial Windows package for SNA (Borgatti, Everett, Freeman) | Huge set of measures: centrality, cohesion, roles, **1-mode and 2-mode** data, matrix algebra, statistics (QAP) | Academic/sociological research on small–medium networks |
| **NetDraw** | Free visualiser shipped with UCINet | Draws UCINet networks; colour/size nodes by attributes; layouts | Visualising UCINet results |
| **Gephi** | Open-source desktop app, **Java** | Interactive visual exploration, ForceAtlas2 layout, modularity **community detection**, filters, handles ~100k nodes; reads CSV, GML, **GraphML**, GEXF | Exploring and presenting networks (social media, citations) |
| **NodeXL** | Network template add-in for **Microsoft Excel** | No coding; enter edges in a sheet; can import Twitter/YouTube/Flickr data (Pro); metrics + graph pane | Beginners, business users, social-media network analysis |
| **Kumu** | Web-based (browser) platform | Beautiful interactive maps, collaboration, shareable links, "systems mapping" | Stakeholder maps, systems thinking, presentations |

## The others (for "which tool for…" questions)
- **Pajek** – Windows program for **very large networks** (millions of nodes); fast, specialised (Slovenian, "spider").
- **SocNetV (Social Networks Visualizer)** – free, open-source, cross-platform GUI; easy for learning; can crawl web links.
- **Cytoscape** – open-source, from **bioinformatics** (protein/gene interaction networks); plugin "apps".
- **graph-tool** – **Python** module with C++ core: very fast statistics and visualisation on large graphs.
- **Polinode** – web tool for organisational network analysis; collects network data with surveys.
- Code libraries (what we used): **igraph** (R/Python/C), **ggraph** (R), **NetworkX** (Python).

**Quick answers:** Excel-integrated → **NodeXL**. Large networks → **Pajek** (also graph-tool, Gephi).
Biology → **Cytoscape**. Visualisation with UCINet → **NetDraw**. Java open-source visual tool → **Gephi**.
Web/collaborative maps → **Kumu**. Survey-based data collection → **Polinode**.

## Core concepts the tools compute (be ready to define)
- **Nodes and edges**; directed/undirected; weighted.
- **Degree centrality** (number of connections), **betweenness** (how often a node lies on shortest paths – a broker/bridge),
  **closeness** (how near a node is to all others), **eigenvector/PageRank** (connected to important nodes).
- **Density** = actual edges / possible edges. **Path length / diameter.** **Clustering coefficient** (friends of friends are friends).
- **Community detection** = finding groups more connected inside than outside (modularity, Louvain).
- **1-mode vs 2-mode:** 1-mode = one type of node (members); 2-mode/bipartite = two types (members–committees).
- **Network visualisation:** drawing nodes/edges with layouts (force-directed: Fruchterman–Reingold, ForceAtlas2), colour/size by attributes.

## Link to our practicals
Experiment 1's graph can be opened in Gephi: in R `write_graph(g3, "congress.graphml", format = "graphml")`,
then Gephi → File → Open → congress.graphml → Layout: ForceAtlas2 → Statistics: Modularity → colour by community.

## Viva (manual questions)
1. **SNA?** Studying social structures through networks: nodes (actors) and edges (relationships), using graph theory
   to find important actors, groups and patterns.
2. **UCINet?** Comprehensive software for analysing social network data, including 1-mode and 2-mode data.
3. **NetDraw?** A tool, usually used with UCINet, to visualise networks.
4. **Gephi?** Open-source network analysis and visualisation software written in Java.
5. **NodeXL?** Free/open-source network analysis and visualisation template for Microsoft Excel.
6. **Kumu?** Web-based visualisation platform for mapping systems and relationships.
7. **Network visualisation?** Graphical representation of nodes and edges to reveal structure (clusters, hubs, bridges).
8. **Nodes and edges?** Nodes = entities (people, pages); edges = relationships/interactions between them.
9. **Excel-integrated tool?** NodeXL.  10. **For large datasets?** Pajek (also graph-tool / Gephi).

## Conclusion (write this)
Five SNA tools – UCINet, NetDraw, Gephi, NodeXL and Kumu – were studied. UCINet provides comprehensive statistical
analysis, NetDraw and Gephi provide visualisation (Gephi also community detection on larger networks), NodeXL brings
network analysis into Excel, and Kumu offers web-based collaborative mapping. The choice depends on data size,
need for statistics vs visualisation, and the user's environment.
