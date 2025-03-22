#!/bin/bash

# Carrega funções auxiliares (mantém o padrão)
source ./Docker/scripts/env_functions.sh

# Se não estiver rodando em container, carrega variáveis
if [ "$DOCKER_ENV" != "true" ]; then
    export_env_vars
fi

# Validação do provider
if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
    echo "🔧 Gerando banco de dados para: $DATABASE_PROVIDER"
    echo "🔗 URL do banco: $DATABASE_URL"

    # Executa migration
    npx prisma migrate deploy --schema=prisma/schema.prisma

    if [ $? -ne 0 ]; then
        echo "❌ Erro ao rodar prisma migrate"
        exit 1
    else
        echo "✅ Prisma migrate executado com sucesso!"
    fi
else
    echo "❌ DATABASE_PROVIDER inválido: $DATABASE_PROVIDER"
    exit 1
fi
