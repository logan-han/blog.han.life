---
title: "Query of the century"
date: "2015-02-05"
description: "One Postgres transaction that swaps a table for a freshly loaded copy: CREATE TABLE LIKE, COPY, two renames and a drop."
tags: ["postgres", "databases"]
---

My co-worker showed me this today and it's just gorgeous.

`BEGIN; CREATE TABLE xyz_tmp (LIKE xyz INCLUDING ALL); COPY xyz_tmp FROM STDIN; ALTER TABLE xyz RENAME TO xyz_old; ALTER TABLE xyz_tmp RENAME TO xyz; DROP TABLE xyz_old; COMMIT;`
