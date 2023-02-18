# 选择一个体积小的镜像 (~5MB)
FROM node:16-alpine as builder

# 设置为工作目录，以下 RUN/CMD 命令都是在工作目录中进行执行
WORKDIR /code

# 单独分离 package.json，是为了安装依赖可最大限度利用缓存
ADD package.json yarn.lock /code/
# 此时，yarn 可以利用缓存，如果 yarn.lock 内容没有变化，则不会重新依赖安装
RUN yarn

ADD . /code

# 安装依赖
RUN yarn build

# 选择更小体积的基础镜像
FROM nginx:alpine
COPY --from=builder code/dist /usr/share/nginx/html
