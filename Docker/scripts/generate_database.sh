#!/bin/bash

# Importa funções de ambiente
source ./Docker/scripts/env_functions.sh

# Se não estiver em ambiente Docker, carrega variáveis
if [ "$DOCKER_ENV" != "true" ]; then
    export_env_vars
fi

# Verifica se o provider é PostgreSQL ou MySQL
if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
    export DATABASE_URL
    echo "Generating database for $DATABASE_PROVIDER"
    echo "Database URL: $DATABASE_URL"

    # Gera o client Prisma usando o schema.prisma correto
    npx prisma generate --schema ./prisma/schema.prisma

    if [ $? -ne 0 ]; then
        echo "❌ Prisma generate failed"
        exit 1
    else
        echo "✅ Prisma generate succeeded"
    fi
else
    echo "❌ Error: Database provider '$DATABASE_PROVIDER' invalid."
    exit 1
fi
