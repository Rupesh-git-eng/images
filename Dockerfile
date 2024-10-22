FROM quay.io/fedora/fedora

RUN yum install nginx -y && yum clean all

#COPY ./nginx.conf /etc/nginx/nginx.conf

#ADD https://github.com/Rupesh-git-eng/images/blob/main/nginx.conf

# Remove default welcome page
#RUN rm /usr/share/nginx/html/index.html

# 1. support running as arbitrary user which belogs to the root group
# 2. users are not allowed to listen on priviliged ports
# 3. comment user directive as master process is run as user in OpenShift anyhow
RUN chmod g+rwx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chmod g+rwx /var/run/nginx.pid
RUN sed 's/80/8080/g'  /etc/nginx/nginx.conf 
RUN sed '/types_hash_max_size/a \ \   set_real_ip_from 0.0.0.0/0;' /etc/nginx/nginx.conf
RUN sed '/types_hash_max_size/a \ \   real_ip_recursive on;' /etc/nginx/nginx.conf 
RUN sed '/types_hash_max_size/a \ \   real_ip_header X-Forwarded-For;' /etc/nginx/nginx.conf

EXPOSE 8080

USER nginxuser

CMD ["nginx", "-g", "daemon off;"]
