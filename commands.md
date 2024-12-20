
SSM을 이용한 ec2 접속방법

```
aws ssm start-session --target i-0a5a7e42b0be264fe --document-name AWS-StartInteractiveCommand --parameters command="bash"
```