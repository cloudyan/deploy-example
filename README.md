# deploy

前端部署

```bash
docker-compose up --build simple

# 强制重建容器，最新版 desktop docker 无需配置 --force-recreate
docker-compose up --build --force-recreate simple
```

最终的 PUBLIC_URL 为 $Bucket.$Endpoint
