### How to use **Delta File Copy ** build / release tasks

Delta File Copy will recursively copy a directory from one location to another.  It will ONLY copy files that do not exist in the target or are different than the source.

* Add a new task and select Delta File Copy.

![tfs-cli](https://raw.githubusercontent.com/TotalALM/VSTS-Tasks/master/Tasks/Code%20Analysis/docs/SelectTask.png "Task")

| **Field** | **Information** | **Required** |
| --- | --- | --- |
| Source | Source directory to copy files from | Yes |
| Target | Target directory to copy files into. | Yes |
| Excluded Files | Comma-Delimited list of files to ignore. Example: Example.dll,Example.Data.dll  | No |

![tfs-cli](https://raw.githubusercontent.com/TotalALM/VSTS-Tasks/master/Tasks/Code%20Analysis/docs/Values.png "Values")

Output

![tfs-cli](https://raw.githubusercontent.com/TotalALM/VSTS-Tasks/master/Tasks/Code%20Analysis/docs/Output.png "Ouput")

