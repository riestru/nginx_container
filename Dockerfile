# Используем официальный образ Nginx
FROM nginx:1.24

# Копируем файл конфигурации Nginx
COPY nginx-test.conf /etc/nginx/nginx.conf

# Создаем директорию для логов, если она не существует
RUN mkdir -p /var/log/nginx

# Обновляем инструкцию RUN для создания расширенного скрипта запуска
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'echo "=== Starting nginx container ==="' >> /entrypoint.sh && \
    echo 'echo "PORT variable: ${PORT:-8080}"' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# === Блок для отладки сети ===' >> /entrypoint.sh && \
    echo 'echo "=== Network Debugging: Checking backend connectivity ==="' >> /entrypoint.sh && \
    echo 'echo "Pinging backend at 45.80.228.158"' >> /entrypoint.sh && \
    echo 'ping -c 4 45.80.228.158' >> /entrypoint.sh && \
    echo 'echo ""' >> /entrypoint.sh && \
    echo 'echo "Testing connectivity to backend port 443"' >> /entrypoint.sh && \
    echo 'curl -v --head --connect-timeout 5 https://45.80.228.158:443' >> /entrypoint.sh && \
    echo 'echo "Curl exit code: $?"' >> /entrypoint.sh && \
    echo 'echo "======================================================"' >> /entrypoint.sh && \
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

# Запускаем скрипт при старте контейнера
CMD ["/entrypoint.sh"]
