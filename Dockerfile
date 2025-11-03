# ----------------------------------------------------------
# Base Debian slim
# ----------------------------------------------------------
FROM debian:bullseye-slim

# ----------------------------------------------------------
# Instala dependencias básicas y socat
# ----------------------------------------------------------
RUN apt-get update  && \
    apt-get install -y \
        socat \
        curl \
        gnupg2 \
        lsb-release \
        iproute2 \
        iputils-ping \
        netcat \
        bash && \
    rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------
# Añade la clave y el repositorio oficial de Tailscale
# ----------------------------------------------------------
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main" > /etc/apt/sources.list.d/tailscale.list

# ----------------------------------------------------------
# Instala Tailscale
# ----------------------------------------------------------
RUN apt-get update && \
    apt-get install -y tailscale && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------
# Copia entrypoint y permisos
# ----------------------------------------------------------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ----------------------------------------------------------
# Configura entrypoint
# ----------------------------------------------------------
ENTRYPOINT ["/entrypoint.sh"]
