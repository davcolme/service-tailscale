#!/bin/bash
set -e

# ----------------------------------------------------------
# Arranca el daemon de Tailscale
# ----------------------------------------------------------
tailscaled &

# ----------------------------------------------------------
# Espera unos segundos a que tailscaled esté listo
# ----------------------------------------------------------
sleep 2

# ----------------------------------------------------------
# Conecta a la Tailnet usando la API Key y hostname parametrizable
# ----------------------------------------------------------
TAILSCALE_HOSTNAME="${TS_HOSTNAME:-server-tailscale}"
tailscale up --authkey="${TS_AUTHKEY}" --hostname="$TAILSCALE_HOSTNAME"

# Si quieres esperar a que los servicios estén disponibles,
# define opcionalmente un array de host:puerto
for hp in $WAIT_FOR; do
    host=$(echo $hp | cut -d':' -f1)
    port=$(echo $hp | cut -d':' -f2)
    while ! nc -z "$host" "$port"; do
        echo "Esperando a que $host:$port esté listo..."
        sleep 2
    done
done

# ----------------------------------------------------------
# Lanza socat usando la variable completa
# ----------------------------------------------------------
exec socat $SOCAT_CMD
