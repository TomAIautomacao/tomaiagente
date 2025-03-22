#!/bin/bash

source ./Docker/scripts/env_functions.sh

if [ "$DOCKER_ENV" != "true" ]; then
  export_env_vars
fi

if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
  echo "🚀 Gerando banco de dados para: $DATABASE_PROVIDER"
  echo "🔗 DATABASE_URL: $DATABASE_URL"

  # Gera o Prisma Client
  npx prisma generate
  if [ $? -ne 0 ]; then
    echo "❌ Falha ao rodar prisma generate"
    exit 1
  fi

  # Aplica as migrations no banco
  npx prisma migrate deploy
  if [ $? -ne 0 ]; then
    echo "❌ Falha ao rodar prisma migrate"
    exit 1
  fi

  echo "✅ Prisma setup finalizado com sucesso!"
else
  echo "❌ DATABASE_PROVIDER inválido: $DATABASE_PROVIDER"
  exit 1
fi
