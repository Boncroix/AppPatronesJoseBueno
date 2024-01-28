# 📲 Dragon Ball Heroes Guide App - Práctica Módulo Patrones de diseño

Esta aplicación, desarrollada en Swift con Xcode, es una guía interactiva de personajes de Dragon Ball y sus transformaciones. Inicialmente implementada con el patrón MVC, la nueva versión utiliza el patrón MVVM para mejorar la estructura y separación de responsabilidades.



- **Versión Antigua con MVC:** Si deseas explorar la versión anterior de la aplicación que utiliza el patrón MVC, puedes encontrar el código en [GitHub](https://github.com/Boncroix/Practica_Fundamentos-iOS).

## Cambios Recientes

- **Patrón MVVM:** Se migró de MVC a MVVM para mejorar la organización y la separación de la lógica de presentación.

- **Actualizaciones Visuales:** Se realizaron mejoras visuales en la interfaz de usuario para una experiencia más atractiva.

## Instrucciones de Uso

1. Clona el repositorio.
2. Abre el proyecto en Xcode.
3. Ejecuta la aplicación en el simulador o dispositivo iOS.
     - **Registro en la API DragonBall:** Antes de utilizar la funcionalidad de inicio de sesión, los usuarios deben registrarse en la API DragonBall de KeepCoding para obtener credenciales válidas. En   caso de no estar registrados, pueden utilizar       las siguientes credenciales de ejemplo:
        - Email: boncroix@gmail.com
        - Contraseña: 12345678

## Notas

- **Obtención de Transformaciones:** Aunque se podría haber reutilizado parte del código para obtener las transformaciones utilizando la misma lógica que la obtención de héroes, se optó por implementarla de manera separada. Esta decisión se tomó con el objetivo de practicar y explorar diferentes enfoques en el desarrollo de la aplicación.

## Contribuciones

¡Contribuciones son bienvenidas! Si deseas mejorar la aplicación, abre un *pull request* y estaré encantado de revisarlo.
