#!/bin/bash

# Importa funções de variáveis
source ./Docker/scripts/env_functions.sh

# Se estiver fora do Docker, carrega variáveis manualmente
if [ "$DOCKER_ENV" != "true" ]; then
  export_env_vars
fi

# Verifica se o banco é PostgreSQL ou MySQL
if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
  export DATABASE_URL

  echo "📦 Gerando banco de dados para $DATABASE_PROVIDER"
  echo "🌐 URL do banco: $DATABASE_URL"

  echo "⏳ Esperando o banco iniciar..."
  sleep 10

  # Caminho correto do schema PRISMA
  npx prisma migrate deploy --schema ./prisma/schema.prisma
  if [ $? -ne 0 ]; then
    echo "❌ Prisma migrate falhou"
    exit 1
  else
    echo "✅ Prisma migrate rodou com sucesso"
  fi

else
  echo "🚫 DATABASE_PROVIDER inválido: $DATABASE_PROVIDER"
  exit 1
fi
