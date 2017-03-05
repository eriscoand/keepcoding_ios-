# Práctica iOS Avanzado KeepCoding - HackerBooks

##El Modelo - Esta hecho

- Crear modelo a Core Data
- Descarga asíncrona del JSON, imágenes y PDF
- Guardado a UserDefaults del último libro leído con NSManagedObject
- Listado de libros por tags. 
- Tag de favoritos y marcado de favoritos por libro

##Interfaz - Esta hecho

- Los libros se muestran en un CollectionView
- Las anotaciones se muestran en un CollectionView
- Creación de anotaciones por libro
- La tabla de libros tiene un campo de busqueda por tag, título y autor
- Compartición de una anotación solo a Facebook
- Añadir imagen de la galeria o de la camara a la anotación
- Las anotaciones tienen una localización por coordenadas y por dirección
- Las anotaciones se muestran en un mapa

##Desafíos - Esta hecho

- El último libro leído se guarda en UserDefaults y también en NSUbiquitousKeyValueStore en iCloud. 
- Todas las tareas largas estan dentro de una background task (ver DownloadAsyncGCD)
- Las anotaciones se crean por página de PDF. Se actualiza la vista viendo cuantas notas tiene cada página.
- Se guarda en el modelo la última página leida. Cuando esta es la última, el libro se marca como leído.
- Se crean los dos tags "últimos libros leídos" y "libros leídos". Lós últimos leídos se eliminan del tag "Recent" cuando se inicia la aplicación si estos se abrieron hace más de 7 dias.

- Para que el usuario pudiera añadir subrayados solo se me ocurren dos opciones. 
    - La primera sería poner una vista por encima del PDF. Detectar un "Long press gesture" y por las "coordenadas" en el pdf que ha hecho el gesture guardar-lo en BBDD. Después pintar por encima del pdf imágenes con transparència.
    - La segunda sería utilizar algún framework (seguro que alguien lo tiene hecho) que lo haga xD
    
##Super Desafío 

No me atrevo a desafiar a Chuck Norris :_D .
En realidad no me da tiempo antes de la entrega :)