# Multi-stage build para React
FROM node:18-alpine AS build

WORKDIR /app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm ci --only=production

# Copiar código fonte
COPY . .

# Build da aplicação
RUN npm run build

# Estágio final - apenas para copiar os arquivos buildados
FROM alpine:latest AS final

WORKDIR /app

# Copiar arquivos buildados
COPY --from=build /app/build ./build

# Este container é usado apenas para copiar os arquivos
# Os arquivos serão servidos pelo Nginx
CMD ["echo", "Build completed"]

