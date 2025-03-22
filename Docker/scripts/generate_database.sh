#!/bin/bash

source ./Docker/scripts/env_functions.sh

if [ "$DOCKER_ENV" != "true" ]; then
  export_env_vars
fi

if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
  echo "🔧 Gerando banco de dados para: $DATABASE_PROVIDER"
  echo "🌐 URL do banco: $DATABASE_URL"

  npx prisma generate
  if [ $? -ne 0 ]; then
    echo "❌ Falha ao rodar prisma generate"
    exit 1
  fi

  npx prisma migrate deploy
  if [ $? -ne 0 ]; then
    echo "❌ Falha ao rodar prisma migrate"
    exit 1
  fi

  echo "✅ Prisma executado com sucesso"
else
  echo "❌ DATABASE_PROVIDER inválido: $DATABASE_PROVIDER"
  exit 1
fi
