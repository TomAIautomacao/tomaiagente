#!/bin/bash

source ./Docker/scripts/env_functions.sh

if [ "$DOCKER_ENV" != "true" ]; then
    export_env_vars
fi

if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
    echo "🚀 Gerando banco de dados para: $DATABASE_PROVIDER"
    echo "🔗 URL do banco: $DATABASE_URL"

    export DATABASE_URL

    npx prisma generate --schema=prisma/schema.prisma
    npx prisma migrate deploy --schema=prisma/schema.prisma

    if [ $? -ne 0 ]; then
        echo "❌ Erro ao rodar prisma migrate"
        exit 1
    else
        echo "✅ Migrations aplicadas com sucesso!"
    fi
else
    echo "❌ DATABASE_PROVIDER inválido: $DATABASE_PROVIDER"
    exit 1
fi
