Facebook Fan Page Archiver

Public Domain
Last modified 5/13/2011

Summary:
This PowerShell script was created as a way to retain a record of all posts and comments published to a Facebook fan page wall.  The data is saved in JSON files which are human readable.  No effort to de-duplicate data is made.

Facebook Setup:
1)  Create a Facebook account (you may use an existing account)
2)  Log in to Facebook and create a new fan page (you may use an existing fan page)
3)  Record the fan page ID which can be found at the end of the initial URL to your page
(e.g. http://www.facebook.com/?ref=home#!/pages/pagename/1359943364218674)
Go to http://www.facebook.com/developers/ and click the [Allow] button to allow the Facebook developer application access to your Facebook account basic information
4)  Create a new application by clicking [+ Set Up New Application]
5)  Enter an Application Name, select Agree (to the terms),  and click [Create Application]
Note: you may receive a 404 or 500 error message.  Your application will be created regardless of error messages.
6)  Go back to http://www.facebook.com/developers/ and click on the new application you just created.  It will appear under the My Applications section.
7)  Record the Application ID and Application Secret (to be entered into the PowerShell script later)

Script Configuration:
8)  Edit the PowerShell script and find the first five script lines (below the comments).
9)  Change the string value $source_id of 'TODO' to contain your fan page id from step 1.
10) Change the string value $app_id of 'TODO' to contain your Application ID from step 7.
11) Change the string value $app_secret of 'TODO' to contain your Application Secret from step 7.
12) Change the string value $path of 'TODO' to folder where you want the JSON files saved.
13) Change the integer value $minutesback of 60 * 24 * to specify how many minutes back to check for posts/comments.

Schedule Script Execution:
At this point you can run the script manually or setup a scheduled task.  The following instructions define that process.
14) Create a new Scheduled Task
15) TODO
