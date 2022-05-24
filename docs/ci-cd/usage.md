# CI/CD

![deploy](../img/deploy.webp)

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


## CI/CD

- Commit
  - Git Hooks(Pre Hooks)
    - Lint
    - Commit Msg
- CI Check Jobs
  - Lint
    - prettier  代码格式化
    - stylelint CSS 格式化
    - eslint    格式检查、代码语法质量检查
      - ESLint Plugin 公共代码配置
    - commitlint 提交消息检查
  - Test 自动化测试
    - Smoking test: 冒烟测试
    - Unit test: 使用 jest 单元测试
    - End to End: 使用 Playwright 进行 UI 自动化测试
  - Quality 使用 SonarQube 检查代码质量
  - Bundle
  - Audit 使用 npm audit 或者 snyk 检查依赖的安全风险
    - 运行npm audit将生成安全漏洞报告，其中包含受影响的程序包名称、漏洞严重性和描述、路径和其他信息，以及应用补丁解决漏洞的命令（如果可用）
    - Snyk 提供功能丰富的 CLI 以及 GitHub 集成。Snyk 在这方面走得更远，除了通知漏洞外，还自动创建新的拉取请求来修复漏洞，因为已知漏洞的补丁已发布。online: <https://snyk.io/test>
    - Greenkeeper 是一项提供实时依赖项更新的服务，它通过始终使用最新和修补过的依赖项版本来保持应用程序更加安全。
  - Container Image: 使用 trivy 扫描容器镜像安全风险
  - Bundle Chunk Size Limit: 使用 size-limit 限制打包体积，打包体积过大则无法通过合并。
  - Performance (Lighthouse CI): 使用 lighthouse CI 为每次 PR 通过 Lighthouse 打分，如打分过低则无法通过合并。
  - Preview -> feature-xxx.x.com 测试预览
- Code Review
  - xxx
- Merge
- CD
  - Production Deploy
    - Deploy
      - Build Assets
        - oss -> cdn
          - no-cache
          - max-age=31536000
    - Rollback

优化点

```md
- webpack
  - contentHash
  - deterministic
  - runtimeChunk
  - splitChunks
  - terser
- HTTP
  - HSTS
  - TLS v1.3
  - OSCP Staping
  - HTTP2
  - gzip/Brotli
```

```yaml
# CI Check Jobs
# 1. env
# 2. install
# 3. 并发检查
#   1. lint
#     1. prettier
#     2. eslint
#     3. stylelint
#     4. commitlint
#   2. test
#     1. unit test
#     2. e2e test
#     3. Codecov
#   3. Quality 代码质量检查 SonarQube
#   4. Audit 依赖安全风险检查 audit/snyk
#   5. Container Image 容器镜像安全风险检查 trivy
# 4. build 构建
#   1. Bundle Chunk Size Limit: 打包体积检查
#   2. Performance 性能检查 Lighthouse CI
# 5. preview 预览
```


## 扩展

- 边缘计算 [envoyproxy](https://www.envoyproxy.io/)
