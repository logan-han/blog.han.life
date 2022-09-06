---
title: Lookup CMK for a test in CDK
date: 2022-09-06
description: How to lookup dynamic CMK resource name in TS CDK

---
Add a CMK in CDK was easy, then when I looked into a way to reference the resource using `findResources`, faced constant failure as for some reason CDK can't really pickup the key based on the alias. 

Apparently quite a few people had the same issue and settled with somewhat sticky hardcoded name, only one example in github was 'properly' handle this by making fairly complex cross reference structure. 

Then my coworker actually found out we can point the statement attached to the key then lock it down via sid. (MAGIC HACK!)

Create the key:
```typescript
    const key = new kms.Key(this, 'test', {
    alias: `${env}-test`,
    policy: new iam.PolicyDocument({
        statements: [
            new iam.PolicyStatement({
                actions: ['kms:*'],
                resources: ['*'],
                sid: '${env}-test'
            })
        ]
    })
})
```

Then the test can look this up like:
```typescript
  const key = template.findResources('AWS::KMS::Key', {
    Properties: {
      KeyPolicy: {
        Statement: [
          {
            Action: ['kms:*'],
            Effect: 'Allow',
            Resource: '*',
            Sid: '${env}-test'
          }
        ]
      }
    }
  })
```
