# Landing Zone
## Información completa
    - La información más completa de como realizar un despliegue se encuentra en el fichero https://docs.google.com/document/d/1n8oVu-ZhI-yn_CWHTkUWHnLj1ipBWs9x
## Instructions to deploy
#### Pasos Despliegue
    - [1] Despliegue de 00.bootstrap.
        - Se configura el tfvars.
        - En dev el campo grant_billing_user debe ir a false ya que no tenemos admin en la billing account. 
        - Inicialmente se despliega sin provider.
    - [1.2] Una vez desplegado sin provider, la información de output nos devuelve una SA y un bucket, y se configura el provider con esa información.
        - Terraform init + yes.
    - [2] Despliegue de 01-resource-mgmt.
        - Se configura el provider con la información de output de la etapa anterior.
        - En esta etapa se configuran los buckets y service accounts de etapas posteriores.
        - Se configura el tfvars con todos los elementos a desplegar SALVO el de la variable service_accounts que debe desplegarse posteriormente.
        - Una vez desplegados los elementos iniciales, ya se procede a poder desplegar las service accounts y sus permisos.
    - [3] Despliegue de 02-networking.
        - Se configura el provider con la información de output de la etapa 01-resource-mgmt.
        - En esta etapa la variable iam_subnets no está automatizada, debe cambiarse el elemento member manualmente [TODO: Automatizarlo]
        - BUG en variable network cuando la subnet es de tipo PROXY-ONLY, inicialmente se debe crear sin la variable ipv6_access_type, y una vez creado se debe indicar en ese campo: # ipv6_access_type = "INTERNAL". Este bug es del modulo de Google, y ya se les ha abierto una incidencia para que lo solucionen.
    - [4] Despliegue de 03-Security. [TODO: A implementar a futuro, actualmente se encuentra el modulo realizado por Youssef  para este proposito, habría que ver como hacerlo facil y manejable de utilizar.]
    - [5] Despliegue de 04-essentials. [TODO++: Cuando se encuentre definido los servicios de essentials, ver como se pueden implementar en esta etapa]
    - [6] La etapa 05-service-projects se encuentra fuera de la LZ, pero nos sirve para probar que lo anterior funciona correctamente.
#### Pasos Destroy
    - Las etapas Service-Projects, Essentials, security  y networking se pueden destruir, en ese orden y con un terraform destroy.
    - La etapa 01-resource-mgmt se puede destruir limpiamente con un terraform destroy, pero te debes asegurar que en los buckets creados la variable force_destroy sea igual a true, para ello puedes añadirselo y aplicar si no lo tienen y realizar posteriormente el destroy.
    - La etapa 00-bootstrap, para destruirla, debes mover/copiar el state del bucket a tu ordenador local dentro de la carpeta 00-bootstrap, y borrar el .terraform y el .terraform.lock.hcl, y realizar un terraform init + destroy. Para que el destroy sea limpio, debes asegurarte que la variable force_destroy sea igual a true.
    - Para facilitar las pruebas, dentro de modules/terraform-google-bootstrap-master/main.tf, en el modulo seed_project se ha puesto la variable lien a false, pero en un entorno real conviene que sea a true, esto crea una lien que solo es posible borrar con comandos gcloud y si tienes los permisos adecuados para ello.
