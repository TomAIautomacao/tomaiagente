#!/bin/bash

# Importa as funções de variáveis de ambiente
source ./Docker/scripts/env_functions.sh

# Se não estiver rodando no ambiente Docker, exporta variáveis locais
if [ "$DOCKER_ENV" != "true" ]; then
  export_env_vars
fi

# Verifica se o provider do banco está correto
if [[ "$DATABASE_PROVIDER" == "postgresql" || "$DATABASE_PROVIDER" == "mysql" ]]; then
  export DATABASE_URL

  echo "📦 Gerando banco de dados para $DATABASE_PROVIDER"
  echo "🌐 URL do banco: $DATABASE_URL"

  # Aguarda alguns segundos para garantir que o banco esteja online
  echo "⏳ Aguardando o banco iniciar..."
  sleep 10

  # Executa a migração do Prisma
  npx prisma migrate deploy --schema ./prisma/${DATABASE_PROVIDER}-schema.prisma
  if [ $? -ne 0 ]; then
    echo "❌ Falha ao rodar prisma migrate"
    exit 1
  else
    echo "✅ Prisma migrate rodou com sucesso!"
  fi

else
  echo "🚫 DATABASE_PROVIDER inválido: $DATABASE_PROVIDER"
  exit 1
fi
