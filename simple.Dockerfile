# 多阶段构建
# 1. 使用 node 镜像对单页应用进行构建，生成静态资源
# 2. 使用 nginx 镜像对单页应用的静态资源进行服务化

FROM node:16-alpine as builder

WORKDIR /code

# 单独分离 package.json，是为了安装依赖可最大限度利用缓存
COPY package.json yarn.lock /code/
RUN yarn

ADD public /code/public
ADD src /code/src
RUN npm run build

# 选择更小体积的基础镜像
FROM nginx:1.23.0-alpine
COPY --from=builder code/build /usr/share/nginx/html
