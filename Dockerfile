FROM nginx:1.24-alpine3.18

# Простая конфигурация для тестирования
RUN cat > /etc/nginx/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}
http {
    server {
        listen 8080;
        location /health {
            return 200 "OK\n";
            add_header Content-Type text/plain;
        }
        location / {
            return 200 "Hello from Serverless Container\n";
            add_header Content-Type text/plain;
        }
    }
}
EOF

# Убираем daemon режим
CMD ["nginx", "-g", "daemon off;"]
