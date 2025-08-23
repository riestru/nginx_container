FROM nginx:1.24

COPY nginx.conf /etc/nginx/
RUN sed -i 's/\${PORT}/8080/g' /etc/nginx/nginx.conf
RUN mkdir -p /var/log/nginx

RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'if [ ! -z "$PORT" ]; then' >> /entrypoint.sh && \
    echo '  sed -i "s/listen 8080;/listen $PORT;/g" /etc/nginx/nginx.conf' >> /entrypoint.sh && \
    echo 'fi' >> /entrypoint.sh && \
    echo 'nginx -t' >> /entrypoint.sh && \
    echo 'exec nginx -g "daemon off;"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
