# 🧑‍💻 BarberConnect - Dockerizacion

Este documento explica **exactamente** cómo levantar el proyecto con Docker en ambiente de equipo (desarrollo y producción). Está diseñado para que cualquier integrante pueda instalar y ejecutar el sistema sin conocer Docker a profundidad.

---

# 📁 Estructura del Proyecto

```
BarberConnect/
├── barberia-backend/          # Backend Laravel + PHP
│   ├── Dockerfile
│   ├── nginx.conf
│   └── ...
├── barberia-frontend/         # Frontend Angular/Ionic
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   ├── nginx.conf
│   └── ...
└── barberia-docker-compose/   # Configuración Docker
    ├── docker-compose.yml
    ├── setup.bat
    ├── setup.sh
    └── README.md
```

---

# 🚀 1. Requisitos

Antes de iniciar, **instala lo siguiente:**

### ✔️ Windows, Mac o Linux

* Docker Desktop (Windows/Mac) -- Versiones recientes
* Docker Engine + Docker Compose (Linux) -- Versiones recientes
* Git -- Versiones recientes
* 4GB RAM libres

Para verificar la instalación:

```bash
docker --version
docker compose version
```

---

# ▶️ 2. Cómo levantar el proyecto (Modo Equipo)

Este modo utiliza **docker-compose.yml** (producción ligera) y los scripts de configuración automáticos.

Se recomienda usar este modo para:

* QA
* Trabajo en equipo
* Revisar funcionalidades integradas

---

# 🟦 3. Pasos para iniciar el sistema

## **Paso 1: Ubicarse en la carpeta del docker-compose**

Windows:

```cmd
cd barberia-docker-compose
```

Mac/Linux:

```bash
cd barberia-docker-compose
```

---

## **Paso 2: Construir e iniciar los contenedores**

```bash
docker compose up -d --build
```

Esto levantará:

* **Frontend (Ionic/Angular + Nginx)** → Puerto 8080
* **Backend Laravel (PHP-FPM + Nginx)** → Puerto 9000
* **Base de datos MySQL** → Puerto 3307

---

## **Paso 3: Ejecutar el script de inicialización**

Este script prepara Laravel automáticamente.

### Windows:

```cmd
setup.bat
```

### Linux/Mac:

```bash
chmod +x setup.sh
./setup.sh
```

Este script hace:

1. Instala dependencias de Laravel (Composer)
2. Copia `.env` si no existe
3. Genera la APP_KEY
4. Espera a MySQL
5. Ejecuta migraciones y seeders
6. Limpia cachés
7. Configura permisos

---

# 🌐 4. Acceso a la aplicación

Una vez cargado todo:

| Servicio    | URL                                            |
| ----------- | ---------------------------------------------- |
| Frontend    | [http://localhost:8080](http://localhost:8080) |
| Backend API | [http://localhost:9000](http://localhost:9000) |
| MySQL       | localhost:3307                                 |

---

# 🧪 5. Comandos útiles del equipo

### Ver estado de los contenedores

```bash
docker compose ps
```

### Ver logs

```bash
docker compose logs -f
```

### Reiniciar un servicio específico

```bash
docker compose restart {service-name}
```

### Detener todo

```bash
docker compose down
```

### Detener y borrar todo (incluye la BD)

```bash
docker compose down -v
```

⚠️ **Esto borra todos los datos del contenedor.**

---

# 🔧 6. Trabajar con el Backend en (Laravel)

### Acceder al contenedor del Backend
```bash
docker compose exec backend bash
```

### Ejecutar comandos de Artisan

**Desde fuera del contenedor**
```bash
docker compose exec backend php artisan migrate
docker compose exec backend php artisan db:seed
docker compose exec backend php artisan cache:clear
docker compose exec backend php artisan config:clear
docker compose exec backend php artisan route:list
```

**Crear un nuevo controlador**
```bash
docker compose exec backend php artisan make:controller NombreController
```

**Crear un nuevo modelo**
```bash
docker compose exec backend php artisan make:model NombreModelo -m
```

**Crear una migración**
```bash
docker compose exec backend php artisan make:migration crear_tabla_nombre
```

### Instalar nuevos paquetes de Composer

```bash
docker compose exec backend composer require nombre/paquete
docker compose exec backend composer install
docker compose exec backend composer update
```

### Ver logs del backend en tiempo real

```bash
docker compose exec backend tail -f storage/logs/laravel.log
```

---

# 🎨 7. Trabajar con Frontend (Angular/Ionic)

### Acceder al contenedor del frontend

```bash
docker compose exec frontend sh
```

### Instalar nuevos paquetes de NPM

```bash
docker compose exec frontend npm install paquete
docker compose exec frontend npm install
```

### Reconstruir el frontend

**Si modificaste archivos y necesitas reconstruir:**
```bash
docker compose restart frontend
```

**O reconstruir la imagen completamente:**
```bash
docker compose up -d --build frontend
```

---

# 🗄️ 8. Trabajar con la Base de Datos

### Conectarse a MySQL desde la terminal
```bash
docker compose exec db mysql -uroot -p
```
Luego ingresa la contraseña definida en ```docker-compose.yml```.

### Ejecutar un dump de la base de datos
```bash
docker compose exec db mysqldump -uroot -p laravel_db > backup.sql
```

### Importar un dump SQL
```bash
docker compose exec -T db mysql -uroot -p laravel_db < backup.sql
```

### Resetear la base de datos
```bash
docker compose exec backend php artisan migrate:fresh --seed
```

---

# 🛠️ 9. Problemas comunes

### ❌ "Puerto 8080/9000/3307 está en uso"

Cambiar puertos en `docker-compose.yml`.

### ❌ Migraciones fallan al inicio

La BD tarda en iniciar. Correr nuevamente:

```bash
./setup.sh
```

O ejecutar manualmente:

```bash
docker compose exec backend php artisan migrate --seed
```

### ❌ Permisos denegados (Linux/Mac)

```bash
sudo chown -R $USER:$USER ../barberia-backend
sudo chown -R $USER:$USER ../barberia-frontend
```

### ❌ Cambios en el código no se reflejan

para Backend:

```bash
docker compose exec backend php artisan config:clear
docker compose exec backend php artisan cache:clear
docker compose restart backend
```

Para frontend:

```bash
docker compose restart frontend
```

### ❌ Error de conexión entre backend y base de datos

Verificar que los contenedores estén corriendo:

```bash
docker compose ps
```

Verificar logs de la base de datos:

```bash
docker compose logs db
```

---

# 🔐 10. Credenciales de la base de datos

```
Host: localhost
Puerto: 3307
Usuario: root
Contraseña: (definida en docker-compose.yml)
Base de datos: laravel_db
```

---

# 🧭 11. Flujo recomendado de trabajo en equipo

1. Hacer `pull` del repositorio
2. Levantar contenedores: ```docker compose up -d --build```
3. Ejecutar `setup.sh` o `setup.bat`
4. Probar en navegador
5. Trabajar normalmente
6. Si hay cambios en dependencias, reconstruir: ```docker compose up -d --build```
7. Al terminar: ```docker compose down```

---

# 📋 12. Cheat Sheet de comandos Docker Compose

```bash
# Levantar servicios
docker compose up -d

# Levantar y reconstruir
docker compose up -d --build

# Detener servicios
docker compose down

# Ver servicios activos
docker compose ps

# Ver logs de todos los servicios
docker compose logs -f

# Ver logs de un servicio
docker compose logs -f <servicio>

# Reiniciar un servicio
docker compose restart <servicio>

# Ejecutar comando en un servicio
docker compose exec <servicio> <comando>

# Acceder a la terminal de un servicio
docker compose exec <servicio> bash  # o sh

# Eliminar contenedores y volúmenes
docker compose down -v
```

---

# 🤝 9. Soporte interno

Para dudas o fallas:

* Revisar logs con: `docker compose logs -f`
* Confirmar contenedores activos: `docker compose ps`
* Verificar conectividad entre servicios: ```docker compose exec backend ping db```


---

**BarberConnect — Documentación oficial del equipo**
