# ---- 阶段 1：Node.js 19 编译前端 ----
FROM node:19-alpine AS frontend-builder
WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制前端依赖文件
COPY frontend/package.json ./
COPY frontend/pnpm-lock.yaml ./

# 安装依赖
RUN pnpm install --frozen-lockfile

# 复制前端源码并构建
COPY frontend ./
RUN pnpm build --emptyOutDir

# ---- 阶段 2：Python 3.11-slim 运行后端 ----
FROM python:3.11-slim

# 安装系统依赖（可选，如需编译依赖）
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     build-essential \
#     && rm -rf /var/lib/apt/lists/*

# 复制后端依赖并安装
COPY requirements.txt requirements.txt
RUN python -m pip install --no-cache-dir -r requirements.txt

# 复制后端源码
COPY . /app
WORKDIR /app

# 把阶段1构建好的 dist 复制到 /app/dist
COPY --from=frontend-builder /app/dist /app/dist

EXPOSE 8000
ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]