---
title: "[BASH] Repeat Build Step"
date: "2020-06-22"
---

When you need to print out YAML build step for multiple environments.

```sh
DEPLOY_ENVS=(staging:account1 staging2:account2)

build_pipeline_step() {
  yaml_orig=$1
  for DEPLOY_ENV in "${DEPLOY_ENVS[@]}"
    do
      IFS=':' read -r -a DEPLOY_ENV_ARRAY <<< "$DEPLOY\_ENV"
      DEPLOY_ENV=${DEPLOY_ENV_ARRAY[0]}
      DEPLOY_ACCOUNT=${DEPLOY_ENV_ARRAY[1]}
      yaml="$(sed "s/DEPLOY_ENV/${DEPLOY_ENV}/g" <<< "$yaml_orig")"
      yaml="$(sed "s/DEPLOY_ACCOUNT/${DEPLOY_ACCOUNT}/g" <<< "$yaml")"
      echo "$yaml"
    done
   echo "  - wait"
}

build_pipeline_step "$(cat <<EOF
  - label: 'DEPLOY_ENV - DEPLOY_ACCOUNT'
    commands: "echo hello DEPLOY_ENV"
EOF
)"
```
