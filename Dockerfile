FROM nginx:1.24-alpine3.18

# Устанавливаем envsubst для подстановки переменных окружения
RUN apk add --no-cache gettext

# Копируем шаблон конфигурации nginx
COPY nginx.conf /etc/nginx/nginx.conf.template

# Создаем директорию для логов
RUN mkdir -p /var/log/nginx

# Создаем скрипт запуска с отладкой
RUN cat > /start.sh << 'EOF'
#!/bin/sh
set -e

echo "Starting container..."
echo "PORT environment variable: $PORT"

# Проверяем, что PORT задан
if [ -z "$PORT" ]; then
    echo "ERROR: PORT environment variable is not set"
    echo "Available environment variables:"
    env | grep -E "(PORT|YANDEX)" || echo "No PORT/YANDEX variables found"
    exit 1
fi

echo "Substituting environment variables in nginx config..."
envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Testing nginx configuration..."
nginx -t

echo "Starting nginx..."
exec nginx -g "daemon off;"
EOF

RUN chmod +x /start.sh

# Запускаем через скрипт, который подставит переменные окружения
CMD ["/start.sh"]
