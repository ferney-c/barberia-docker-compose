@echo off
echo ==========================================
echo  INICIANDO CONFIGURACION AUTOMATICA 
echo       Esto no fue hecho con Gemini, guiño guiño
echo ==========================================
echo.

echo 1. Instalando dependencias de PHP (Composer)...
docker-compose exec app composer install --no-interaction

echo.
echo 2. Configurando archivo de entorno (.env)...
docker-compose exec app cp .env.example .env

echo.
echo 3. Generando llave de la aplicacion...
docker-compose exec app php artisan key:generate

echo.
echo 4. Asignando permisos a carpetas de almacenamiento...
docker-compose exec app chmod -R 777 storage bootstrap/cache

echo.
echo 5. Esperando a que la Base de Datos arranque...
timeout /t 10 /nobreak >nul

echo.
echo 6. Corriendo migraciones y seeders...
docker-compose exec app php artisan migrate --seed

echo.
echo 7. Limpiando caches...
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan route:clear

echo.
echo ==========================================
echo  ¡TODO LISTO! YA PUEDES USAR LA APP 
echo ==========================================
echo Backend: http://localhost:9000
echo Frontend: http://localhost:8080
echo.

pause
