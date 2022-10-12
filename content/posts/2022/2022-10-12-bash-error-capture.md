---
title: Capture bash command error in file
date: 2022-10-12
description: Run a bash command and capture the error in a text file as well as store the exit code
---
Neat trick to capture STDERR into a text file for the next command but also exit with the preserved exit code after then.

```bash
gradle \
     build \
     2> >(tee error.log >&2)

EXIT_CODE=${PIPESTATUS[0]}

if [[ -s "error.log" ]] && [[ ${EXIT_CODE} -ne 0 ]]
then
  cat error.log  | buildkite-agent annotate --style "error"
fi

exit $EXIT_CODE
```
