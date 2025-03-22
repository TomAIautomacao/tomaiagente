#!/bin/bash

# Carrega funções de ambiente se o DOCKER_ENV não estiver setado como "true"
source ./Docker/scripts/env_functions.sh

if [ "$DOCKER_ENV" != "true" ]; then
    export_env_vars
fi

# Verifica se o provider é postgresql ou mysql (ambos suportados pelo script)
if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
    echo "Generating database for $DATABASE_PROVIDER"
    echo "Database URL: $DATABASE_URL"

    # Executa as migrações usando Prisma
    npx prisma migrate deploy --schema ./prisma/schema.prisma

    # Verifica se deu erro ao rodar a migração
    if [ $? -ne 0 ]; then
        echo "❌ Prisma migrate failed"
        exit 1
    else
        echo "✅ Prisma migrate succeeded"
    fi
else
    echo "❌ Error: Database provider '$DATABASE_PROVIDER' is invalid. Use 'postgresql' or 'mysql'."
    exit 1
fi
