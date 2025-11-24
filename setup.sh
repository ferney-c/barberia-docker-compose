#!/bin/bash

echo "=========================================="
echo "🚀 INICIANDO CONFIGURACION AUTOMATICA (Mac/Linux) 🚀"
echo "=========================================="
echo ""

echo "1. Instalando dependencias de PHP (Composer)..."
docker compose exec backend composer install --no-interaction

echo ""
echo "2. Configurando archivo de entorno (.env)..."
docker compose exec backend cp -n .env.example .env

echo ""
echo "3. Generando llave de la aplicacion..."
docker compose exec backend php artisan key:generate

echo ""
echo "5. Esperando a que la Base de Datos arranque..."
sleep 10

echo ""
echo "6. Corriendo migraciones y seeders..."
docker compose exec backend php artisan migrate --seed

echo ""
echo "7. Limpiando caches..."
docker compose exec backend php artisan config:clear
docker compose exec backend php artisan route:clear

echo.
echo 11. Configurando permisos de Laravel...
docker compose exec backend chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
docker compose exec backend chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

echo ""
echo "=========================================="
echo "✅ ¡TODO LISTO! YA PUEDES USAR LA APP ✅"
echo "=========================================="
echo "Backend: http://localhost:9000"
echo "Frontend: http://localhost:8080"
echo "MySQL: localhost:3306 (usuario: root, contraseña: barber_secret, base de datos: laravel_db)"
echo ""