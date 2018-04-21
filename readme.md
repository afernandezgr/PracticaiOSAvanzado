# Práctica Avanzada de iOS Mobile Bootcamp VI



## Ever Pobre


**Objetivo**

Se ha completado la App Everpobre se la ha dotado de navegación y nuevas funcionalidades.

Navegación General:


- Hace uso de un splitViewController, la App es universal (iPad / iPhone)

- El master es el listado de notas, organizadas en secciones según su notebook. El orden será primero el notebook donde se creen las notas de forma rápida y el resto alfabéticamente según titulo.

- El detalle, es la vista de nota con todos sus detalles.

- Existe una viewController modal, se mostrará en el master, para crear nuevo notebook, borrarlos o seleccionar el por defecto.

- La app creará una nota en la notebook seleccionada por defecto, es requisito para crear un nueva nota el tener seleccionada una notabook por defecto. La notebook seleccionada por defecto aparece marcada con una estrella.

-Se hace uso de custom cells

**Notebook**

- Todas la notas están asociadas a un notebook

- El borrado de un notebook provoca la perdida de todas las notas o su asociación a otro notebook, el usuario debe poder elegir.

**Vista Nota**

- Añade la posibilidad de agregar localización en mapa añadir mapa pequeño a la vista si se añade localización.

- Añadir la posibilidad de incluir tantas imágenes como se quiera.

- Añadir la posibilidad de rotar las imágenes.

- Añadir la posibilidad de escalar las imágenes (limitada: 0.7 - 1.3)

- Se puede editar fecha límite.

- Todo el texto que sea marcado con una # en el texto de la nota será considerado un tag de la nota y será mostrado en el campo habilitado al efecto.

- Para eliminar una nota hay que hace un gesto swipe sobre la misma desde la vista de notebooks para eliminarla

Adolfo Fernández 
2018

