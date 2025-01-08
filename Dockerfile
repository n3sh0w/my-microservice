FROM golang:1.23.4-alpine AS builder

# Установим необходимые зависимости
RUN apk add --no-cache git

WORKDIR /app

# Копируем и загружаем зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем весь проект
COPY . ./

# Сборка бинарного файла
RUN go build -o main .

# Stage 2: Run stage
FROM alpine:latest

WORKDIR /root/
COPY --from=builder /app/main .

# Открываем порт для сервера
EXPOSE 8080

# Запуск приложения
CMD ["./main"]