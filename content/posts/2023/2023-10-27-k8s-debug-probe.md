---
title: Run a debug prob in a kubernetes cluster with gatekeeper
date: 2023-10-27
description: Workaround when kubectl debug command is blocked

---
When attempting to run `kubectl debug <node> -it --image=<image>` blocked due to gatekeeper, you can do about the same with normal `kubectl run` command like below:

`kubectl run logan-tmp-shell --rm -i --tty --image <image>`

to attach a service account with it:

`kubectl run logan-tmp-shell --rm -i --tty --overrides='{ "spec": { "serviceAccount": "<service-account>" }  }' --image <image>`

then it will work with awscli without any extra authentication steps. 
