FROM eclipse-temurin:11-jre-focal

#traefik
RUN wget --quiet -O /tmp/traefik.tar.gz "https://github.com/traefik/traefik/releases/download/v2.9.6/traefik_v2.9.6_linux_amd64.tar.gz" && \
tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik && \
rm -f /tmp/traefik.tar.gz && \
chmod +x /usr/local/bin/traefik

RUN groupadd --gid 1000 suwayomi && useradd  --uid 1000 --gid suwayomi --no-log-init suwayomi;

RUN mkdir -p /home/suwayomi/startup && chown -R suwayomi:suwayomi /home/suwayomi

USER suwayomi

WORKDIR /home/suwayomi

# RUN curl -s --create-dirs -L https://raw.githubusercontent.com/suwayomi/docker-tachidesk/main/scripts/startup_script.sh -o /home/suwayomi/startup/startup_script.sh

RUN curl -L $(curl -s https://api.github.com/repos/suwayomi/tachidesk-server/releases/latest | grep -o "https.*jar") -o /home/suwayomi/startup/tachidesk_latest.jar

# Copy
COPY traefik.yml scripts/startup_script.sh startup/

EXPOSE 8091 8080

CMD ["/bin/sh", "/home/suwayomi/startup/startup_script.sh"]
