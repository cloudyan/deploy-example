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

每一家 CICD 产品，都有各自的配置方式，但是总体上用法差不多。我们了解下 CICD 的基本术语

- `Runner`: 用来执行 CI/CD 的构建服务器
- `workflow/pipeline`: CI/CD 的工作流。(在大部分 CI，如 Gitlab 中为 Pipeline，而 Github 中为 Workflow，但二者实际上还是略有不同)
- `job`: 任务，比如构建，测试和部署。每个 `workflow/pipeline` 由多个 `job` 组成


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

### CI

CI 流程

1. Install。依赖安装。
2. Lint。保障统一的代码风格。
3. Test。单元测试。
4. Preview。生成一个供测试人员进行检查的网址。

CI 检测时机

- 功能分支提交后（CI 阶段），进行 Build、Lint、Test、Preview 等，「如未通过 CICD，则无法 Preview，更无法合并到生产环境分支进行上线」
- 功能分支通过后（CI 阶段），合并到主分支，进行自动化部署。

分支提交或PR提交

```yaml
# 当功能分支代码 push 到远程仓库后，进行 CI
on:
  push:
    branches:
      - 'feature/**'

# 或

# 当功能分支代码 push 到远程仓库以及是 Pull Request 后，进行 CI
on:
  pull_request:
    types:
      # 当新建了一个 PR 时
      - opened
      # 当提交 PR 的分支，未合并前并拥有新的 Commit 时
      - synchronize
    branches:
      - 'feature/**'
```

通过 CI，我们可以快速反馈，并促进敏捷迭代。这要求我们使用 Git 时尽早提交以发现问题，以功能小点为单位频繁提交发现问题，也避免合并分支时发现重大冲突。

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
