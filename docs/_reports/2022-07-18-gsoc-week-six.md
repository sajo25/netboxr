---
layout: post
title:  "Week Six | Docker for netboxr Galaxy tool installation"
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

Docker commands

docker rm -f galaxy
removes instance of container

docker run --name galaxy -it bgruening/galaxy-stable:20.09 bash
creates new instance of container
bgruening/galaxy-stable:20.09 (container) - name of user, project, version
if i wanted to run planemo, i would write planemo instead of bash
-it tells if you want interactive session you can type in

docker exec -it galaxy bash
creates new connection to existing instance


docker commit FIXME_6fdb2b8de2bb bgruening/galaxy-stable:gsoc
docker commit 9c32395cfb39cfdaa2d4e1388f4639ec652151733d4f17850291ff3f6661e4f5 bgruening/galaxy-stable:gsoc

commits existing state (of instance) to container
gsoc - instead of rewriting it, we have a new one

docker run -p 9080:80 -p 9021:21 --name galaxy -it bgruening/galaxy-stable:gsoc bash
number on the left = local computer, number on the right = virtual machine

docker run -d -p 9080:80 -p 9021:21 --name galaxy bgruening/galaxy-stable:gsoc
d - daemon, when you want something to run in the background

docker run -i -t -p 8080:80 bgruening/galaxy-stable:gsoc

127.0.0.1:8080 
-internet and web browsers
local host (everything before colon) - address of computer

        Is the server running on host "localhost" (127.0.0.1) and accepting
        TCP/IP connections on port 5432?
could not connect to server: Cannot assign requested address
        Is the server running on host "localhost" (::1) and accepting
        TCP/IP connections on port 5432?
		
docker stats
what is running and how many resources its taking up


docker rm -f galaxy-planemo; 
docker run --name galaxy-planemo -v /c/Users/s_ara/Desktop/GSoC:/gsoc bgruening/galaxy-stable:gsoc 


docker commit d581ff23cdc986d3be4af370f99e1b8bafbaac14648feee275fb0663c9baa2c0 bgruening/galaxy-stable:gsoc


Changing 'resolution' to 'resolution_parameter'
https://github.com/mil2041/netboxr/commit/b344b4236e7434b7bd5c50a1224299d8266d419d

