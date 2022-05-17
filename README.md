# deploy

前端部署

```bash
docker-compose up --build simple

# 强制重建容器，最新版 desktop docker 无需配置 --force-recreate
docker-compose up --build --force-recreate simple
```

最终的 `PUBLIC_URL` 为 `$Bucket.$Endpoint`

## 关于 traefik

- https://docs.traefik.cn/
- https://doc.traefik.io/traefik/

```bash
cd ./traefik

docker-compose up
```

## CI/CD

- [Events that trigger workflows](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/events-that-trigger-workflows#about-workflow-events)


```yaml
# 仅仅当 master 代码发生变更时，用以自动化部署
on:
  push:
    branches:
      - master

# 仅当 feature/** 分支发生变更时，进行 Preview 功能分支部署 (见 Preview 篇)
on:
  pull_request:
    types:
      # 当新建了一个 PR 时
      - opened
      # 当提交 PR 的分支，未合并前并拥有新的 Commit 时
      - synchronize
    branches:
      - 'feature/**'

# 在每天凌晨 0:30 处理一些事情，比如清理多余的 OSS 资源，清理多余的功能分支 Preview (见 Preview 篇)
on:
  schedule:
    - cron:  '30 8 * * *'
```


## 常见问题

```bash
# 列举出所有容器的标签信息
$ curl --unix-socket /var/run/docker.sock http:/containers/json | jq '.[] | .Labels'
```

报错

```bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    29    0    29    0     0  10772      0 --:--:-- --:--:-- --:--:-- 14500
jq: error (at <stdin>:1): Cannot index string with string "Labels"
```

文档：

- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Compose file Reference](https://docs.docker.com/compose/compose-file/compose-file-v3/)
- Github
  - [Github Actions](https://github.com/features/actions)
    - [Github Actions 配置](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions)
    - [Adding self hosted runners](https://docs.github.com/cn/actions/hosting-your-own-runners/adding-self-hosted-runners)
    - [Events that trigger workflows](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/events-that-trigger-workflows#about-workflow-events)
  - [Managing a branch protection rule](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule)
- Gitlab
  - [Gitlab CICD Workflow](https://docs.gitlab.com/ee/ci/introduction/index.html#basic-cicd-workflow)
  - [Gitlab CI 配置](https://docs.gitlab.com/ee/ci/yaml/gitlab_ci_yaml.html)
  - [Merge when pipeline succeeds](https://docs.gitlab.com/ee/user/project/merge_requests/merge_when_pipeline_succeeds.html)
