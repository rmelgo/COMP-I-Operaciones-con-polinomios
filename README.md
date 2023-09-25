# Operaciones con polinomios

![polinomios](https://github.com/rmelgo/Operaciones-con-polinomios/assets/145989723/d4fb4e43-b340-464b-b91c-ad76af4004f0)

# - Introducción

Proyecto realizado en la asignatura de Computadores II del grado de Ingenieria Informática de la Universidad de Salamanca.  
  
El principal objetivo de este proyecto es la realización de un programa funcional en lenguaje ensamblador que permita realizar operaciones básicas con polinomios.

# - Comentarios sobre el entorno de ejecución

Para ejecutar este programa se requerira de una distribución del Sistema Operativo **GNU/Linux**.    

Para poder ensamblar, enlazar y compilar correctamente el programa, se debera ejecutar el script de bash llamado ***instaladorcii.sh***, el cual se encuentra dentro de este repositorio.   

Este script comprobará que tenéis la distribución de Linux compatible y se descargará y configurará los programas *as6809*, *aslink* y *m6809-run* (necesarios para el ensablado, enlazado y compilado) adecuadamente, siempre que dispongáis de una conexión a Internet en vuestro ordenador.

# - Pasos necesarios para ejecutar el programa

**Paso 1: Ensamblar el programa**  

Para ello se debe introducir el siguente comando:    

```as6809 -o practica_final.asm```

Tras ejecutar este comando, se generará un fichero llamado *practica_final.rel*

**Paso 2: Enlazar el programa**  

Para ello se debe introducir el siguente comando:    

```aslink -s practica_final.rel```

Tras ejecutar este comando, se generará un fichero llamado *practica_final.s19*

**Paso 3: Ejecutar el programa**  

Para ello se debe introducir el siguente comando:    

```m6809-run practica_final.s19```

Tras ejecutar este comando, el programa se habra ejecutado correctamente.

# - Ejemplo de ejecución

En la siguiente imagen, se muestra un ejemplo del uso y funcionamiento del programa:    

<p>
  <img src="https://github.com/rmelgo/Operaciones-con-polinomios/assets/145989723/88f585eb-965c-4fd9-86c9-93a796561b5d" />
</p>
