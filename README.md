# Proyecto Final: Segundo Avance

*Santiago Madariaga Collado*

---

# Diseño, entrenamiento y deployment de un modelo NLU para Twitter

## Descripción de la Aplicación

Este proyecto busca servir de manera distribuida, escalable y containerizada un modelo de Natural Language Understanding y sus pipelines correspondientes.

En primer lugar, un servicio y deployment de python extraerá los tweets de las tendencias por hora. Luego, otro servicio intentará definir los sentimientos, emociones y la información de cada tweet.

## Arquitectura de la aplicación

Se usarán varios servicos web de Amazon para instanciar el proyecto.

Un diagrama general de estos se muestra a continuación
![Diagrama de los servicios usados](../../../../../../../f:/desx/Diagrama%20en%20blanco%20-%20P%C3%A1gina%205.png)

### Diagrama de los servicios

![image](https://user-images.githubusercontent.com/40249960/193394104-b1996935-3dfd-403a-b1b5-4178a3b5989c.png)

Los componentes de esta arquitectura son los siguientes.

### Amazon cloud9

La aplicación será diseñada, testeada y desplegada en AWS cloud9. Los servicios y servidores, tanto del modelo como del proceso de web scrapping serán instanciados en containers (Kubernetes) usando el framework Kubeflow. 

El IDE de cloud9 permite correr los scripts desde el navegador, sin necesidad de iniciar una conexión SSH manual ni tampoco la autenticación por par de llaves (privada - pública). En lugar de esto, solo es necesario iniciar sesión desde un usuario IAM con roles de administrador de recursos.

### Kubeflow

Se decidió utilizar Kubeflow encima de Kubernetes por las herramientas de éste a la hora de diseñar modelos de machine learning. Además de facilitar el entrenamiento del modelo en containers. La infraestructura de Kubeflow tiene la siguiente forma.

La principal ventaja de Kubeflow son los servidores de Notebooks que permiten diseñar y testear el modelo de ML (machine learning) en containers de cloud9.

### EKS

Por debajo de Kubeflow, corre Amazon EKS (elastic kubernetes service) para escalar los contenedores dependiendo de los servicios y recursos utilizados. 

EKS define una instancia EC2 donde correrá su servicio y los contenedores serán definidos. Automatizando el proceso de creación de grupos de seguridad, permisos de red y definición del gateway web.

## Pasos para instanciar la aplicación

+ Crear la política de automatic scaling en Amazon EC2

La política de auto scaling permite mantener réplicas de instancias EC2 dependiendo de la carga que éstas reciban. Para este proyecto, se espera que con 8 instancaias t2.small sea suficiente para probar la funcionalidad del entrenamiento en containers.

+ Crear el entorno de desarrollo en Cloud9

En segundo lugar, se crea entorno (environment) de cloud9. El cual consta de su instancia en EC2 y sus VPC. La siguiente captura muestra el entorno ya creado.

![image](https://user-images.githubusercontent.com/40249960/193393092-b716ac3e-2e75-4f41-93e8-3b1491612c32.png)

+ Instalar y configurar el driver de storage EFS Kubectl

Se usará el storage EFS para definir Volúmenes persistentes necesarios para los PVC que el storage class reciba. Se usará EFS en vez de GP2 (que es el standar) porque EFS permite un acceso multiple simultaneo (ReadWriteMany). Lo cual se explicará en un momento.

+ Crear roles, workspaces y usuarios necesarios

Para esto, se crean políticas IAM para que el driver pueda acceder y gestionar el almacenamiento de las instancias EC2.

+ Crear el bucket en S3 como medio de almacenamiento persistente

+ Instalar Kubeflow y los paquetes necesarios para desplegar su Dashboard

IDE de Cloud9 con sus nodos respectivos

![image](https://user-images.githubusercontent.com/40249960/193393188-5af118bf-9bf8-44d2-b033-0e708ddd10ab.png)

Dashboard en Kubeflow

![image](https://user-images.githubusercontent.com/40249960/193393216-fe9aed2d-3c23-4b26-9d5a-8ed38669ef7a.png)

## Avance 2

+ Definir y entrenar el modelo de machine learning

Para esto, se usará el paquete **kfp** (KubeFlow Pipelines) en python. Este módulo permite definir el orden y las funciones a ejecutar en la pipeline de entrenamiento del modelo.

[imagen]

Además, es posible definir PVC (claims de volumenes persistentes) para almacenar los datasets de entrenamiento ya procesados, los modelos entrenados, logs y demas y que estos datos se mantengan aún después de acabar el entrenamiento (cuando los pods sean borrados).


+ Ejecución de la pipeline 

En el Dashboard de Kubeflow, se subirá la pipeline creada en el paso anterior.

    