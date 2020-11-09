---
title: "[BASH] Repeat Build Step"
date: "2020-06-22"
---

When you need to print out YAML build step for multiple environments.

DEPLOY\_ENVS=(staging:account1 staging2:account2)

build\_pipeline\_step() {
  yaml\_orig=$1
  for DEPLOY\_ENV in "${DEPLOY\_ENVS\[@\]}"
    do
      IFS=':' read -r -a DEPLOY\_ENV\_ARRAY <<< "$DEPLOY\_ENV"
      DEPLOY\_ENV=${DEPLOY\_ENV\_ARRAY\[0\]}
      DEPLOY\_ACCOUNT=${DEPLOY\_ENV\_ARRAY\[1\]}
      yaml="$(sed "s/DEPLOY\_ENV/${DEPLOY\_ENV}/g" <<< "$yaml\_orig")"
      yaml="$(sed "s/DEPLOY\_ACCOUNT/${DEPLOY\_ACCOUNT}/g" <<< "$yaml")"
      echo "$yaml"
    done
   echo "  - wait"
}

build\_pipeline\_step "$(cat <<EOF
  - label: 'DEPLOY\_ENV - DEPLOY\_ACCOUNT'
    commands: "echo hello DEPLOY\_ENV"
EOF
)"
