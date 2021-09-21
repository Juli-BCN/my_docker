# my_docker

Example to do a Docker container with just a Dockerfile

## Verificación de Docker
Si utilizamos herramientas como GitPod, los binarios de Docker vienen pre-instalados, por lo que podremos usarlos directamente. Docker tiene dos comandos informativos para ver qué versión está instalada (`docker --version`) y una salida más detallada con mucha información (`docker info`):
> docker --version

> docker info


## Dockerfile
Un Dockerfile es un archivo de texto plano que contiene una serie de instrucciones necesarias para crear una imagen que, posteriormente, se convertirá en una sola aplicación utilizada para un determinado propósito.

Dentro de un archivo Dockerfile algunos de los comandos que se pueden ejecutar son:
1) `FROM  <imagen>` o `FROM  <imagen>:<tag>` --> indica la imagen sobre la que se construirá la aplicación dentro del contenedor
    * La imagen puede ser un sistema operativo como Ubuntu, Amazon Linux, Debian, Alpine, etc., o bien imagenes que tienen alguna aplicación pre-instalada como Nginx, Terraform o Tomcat
2) `ENV` --> establece variables de entorno para nuestro contenedor, en este caso la variable de entorno es `DEBIAN_FRONTEND noninteractive`, el cual nos permite instalar un montón de archivos .deb sin tener que interactuar con ellos. La sintaxis es:
    * `ENV <key><valor>`
    * `ENV MI_VAR mi-valor`
3) `RUN` --> permite ejecutar comandos en el contenedor, por ejemplo, instalar paquetes o librerías (apt-get, yum install, etc.). Además, tenemos dos formas de colocarlo:
    * `RUN <comando>`
    * `RUN ["ejecutable","parametro1","parametro2"]`
        * Esta instrucción es bastante útil porque permite ejecutar comandos en imágenes que no tengan /bin/sh
4) `COPY` --> copia archivos del directorio donde se encuentra `Dockerfile` al contenedor
    * `COPY hola.* /mi_directorio/`
        * con el flag `ADD --chown` se pueden especificar permisos
5) `ADD` --> copia nuevos archivos, nuevos directorios o archivos remotos desde una URL desde un directorio origen a uno destino. Sintaxis:
    * `ADD hola.txt /mi_directorio/`
        * con el flag `ADD --chown` se pueden especificar permisos
6) `WORKDIR` --> establece el directorio de trabajo para cualquier comando `RUN`, `CMD`, `ENTRYPOINT`, `COPY` o `ADD`
7) `ARG` --> define una variable que los usuarios pueden pasar durante la creacion del contenedor usando el flag `--build-arg <varname>=<value>`. Existen ARGs automáticas en cada plataforma, como son:
    * TARGETPLATFORM - plataforma del contenedor resultado: linux/amd64, linux/arm/v7, windows/amd64, etc.
    * TARGETOS - componente de sistema operativo de TARGETPLATFORM
    * TARGETARCH - componente de arquitectura de TARGETPLATFORM
    * TARGETVARIANT - componente de variante de TARGETPLATFORM
    * BUILDPLATFORM - plataforma del node que ejecuta la creación
    * BUILDOS - componente de sistema operativo de BUILDPLATFORM
    * BUILDARCH - componente de arquitectura de BUILDPLATFORM
    * BUILDVARIANT - componente de variante de BUILDPLATFORM
    * Hay algunas ARGs predefinidas:
        * `HTTP_PROXY`
        * `HTTPS_PROXY`
        * `FTP_PROXY`
        * `NO_PROXY`
            * `ENV` siempre sobrescribe `ARG`
8) `ENTRYPOINT` --> permite configurar un contenedor que correrá como un ejecutable. Tiene la desventaja de iniciarse como un sub-comando de `/bin/sh -c`. Tenemos dos formas de usarlo:
    * `ENTRYPOINT ["ejecutable","parametro1","parametro2"]`
    * `ENTRYPOINT comando parametro1 parametro2`
9) `CMD` --> solo puede haber un `CMD` en cada `Dockerfile` y proporciona los argumentos por defecto para la ejecución de un contenedor. Se puede usar de tres maneras:
    * `CMD ["ejecutable","parametro1","parametro2"]` --> forma EXEC
    * `CMD ["parametro1","parametro2"]` --> forma ENTRYPOINT
    * `CMD comando parametro1 parametro2` --> forma SHELL
10) `LABEL` --> agrega metadata a la imagen con un formato "clave"="valor" ("key"="value")
    * `LABEL maintainer="JuliBCN <julibcn@gmail.com>"`
    * `LABEL version="1.0"`
    * `LABEL description="Esta es una buena descripcion de Docker"`
        * La instrucción antigua `MAINTAINER` ya no es válida y no se puede usar
11) `EXPOSE` --> informa a Docker que el contenedor va a escuchar en puertos específicos de red durante la ejecución. Pueden usar protocolos TCP o UDP. Se pueden poner mas de uno por contenedor:
    * `EXPOSE 80/tcp`
    * `EXPOSE 80/udp`
12) `VOLUME` --> crea un punto de montaje con un nombre específico y lo marca como un volumen estático y persistente dentro del host. Se puede declarar de dos formar:
    * `VOLUME ["/mi_disco_1"]`
    * `VOLUME /mi_disco_1 /mi_disco_2`
        * En Windows, la ruta no puede utilizar el disco c:\
13) `USER` --> establece el usuario o UID además del grupo (GID) de manera opcional que se usará al ejecutarse con `RUN`, `CMD` o `ENTRYPOINT`
14) `ONBUILD` --> agrega a la imagen un disparador (trigger) que se puede ejecutar posteriormente cuando la imagen sea parte de otro build como parte de la metadata
15) `STOPSIGNAL` --> establece la llamada del sistema que sera enviada al contenedor al salir. Se puede utilizar las llamadas a la tabla del kernel (9) o en el formato `SIGNAME` (SIGKILL)
16) `HEALTHCHECK` --> le dice a Docker como comprobar si un contenedor aún está funcionando. Se suele utilizar con el comando `CMD` y tiene algunas opciones:
    * --interval=DURATION (inicial: 30s)
    * --timeout=DURATION (inicial: 30s)
    * --start-period=DURATION (inicial: 0s)
    * --retries=N (inicial: 3)
17) `SHELL` --> permite al shell por defecto ser usado con comandos directamente. En Linux, es shell inicial es `["/bin/sh", "-c"]`, y en Windows es `["cmd", "/S", "/C"]`. Este comando se utiliza mucho en Windows para escificar el uso de `powershell`. Por ejemplo:
    * uso directo
        * RUN powershell -command Write-Host default
    * uso con shell
        * SHELL ["powershell", "-command"]
        * RUN Write-Host hello
    * uso directo
        * cmd /S /C powershell -command Execute-MyCmdlet -param1 "c:\foo.txt"
    * uso con shell
        * RUN ["powershell", "-command", "Execute-MyCmdlet", "-param1 \"c:\\foo.txt\""]
