server {
  listen 3035;

  location / {
    root {{ nginx_vhost_dir }};
    include /etc/nginx/mime.types;
    try_files $uri $uri/ index.html;
  }
}
