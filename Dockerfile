# Используем официальный образ Nginx
FROM nginx:1.24

# Копируем файл конфигурации Nginx
COPY nginx-test.conf /etc/nginx/nginx.conf

# Создаем директорию для логов, если она не существует
RUN mkdir -p /var/log/nginx

# Создаем скрипт запуска в одном многострочном блоке RUN
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'echo "=== Запуск контейнера Nginx ==="' >> /entrypoint.sh && \
    echo 'echo "Переменная PORT: ${PORT:-8080}"' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# === НАЧАЛО: Блок отладки сети ===' >> /entrypoint.sh && \
    echo 'echo "=== Отладка сети: Проверка подключения к бэкенду ==="' >> /entrypoint.sh && \
    echo 'echo "--- Пинг бэкенда по адресу 45.80.228.158 ---"' >> /entrypoint.sh && \
    echo 'ping -c 4 45.80.228.158 || echo "Пинг не удался с кодом завершения: $?"' >> /entrypoint.sh && \
    echo 'echo "--- Пинг завершен ---"' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo 'echo "--- Проверка подключения к порту бэкенда 443 с помощью curl ---"' >> /entrypoint.sh && \
    echo 'curl -v --head --connect-timeout 5 https://45.80.228.158:443 2>&1' >> /entrypoint.sh && \
    echo 'CURL_EXIT_CODE=$?' >> /entrypoint.sh && \
    echo 'echo "--- Curl завершился с кодом: $CURL_EXIT_CODE ---"' >> /entrypoint.sh && \
    echo 'echo "======================================================"' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo '# === КОНЕЦ: Блок отладки сети ===' >> /entrypoint.sh && \
    echo '# Если PORT задан, заменяем порт в конфигурации' >> /entrypoint.sh && \
    echo 'if [ ! -z "$PORT" ]; then' >> /entrypoint.sh && \
    echo '  echo "Изменение порта с 8080 на $PORT"' >> /entrypoint.sh && \
    echo '  sed -i "s/listen 8080;/listen $PORT;/g" /etc/nginx/nginx.conf' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo 'echo "Проверка конфигурации Nginx..."' >> /entrypoint.sh && \
    echo 'nginx -t' >> /entrypoint.sh && \
    echo '' >> /entrypoint.sh && \
    echo 'echo "Запуск Nginx..."' >> /entrypoint.sh && \
    echo 'exec nginx -g "daemon off;"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Запускаем скрипт при старте контейнера
CMD ["/entrypoint.sh"]
