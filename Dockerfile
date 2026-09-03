# Community edition runtime image — enc only (zero business source).
# Build context MUST be the unpacked ztdh-install-enc-* tree (contains app/yudao-server.jar).
# DO NOT COPY any src/ tree or mother monorepo.
FROM eclipse-temurin:25-jre

LABEL org.opencontainers.image.title="shouzhuan-community"
LABEL org.opencontainers.image.description="Shouzhuan Community Edition (enc). Online license required. Zero business source."
LABEL org.opencontainers.image.version="1.0.2"
LABEL org.opencontainers.image.vendor="Shanxi Zhitong Daohe Technology Co., Ltd."

WORKDIR /yudao-server
ENV TZ=Asia/Shanghai
ENV SERVER_PORT=48080
ENV JAVA_OPTS="-Xms512m -Xmx1280m -Djava.security.egd=file:/dev/./urandom"
ENV YUDAO_LICENSE_RUNTIME_EDITION=install
ENV YUDAO_LICENSE_RUNTIME_ONLINE_REQUIRED=true
ENV YUDAO_LICENSE_RUNTIME_OFFLINE_GRACE_HOURS=0
ENV YUDAO_INSTALL_WEB_ENABLED=true
ENV YUDAO_FRAMEWORK_VERSION=1.0.2

COPY app/yudao-server.jar /yudao-server/app.jar

EXPOSE 48080
HEALTHCHECK --interval=10s --timeout=5s --retries=30 --start-period=60s \
  CMD wget -q -O - http://127.0.0.1:48080/actuator/health || exit 1

CMD ["sh", "-c", "java $JAVA_OPTS -jar /yudao-server/app.jar"]
