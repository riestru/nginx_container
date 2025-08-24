# Используем официальный образ Nginx
FROM nginx:1.24

# Копируем файл конфигурации Nginx
COPY nginx-test.conf /etc/nginx/nginx.conf

# Создаем директорию для логов, если она не существует
RUN mkdir -p /var/log/nginx

# Создаем исполняемый скрипт entrypoint.sh с помощью heredoc в одном блоке RUN
RUN cat << 'EOF' > /entrypoint.sh \
&& chmod +x /entrypoint.sh
#!/bin/bash
echo "=== Запуск контейнера Nginx ==="
echo "Переменная PORT: ${PORT:-8080}"
echo ""

# === НАЧАЛО: Блок отладки сети ===
echo "=== Отладка сети: Проверка подключения к бэкенду ==="
echo "--- Пинг бэкенда по адресу 45.80.228.158 ---"
ping -c 4 45.80.228.158 || echo "Пинг не удался с кодом завершения: $?"
echo "--- Пинг завершен ---"
echo ""

echo "--- Проверка подключения к порту бэкенда 443 с помощью curl ---"
curl -v --head --connect-timeout 5 https://45.80.228.158:443 2>&1
CURL_EXIT_CODE=$?
echo "--- Curl завершился с кодом: $CURL_EXIT_CODE ---"
echo "======================================================"
echo ""
# === КОНЕЦ: Блок отладки сети ===

# Если PORT задан, заменяем порт в конфигурации
if [ ! -z "$PORT" ]; then
  echo "Изменение порта с 8080 на $PORT"
  sed -i "s/listen 8080;/listen $PORT;/g" /etc/nginx/nginx.conf
fi
echo ""

echo "Проверка конфигурации Nginx..."
nginx -t
echo ""

echo "Запуск Nginx..."
exec nginx -g "daemon off;"
EOF

# Запускаем скрипт при старте контейнера
CMD ["/entrypoint.sh"]
