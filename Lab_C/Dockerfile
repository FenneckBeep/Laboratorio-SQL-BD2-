FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    gcc \
    libecpg-dev \
    libecpg6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar todo el contenido de Lab_C al contenedor
COPY . .

# Traducir el .pgc actualizado a .c internamente
RUN ecpg main.pgc -o main.c

# Compilar el binario fresco
RUN gcc main.c -o programa_calidad -I/usr/include/postgresql -L/usr/lib/x86_64-linux-gnu -lecpg

CMD ["./programa_calidad"]