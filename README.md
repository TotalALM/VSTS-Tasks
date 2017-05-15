### How to use **Custom** build / release tasks

Follow the below steps to upload this task to your account:

* Download the tasks repo as [zip file] or clone it using git:
* Extract the zip file of the desired task
* Open command prompt and navigate to the folder that contains a json and powershell files.

## License
These tasks leverage the Apache 2.0 License.  Details can be found [here](https://www.apache.org/licenses/LICENSE-2.0.html)

## Install / Upload Custom Task

*Follow instructions on how to upload the task using - https://github.com/Microsoft/tfs-cli/blob/master/docs/buildtasks.md or use the below instructions.

* Install ```tfx-cli``` utility
```
> npm install -g tfx-cli
```
* To avoid providing credentials in every command, you can login once. Currently supported credential types are Personal Access Tokens and basic auth. [Create a personal access token](http://roadtoalm.com/2015/07/22/using-personal-access-tokens-to-access-visual-studio-online) and paste it in the login command
```
> tfx login
Copyright Microsoft Corporation
Enter collection url > https://youraccount.visualstudio.com/DefaultCollection
Enter personal access token >
logged in successfully
```
You can alternatively use basic auth by passing ```--authType basic``` (read [Configuring Basic Auth](https://github.com/Microsoft/tfs-cli/blob/master/docs/configureBasicAuth.md)).
* Upload the task to your account:
```
> tfx build tasks upload --task-path ./task
```
* Once the task is uploaded, you would be able to view your task under the build or release.
