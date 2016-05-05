### How to use **Delta File Copy ** build / release tasks

Delta File Copy will recursively copy a directory from one location to another.  It will ONLY copy files that do not exist in the target or are different than the source.

Install from the Marketplace 

Marketplace - https://marketplace.visualstudio.com/items?itemName=TotalALM.totalalm-deltafilecopy

OR

Follow the below steps to upload this task to your account:

* Download the tasks repo as [zip file] or clone it using git: 
* Extract the zip file of the desired task
* Open command prompt and navigate to the folder that contains a json and powershell files.

## Install / Upload Custom Task

*Follow instructions on how to upload the task using - https://github.com/TotalALM/VSO-Tasks

How To Use

* Add a new task and select Delta File Copy.

![tfs-cli](https://raw.githubusercontent.com/TotalALM/VSTS-Tasks/master/Tasks/Delta%20File%20Copy/docs/SelectTask.png "Task")

| **Field** | **Information** | **Required** |
| --- | --- | --- |
| Source | Source directory to copy files from | Yes |
| Target | Target directory to copy files into. | Yes |
| Excluded Files | Comma-Delimited list of files to ignore. Example: Example.dll,Example.Data.dll  | No |

![tfs-cli](https://raw.githubusercontent.com/TotalALM/VSTS-Tasks/master/Tasks/Delta%20File%20Copy/docs/Values.png "Values")

Output

![tfs-cli](https://raw.githubusercontent.com/TotalALM/VSTS-Tasks/master/Tasks/Delta%20File%20Copy/docs/Output.png "Ouput")

