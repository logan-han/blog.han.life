---
title: "delete mplayerx history"
date: "2011-12-30"
description: "Clearing the MPlayerX recent files list from the macOS terminal with defaults delete, and stopping it recording history at all."
tags: ["apple"]
---

http://code.google.com/p/mplayerx/issues/detail?id=517  
  

launch Terminal, and use the command to clear the history - tested.

defaults delete org.niltsh.MPlayerX.LSSharedFileList RecentDocuments

prevent history being created, not tested
defaults write org.niltsh.MPlayerX NSRecentDocumentsLimit 0
