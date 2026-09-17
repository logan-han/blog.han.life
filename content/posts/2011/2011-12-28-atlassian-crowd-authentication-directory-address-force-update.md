---
title: "Atlassian crowd authentication directory address force update"
date: "2011-12-28"
description: "Crowd keeps its directory config in the database, so a migrated Jira or Confluence needs a SQL update to point at the new Crowd URL."
tags: ["atlassian", "databases"]
---

When you migrate atlassian product (confluence, jira etc etc) to somewhere else, your backup file includes fixed crowd address which is not gonna work for some cases.  
  
Since Atlassian moved directory configuration from fixed config file to database,  
you will need to execute following:  
  

update cwd\_directory\_attribute set attribute\_value = 'http://crowd:8095/crowd/' where attribute\_name = 'crowd.server.url';
