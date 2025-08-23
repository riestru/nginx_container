FROM nginx:alpine

# Устанавливаем envsubst для подстановки переменных окружения
RUN apk add --no-cache gettext

# Копируем шаблон конфигурации nginx
COPY nginx.conf /etc/nginx/nginx.conf.template

# Создаем директорию для логов
RUN mkdir -p /var/log/nginx

# Создаем скрипт запуска
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf' >> /start.sh && \
    echo 'exec nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

# Переменная PORT будет задана автоматически Serverless Containers
EXPOSE $PORT

# Запускаем через скрипт, который подставит переменные окружения
CMD ["/start.sh"]
