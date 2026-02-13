video subido
link del video: https://www.youtube.com/watch?v=K62XwxnIS6Q

# 📱 Operación Campus UIDE

Aplicación móvil desarrollada en Flutter para el reto técnico **Operación Campus UIDE**.

---

## 👥 Integrantes

- Lander González  
- Victor Montaño  
- Evelyn Valverde  

**Sede:** UIDE – Loja

---

## 🤝 Motivo de conformación del grupo

Nuestro grupo se conformó debido a que Lander González y Victor Montaño contamos únicamente con dispositivos iPhone, por lo cual no disponíamos de un equipo Android para realizar las pruebas requeridas.  

Por este motivo decidimos trabajar junto a Evelyn Valverde, quien sí dispone de un dispositivo Android para poder validar la aplicación en un equipo real.

---

## 1. Introducción

El presente trabajo corresponde al desarrollo de una aplicación móvil en Flutter para el reto denominado **Operación Campus UIDE**, cuyo objetivo es simular la detección e intervención digital de focos de contaminación dentro del campus, utilizando geolocalización, cámara, visión artificial y realidad aumentada.

La aplicación guía al usuario hacia un punto definido en el mapa, permite realizar un diagnóstico visual y posteriormente ejecutar una intervención digital.

---

## 2. Arquitectura de la aplicación

Para el desarrollo de la aplicación se utilizó una arquitectura simple por capas, con el fin de mantener el código organizado y facilitar su mantenimiento.

De manera general, el proyecto se divide en:

- Pantallas, que se encargan de mostrar la interfaz al usuario.
- Providers, que contienen la lógica principal de la aplicación.
- Servicios, preparados para la integración de funcionalidades externas.

Esta organización permite separar la lógica de la interfaz y facilita la ampliación del proyecto en el futuro.

---

## 3. Gestión de estados

Para el manejo del estado de la aplicación se utilizó el patrón **Provider**.

Se implementaron proveedores para:

- el manejo de la ubicación y la distancia al punto,
- el control del proceso de detección por visión artificial.

Gracias al uso de Provider, la lógica se mantiene separada de las pantallas y se evita el uso excesivo de `setState` para operaciones más complejas.

---

## 4. Geolocalización y control de acceso a la cámara

La aplicación obtiene la ubicación del usuario en tiempo real y calcula la distancia hacia un punto de intervención.

La cámara únicamente se habilita cuando la precisión del GPS cumple con el valor requerido, lo que evita que el usuario realice el diagnóstico fuera del área correcta.

De esta forma se garantiza que la intervención se realice únicamente cuando el usuario se encuentra en una ubicación adecuada.

---

## 5. Optimización del consumo de batería

Con el fin de reducir el consumo de batería, se implementó un contador interno de solicitudes al GPS.

Además, la frecuencia con la que se solicita la ubicación se ajusta automáticamente según la distancia al punto de intervención:

- cuando el usuario se encuentra lejos, la aplicación solicita la ubicación con menor frecuencia,
- cuando el usuario se encuentra cerca, la aplicación solicita la ubicación con mayor frecuencia y precisión.

Este comportamiento permite reducir el uso innecesario del GPS.

---

## 6. Visión artificial

La aplicación incorpora un módulo de diagnóstico visual que simula la detección de residuos como botellas o papel.

Se definió un umbral mínimo de confianza del 80 % para permitir la intervención.

Aunque en esta versión la detección se realiza de manera simulada, la aplicación se encuentra preparada para integrar un modelo real de visión artificial mediante TensorFlow Lite.

---

## 7. Intervención mediante realidad aumentada

La intervención se realiza mediante una simulación de realidad aumentada, donde se presenta un objeto virtual con el que el usuario puede interactuar.

Al tocar el objeto se muestra una animación de confirmación y un panel con información simulada de radiación UV, basada en el concepto del proyecto Solmáforo.

La arquitectura está preparada para incorporar una implementación real de realidad aumentada en futuras versiones.

---

## 8. Pruebas realizadas

La aplicación fue probada en un dispositivo físico Android.

Durante las pruebas se verificó el correcto funcionamiento de:

- gestión de permisos,
- obtención de la ubicación real,
- control de precisión del GPS,
- uso de la cámara del dispositivo,
- flujo completo desde el mapa hasta la intervención.

La validación final se realizó directamente en el dispositivo móvil de uno de los integrantes del grupo.

---

## 9. Limitaciones

Aunque la aplicación fue ejecutada en un dispositivo real, tanto el módulo de visión artificial como el de realidad aumentada se encuentran implementados en modo simulado.

Esto se debe principalmente a limitaciones de tiempo y compatibilidad de librerías, sin afectar el flujo general de la aplicación.

La estructura del proyecto permite integrar estas tecnologías de forma real en una versión posterior.

---

## 10. Conclusiones

El desarrollo de esta aplicación permitió integrar geolocalización, manejo de permisos, control de cámara y simulación de visión artificial y realidad aumentada dentro de un solo proyecto.

El uso de Provider y una arquitectura organizada por capas facilitó el desarrollo, el mantenimiento del código y la posibilidad de escalar la aplicación en futuras mejoras.

---


