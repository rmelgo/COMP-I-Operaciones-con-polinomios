# Operaciones con polinomios

 ![capidbcolor](![image](https://github.com/rmelgo/Operaciones-con-polinomios/assets/145989723/659787a6-bbed-484f-b308-2655f3ab150d))


# -Introducción

Proyecto web full-stack de enseñanza de Bases de Datos potenciado con Inteligencia Artificial. Se trata de un proyecto de exploración sobre las nuevas IA en un uso académico. Explora redes neuronales y ChatGPT (con herramientas como Fine-Tuning, Prompt Engineering y limitación de recursos a dicha API). Este proyecto se ha planteado de forma local en una máquina con SO Windows 10 y con una versión de Python3.

# ~ Objetivo del proyecto

El principal objetivo de este proyecto fue crear una herramienta de ayuda para los estudiantes de la asignatura de Bases de Datos utilizando herramientas de Inteligencia Artificial. Además, se trata de un proyecto que implicó una inversión significativa en el aprendizaje de las técnicas de Procesamiento del Lenguaje Natural (NLP, por sus siglas en inglés) en el contexto de las Inteligencias Artificiales. Exploramos todas las posibilidades de ChatGPT, tanto en la ingeniería de prompts como en la creación de un modelo mucho más definido mediante Fine-Tuning (Afinamiento). También investigamos la evolución de ChatGPT en comparación con modelos antiguos de Procesamiento de Lenguaje Natural, como la red neuronal creada conocida como Bag of Words (Bolsa de Palabras), que permite a los estudiantes plantear preguntas más específicas sobre el funcionamiento de la web.

# ~ Distribución y ejecución del proyecto

El proyecto se divide en dos carpetas Front y Back, para poder ejecutar el proyecto se debe hacer un "npm run build" del proyecto del Frontend para añadir dentro del Backend. En este Build, se debe añadir las claves de la API de ChatGPT para poder hacer las llamadas a la misma (front/dbcapy/src/containers/Teoria.js line 167, front/dbcapy/src/containers/Practica.js line 73). 
Ya con estos cambios, solo hace falta correr el proyecto con Django con la orden "python -m manage runserver" dentro del fichero de Backend. Recordar que este comando se usa para un Sistema Operativo Windows 10. 
