---
layout: post
title:  "Week Four | Netboxr tests and Galaxy tool development"
tags: gsoc
author: Sara J
---

## Tasks
        
1. **Work on Galaxy tool development**
    Status: **In progress**
    Branch: **None**
    PR: **None** 
    
2. **Study Galaxy tool deployment**
    Status: **In progress**
    Branch: **None**
    PR: **None** 
             
3. **Meeting with supervisors**
    Status: **Thursday**
    Branch: **None**
    PR: **None** 


## Progress report

Though I originally intended to use the updated R and XML files, I instead chose to build the very first Galaxy tool prototype using the code I submitted as part of the GSoC proposal (as @cannin and @mil2041 advised during our meeting last week). The steps of my work are detailed below.

```
source activate netboxr-env
```

```
git clone https://github.com/gallardoalba/galaxytools
cd galaxytools/tools
mkdir netboxr
cd netboxr
```

I populated the directory with the required files (XML file, R file, tool configuration file, test directory). Then, working in this directory, I ran the command `planemo lint`, which helped me debug and improve the XML code, after which I was eventually able to run the tool on a local Galaxy instance using the command `planemo serve`. Screenshots of the netboxr tool interface can be found below. 

<img width="703" alt="galaxy1" src="https://user-images.githubusercontent.com/28693536/177162063-7cad0b1f-a9ff-4818-8c67-78dbbf1f52ce.PNG">
<img width="704" alt="galaxy2" src="https://user-images.githubusercontent.com/28693536/177162090-b9aa8af1-e66b-4f40-adee-7807bffad3cf.PNG">

Though I still need to refine the tool interface, it contains all necessary elements required for a basic netboxr analysis. However, when attempting to run an analysis for the genes EGFR and TP53 and a cutoff p-value of 0.05, the analysis never completes and the tool eventually stops responding. 

<img width="704" alt="galaxy3" src="https://user-images.githubusercontent.com/28693536/177162110-469b2762-6c1e-446c-9b38-9883e35ae19f.PNG">
<img width="704" alt="galaxy4" src="https://user-images.githubusercontent.com/28693536/177162131-227eb921-c007-47dd-b27c-abb23c51d3bb.PNG">

Using the command `planemo test` I initiated a test that provided more insight into why the tool published on the local Galaxy doesn't run properly. Namely, it appears that the tool dependencies would not get installed, the debugging continued indefinitely, and the terminal would eventually stop responding. 

I eventually resolved the issue by installing the dependencies using conda separately from running `planemo serve` and `planemo test`. This also failed multiple times and may be an issue again later on, but I am able to run the tool for now and obtain the expected output, as shown in the screenshots below.

<img width="704" alt="Capture1" src="https://user-images.githubusercontent.com/28693536/177645815-bac9327b-633d-4671-9a62-791b41465a0e.PNG">
<img width="704" alt="capture2" src="https://user-images.githubusercontent.com/28693536/177645819-d94c60bf-95e1-432b-bc93-8437aaa5d364.PNG">
<img width="704" alt="capture3" src="https://user-images.githubusercontent.com/28693536/177645832-def1fb82-c6e5-41ed-bcc4-1a36e16016fc.PNG">
