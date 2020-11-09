---
title: "Default fixed version value when creating an issue in JIRA"
date: "2012-01-24"
---

You can try to add some JavaScript code to the field that will perform required operation for you, in this case it should be 'Fix Version' field. You can refer to this documentation as a guideline:  
[http://confluence.atlassian.com/display/JIRACOM/Using+JavaScript+to+Set+Custom+Field+Values](http://confluence.atlassian.com/display/JIRACOM/Using+JavaScript+to+Set+Custom+Field+Values)

In order to get the ID for the specific version, you need to check the ID from the database. For example, you can run the following SQL query in the database:

SELECT ID, PROJECT, vname FROM projectversion;

Once you found the ID for the specific version (i.e. 'Backlog'), you need to access to the 'Administration' > 'Fields' > 'Field Configuration' and click on the Edit link for the **Fix Version** field. Then, add the following code into the description field on that page:

<script type="text/javascript"\>
if (document.getElementById("fixVersions").value == "")
{ document.getElementById("fixVersions").value = "10005"; }

</script>

Please change the value '10005' to the ID value that you found from the database.
