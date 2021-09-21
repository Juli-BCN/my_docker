# Imagen y Etiquetas
FROM 
LABEL maintainer="JuliBCN <julibcn@gmail.com>"

# Definir variables de entorno
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Dublin
ENV TZ=America/Mexico_City

# Instalar Dependencias y el servidor Web
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN 

# Mensaje de bienvenida
RUN echo 'I am a huge geek that only copy text' > /var/www/html/index.html

# Configurar apache
RUN 

EXPOSE 80/tcp

CMD
