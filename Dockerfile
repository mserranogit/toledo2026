FROM nginx:alpine

# Copiar los archivos de la guía estática a Nginx
COPY html/visita-1/ /usr/share/nginx/html/

# Exponer el puerto 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
