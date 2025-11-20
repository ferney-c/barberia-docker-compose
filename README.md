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

# 🛠️ 6. Problemas comunes

### ❌ "Puerto 8080/9000/3307 está en uso"

Cambiar puertos en `docker-compose.yml`.

### ❌ Migraciones fallan al inicio

La BD tarda en iniciar. Correr nuevamente:

```bash
./setup.sh
```

### ❌ Permisos denegados (Linux/Mac)

```bash
sudo chown -R $USER:$USER ../barberia-backend
sudo chown -R $USER:$USER ../barberia-frontend
```

---

# 🔐 7. Credenciales de la base de datos

```
Host: localhost
Puerto: 3307
Usuario: root
Contraseña: (definida en docker-compose.yml)
Base de datos: laravel_db
```

---

# 🧭 8. Flujo recomendado de trabajo en equipo

1. Hacer `pull` del repositorio
2. Levantar contenedores
3. Ejecutar `setup.sh` o `setup.bat`
4. Probar en navegador
5. Actualizar cada vez que se cambie el backend

---

# 🤝 9. Soporte interno

Para dudas o fallas:

* Revisar logs con: `docker compose logs -f`
* Confirmar contenedores activos: `docker compose ps`

---

**BarberConnect — Documentación oficial del equipo**
