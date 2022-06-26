---
layout: post
title:  "Week Two | Fixing remaining GitHub Actions bugs, detailed plan for Galaxy tool interface"
tags: gsoc
author: Sara J
---

**Tasks**

1. **[Fix remaining GitHub Actions bugs](https://github.com/mil2041/netboxr/issues/7)**
    Status: **In progress**
    Branch: **None**
        PR: **None**
        
      1a. [Add tests to netboxr for existing examples](https://github.com/mil2041/netboxr/issues/22)

      1b. [The Date field is over a month old](https://github.com/mil2041/netboxr/issues/21)

      1c. [Use of orphaned gtools?](https://github.com/mil2041/netboxr/issues/19)

      1d. [Non-Standard Files Found](https://github.com/mil2041/netboxr/issues/18)

      1e. [Example Taking Too Long](https://github.com/mil2041/netboxr/issues/17)

      1f. [Fix: Namespace in Imports field not imported from: 'gtools'](https://github.com/mil2041/netboxr/issues/16)
        
2. **Make detailed plan for Galaxy tool interface**
    Status: **In progress**
    Branch: **None**
    PR: **None** 
        
3. **Meeting with supervisors**
    Status: **Thursday**
    Branch: **None**
    PR: **None**


Load Human Interactions Network (HIN) network
Load altered gene list
Map altered gene list on HIN network
- Implemented option for different community discovery methods and resolution
- Implemented option for multiple outputs (community membership, node type, etc.)
- Implemented statistical analysis options

Alternative Module Discovery Methods
Statistical Significance of Discovered Network
    Global Network Null Model
    Local Network Null Model
Write NetBox Output to Files
Term Enrichment in Modules using Gene Ontology (GO) Analysis
Alternative Pathway Data   
    Using Tabular Simple Interaction Format (SIF)-Based Network Data
    Using PaxtoolsR for Pathway Commons Data
Selecting Input Gene Lists for use with NetBox

**Remaining tasks**
- Writing examples/tests for Louvain and Leiden community detection methods, and resolution and weights parameters
- Does R output show up anywhere on Galaxy? 
- Cutoff value - selected via drop-down menu, slider? How many options

**Discussion points for next meeting**
- What should the input options for the Galaxy tool be? Give multiple options vs force specific format? 
- 
- How would the input change if the list of genes is generated using method described in vignette (cgdsr package)?
- Plotting for local network null model - histogram?
- Should we also generate a meta file containing summary of selected parameteers and R (console) output? What else would that file contain?
- Separate options T/F for analysis and plots? Eg. local null model



