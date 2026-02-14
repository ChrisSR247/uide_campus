# Sistema de Intervención con Geolocalización, Visión y AR

Aplicación móvil desarrollada en Flutter que simula un proceso de intervención ambiental mediante:

- Geolocalización
- Análisis visual
- Activación contextual
- Interfaz de Realidad Aumentada

---

## Autores

- Christian Salinas
- Mateo Castillo

---

## Descripción del Sistema

La aplicación permite:

1. Detectar la ubicación del usuario
2. Evaluar su proximidad a un punto de intervención
3. Habilitar el análisis visual solo si se cumplen condiciones de precisión
4. Simular una intervención en AR

El sistema evita el uso constante de sensores para optimizar batería.

---

## Arquitectura

El proyecto está estructurado en 3 capas:

### Presentation
UI y manejo de estado

- Screens
- Providers
- Widgets

### Domain
Lógica del sistema

- Reglas de activación
- Validaciones
- Condiciones de intervención

### Data
Acceso a hardware

- GPS
- Cámara
- Sensores

Esto permite:

✔ Escalabilidad  
✔ Bajo acoplamiento  
✔ Facilidad de mantenimiento  

---

## Manejo de Batería

El sistema optimiza consumo mediante:

- Activación condicional del GPS
- Uso de cámara solo cuando es necesario
- Procesamiento bajo demanda
- Sin ejecución constante en segundo plano

---

## Video del Proyecto

**Duración máxima: 2 minutos**

https://youtube.com/shorts/6gMlVx-8Y3A?si=TED1tgu6X60XXwOp

---

## 📂 Estructura del Proyecto
