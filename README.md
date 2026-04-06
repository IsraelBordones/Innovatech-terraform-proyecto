# COMO EJECUTAR LA ARQUITECTURA PARA INNOVATECH CHILE
proyecto de terraform para Innovatech Chile

requisitos: CMD GIT, AWS CLI, TERRAFORM CLI, AWS

1 Descargar la carpeta con los 4 archivos de configuración

2 Abrir una consola de git (RECOMENDABLE) dentro de la carpeta

3 Ejecutar "aws configure" e iniciar sesion con AWS CLI

4 Tras el inicio de sesión por AWS, ejecutar "terraform init"
para inicializar el directorio de trabajo. Prepara el entorno descargando los proveedores necesarios (AWS en este caso)

5 Ejecutar Terraform apply, lo que ejecuta los cambios necesarios para alcanzar el estado de infraestructura deseado
tras escribir "yes" despues de una preguntas por la consola, se realizaran los cambios necesarios.

6 Disfrutar su arquitectura basada en la nube de AWS

nota: para eliminar lo hecho anteriormente debe ejecutar en la consola "terraform destroy" la consola
le pedirá escribir yes en confirmación por ende usted escribe "yes"
