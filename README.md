Steps to upload Galaxy tool to ToolShed:

0. Read [zinstructions](https://github.com/bgruening/galaxytools)
1. Fork (and clone) one of the galaxytools repositories mentioned in [instructions](https://github.com/bgruening/galaxytools)
2. Make a new branch named after your tool as per [recommendations](https://github.com/bgruening/galaxytools/blob/6a2deb2f38472a2845123bd54e73b6bd115b3a0b/CONTRIBUTING.md)
3. `git checkout -b branch-name`
5. Copy and paste tool development folder to the galaxytools/tools directory
6. `git add -all`
7. `git commit -u -m "message"`
8. `git push origin branch name`

Then, make a pull request. The pull request initiates automated tests. Additionally, the repository owner may give you feedback on what changes need to be made before the PR can be merged. After the tool passes the tests and the PR is merged, it is automatically pushed to the Galaxy ToolShed, after which it can be installed in every Galaxy instance.
