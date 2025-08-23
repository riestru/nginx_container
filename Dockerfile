FROM nginx:1.24

# Копируем простую конфигурацию
COPY nginx-simple.conf /etc/nginx/nginx.conf

# Создаем директорию для логов
RUN mkdir -p /var/log/nginx

# Создаем простой скрипт запуска
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'echo "=== Starting nginx container ==="' >> /entrypoint.sh && \
    echo 'echo "PORT variable: ${PORT:-8080}"' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# Если PORT задан, заменяем порт в конфигурации' >> /entrypoint.sh && \
    echo 'if [ ! -z "$PORT" ]; then' >> /entrypoint.sh && \
    echo '  echo "Changing port from 8080 to $PORT"' >> /entrypoint.sh && \
    echo '  sed -i "s/listen 8080;/listen $PORT;/g" /etc/nginx/nginx.conf' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo 'echo "Testing nginx configuration..."' >> /entrypoint.sh && \
    echo 'nginx -t' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo 'echo "Starting nginx..."' >> /entrypoint.sh && \
    echo 'exec nginx -g "daemon off;"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
