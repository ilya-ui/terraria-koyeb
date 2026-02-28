FROM ubuntu:22.04

# Устанавливаем нужные программы
RUN apt-get update && apt-get install -y curl unzip ca-certificates libstdc++6 screen

WORKDIR /app

# Скачиваем Playit.gg
RUN curl -SsL https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 -o playit && chmod +x playit

# Скачиваем Террарию (версия 1.4.4.9, так как 1.4.5.5 — это обычно dev-версия, 
# если у тебя есть свой файл, просто замени ссылку ниже)
RUN curl -L -o terraria.zip https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip \
    && unzip terraria.zip -d terraria \
    && rm terraria.zip \
    && mv terraria/1449/Linux /app/server \
    && chmod +x /app/server/TerrariaServer.bin.x86_64

# Создаем стартовый скрипт
RUN echo '#!/bin/bash\n\
echo "=== ССЫЛКА ДЛЯ РЕГИСТРАЦИИ PLAYIT ПОЯВИТСЯ НИЖЕ ==="\n\
./playit &\n\
sleep 5\n\
./server/TerrariaServer.bin.x86_64 -port 7777 -world /app/world.wld -autocreate 2' > start.sh \
    && chmod +x start.sh

# Заглушка порта для Koyeb (чтобы он не выключал сервер)
EXPOSE 8080

CMD ["./start.sh"]
