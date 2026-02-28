FROM ubuntu:22.04

# Устанавливаем зависимости
RUN apt-get update && apt-get install -y curl unzip ca-certificates libstdc++6

# Создаем рабочую папку
WORKDIR /app

# Скачиваем Playit.gg
RUN curl -SsL https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 -o playit && chmod +x playit

# Скачиваем Террарию (замени ссылку на свою 1.4.5.5, если есть прямой линк)
# Сейчас я ставлю заглушку на 1.4.4.9, просто замени URL ниже на свой
RUN curl -L -o terraria.zip https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip \
    && unzip terraria.zip -d terraria \
    && rm terraria.zip \
    && mv terraria/1449/Linux /app/server \
    && chmod +x /app/server/TerrariaServer.bin.x86_64

# Создаем скрипт запуска
RUN echo '#!/bin/bash\n\
./playit --secret $PLAYIT_SECRET &\n\
./server/TerrariaServer.bin.x86_64 -port 7777 -world /app/worlds/world.wld -autocreate 2 -noupdate' > start.sh \
    && chmod +x start.sh

# Порт для Koyeb (нужен для галочки)
EXPOSE 8080

CMD ["./start.sh"]
