---
layout: post
title:  "Week Seven | PR and automated tests for netboxr ToolShed upload"
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

I made a [pull request ](https://github.com/bgruening/galaxytools/pull/1229) following [instructions](https://github.com/bgruening/galaxytools) I found online, but I mistakenly wrote "Add netboxr tool (beta version)" instead of "NetBox (Alpha Testing, Draft Galaxy Tool)".

Steps:
1. I forked (and cloned) the following repository: https://github.com/bgruening/galaxytools
2. I made a new branch named netboxr-beta as per [recommendations](https://github.com/bgruening/galaxytools/blob/6a2deb2f38472a2845123bd54e73b6bd115b3a0b/CONTRIBUTING.md)
3. `git checkout -b netboxr-beta`
4. `push origin netboxr-beta`
5. I copied the [netboxr folder ](https://github.com/mil2041/netboxr/commit/c2be3153b883a7233f00c314899a95cf6e9ab689) I have been working in on VirtualBox to the galaxytools/tools directory
6. `git add -all`
7. `git commit -u -m "Add netboxr tool (beta version)"`
8. `git push origin netboxr-beta`
9. [Pull request](https://github.com/bgruening/galaxytools/pull/1229) (linked previously)

The pull request initiates automated tests, some of which have already failed in the case of the netboxr tool. I still have to look into what the issues are and how they can be fixed. After the tool passes the tests and the PR is merged, it is automatically pushed to the Galaxy Tool Shed, after which it can be installed in every Galaxy instance. Additionally, as far as I understand, a bot will automatically create a Docker container for the tool (as explained in the instructions linked previously).
