---
layout: post
title:  "Week Five | Advanced Galaxy tool development"
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

I've created a more advanced version of the netboxr Galaxy tool with more analysis and output options [(commit)](https://github.com/mil2041/netboxr/commit/73ccc475ded90470c73fce84d704bc4a8a5a8627) that I've tested using the data from the netboxr vignette for a better comparison. Unlike the prototype, the newest version accepts newline-delimited, as opposed to tab-delimited, files as input. Screenshots of the tool interface and output can be found below:

<img width="873" alt="galaxy1" src="https://user-images.githubusercontent.com/28693536/178962816-f7ce4a49-a715-457a-bc98-370f1d022dc1.PNG">
<img width="867" alt="galaxy2" src="https://user-images.githubusercontent.com/28693536/178962849-da159d72-371c-40dd-8be6-e927e746cef4.PNG">
<img width="876" alt="galaxy3" src="https://user-images.githubusercontent.com/28693536/178962869-3ce19131-c2c8-4e74-b84c-a1b996a740fe.PNG">
<img width="873" alt="galaxy4" src="https://user-images.githubusercontent.com/28693536/178962897-cf16838b-0061-4615-8a88-1ecf006fa98c.PNG">
<img width="873" alt="galaxy5" src="https://user-images.githubusercontent.com/28693536/178962930-7e7c0f8b-f473-4c94-83f7-1c874697d3a6.PNG">
<img width="871" alt="galaxy6" src="https://user-images.githubusercontent.com/28693536/178962967-8fc4d926-f214-411c-806f-be4f6627ad1a.PNG">
<img width="872" alt="galaxy7" src="https://user-images.githubusercontent.com/28693536/178962984-d1f5723c-9c2b-4dd0-8030-43828ac75a70.PNG">

During our meeting this week @cannin pointed out that I when I originally made changes to the vignette to make it work without the cgdsr package [(Issue 14)](https://github.com/mil2041/netboxr/issues/14), I introduced a bug where not all the required data (i.e. one table per gene) was used. I fixed this by uploading the four required tables in the inst folder, removing the "vignette_data.txt" file, and changing the code from:

```
dat <- read.table(system.file("vignette_data.txt", package = "netboxr"), header=TRUE, 
                                               sep="\t", stringsAsFactors=FALSE)
```

to:

```
dat <- read.table(system.file(paste("vignette_data_", gene, ".txt", sep = ""), package = "netboxr"), 
                                              header=TRUE, sep="\t", stringsAsFactors=FALSE)
```

This is the [commit](https://github.com/mil2041/netboxr/commit/3066e4e62b5a64eaa62062410edb2b2ceb1f352e) and the most recent GitHub Actions [run](https://github.com/sajo25/netboxr/actions/runs/2672929063) for the above changes.

Changing intput to text (like cutoff value)
Community detection method "lev" doesn't work, figure out why
Netboxr beta/alpha testing draft
Try without virtual environment
Change plotting parameters
Iterations - help
Fix number of genes, find out why
Sink command
How is it running, what is it doing
Resolution not more than 1 
Terminal output text file,
