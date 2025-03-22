#!/bin/bash

source ./Docker/scripts/env_functions.sh

if [ "$DOCKER_ENV" != "true" ]; then
    export_env_vars
fi

if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
    echo "🔧 Gerando banco de dados para: $DATABASE_PROVIDER"

    echo "🔗 DATABASE_URL: $DATABASE_URL"

    npx prisma generate --schema=prisma/schema.prisma

    if [ $? -ne 0 ]; then
        echo "❌ Falha ao rodar prisma generate"
        exit 1
    fi

    npx prisma migrate deploy --schema=prisma/schema.prisma

    if [ $? -ne 0 ]; then
        echo "❌ Falha ao rodar prisma migrate"
        exit 1
    else
        echo "✅ Migrate executado com sucesso!"
    fi
else
    echo "❌ DATABASE_PROVIDER inválido: $DATABASE_PROVIDER"
    exit 1
fi
