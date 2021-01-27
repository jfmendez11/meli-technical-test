# Mercadolibre Mobile Test
### By: Juan Felipe Méndez

## Ejecutar la aplicación

Para ejecutar la aplicación es necesario contar con ```swiftlint``` instalado localmanete. En caso de no contar con el, se puede instalar corriendo el siguiente comando

```brew install swiftlint```

Alternivativamente, se puede remover el script de las configuraciones del proyecto, el cual verifica la existencia del linter y lo ejecuta. Para removerlo es necesario seguir las siguientes instrucciones.


Luego de realizar ese paso, es posible correr la aplicación desde el simulador o un dispositivo físico.

**Nota:** Para correr la aplicación es necesario tener instalado Xcode 12.3 mínimo o iOS 14.3 si se corre en un dispositivo físico. Asegurarse de gestionar correctamente el perfil en la sección de Signing and Capabilites.


## Flujo de la aplicación

The app is basically embedded in a navigation controller. The first view is a "login" screen, where a user can be selected, or all the users.

After selecting a user, a TableView is displayed with all the relevant transactions. Transactions can be deleted and reloaded. If a transaction is clicked, the transaction information is showned in a new View. The transaction is also read.

Transactions can only be reloaded if one or more are deleted or read.

Finally, if the the menu button is clicked, a sidebar is displayed and the selected user can be changed. In other words, the app takes you back to the "login" view.

Unit tests where made to test the API requests to the server and can be found in the ```leal-ios-UnitTests``` folder`.

## Arquitecutra propuesta

Following Apple Developer Guidelines, the MVC design pattern was used. Within the app, the delegate pattern was also included.

### Models

A ```codable struct``` was created, for each of the relevant schemas in the API. Taking into advantage the ```codable``` protocol to read ```JSON``` .

Besides this, the ```DataManager.swift``` file is in charge of all the API requests. However, the controllers which make API requests must conform to the ```DataDelegate``` protocol. The protocol consists on two functions, which handle the data from the request or possible errors.

### Controllers

Each View has its own controller. They handle the communication between the View and the Model. All controllers make API requests except ```SidebarViewController.swift```, which is in charged of displaying the Sidebar and "logging out".

### Views

Foe this proyect, the UI was designed with Interface Builder in the ```Main.storyboard```. Some additional files are included, like ```TransactionCell.xib``` to build the transaction cells and ```CustomCardView.swift```, which is used a super class to create a card-like effect in the Transaction Information View.

### Networking

### Other files

In the folder ```Constants and Extensions``` there are 2 files: ```Constants.swift``` and ```Extensions.swift```. The first one stores all the constants used acrossed the app and the second one different extensions to ```Foundation``` classes and ``ÙIKit`` classes.

## Dependencias Utilizadas

Como paquete de dependencias, se utilizó Swift Package Manager (SPM). Con este, se instaló una sola dependencia: ! [```SkeletonView```](https://github.com/Juanpe/SkeletonView)

La dependencia es únicamente utilizada para la ayuda de Skeleton para cargar diferentes vistas que hacen peticiones a red.

![SkeletonView Example](https://raw.githubusercontent.com/Juanpe/SkeletonView/develop/Assets/solid.png)

## Dudas o Preguntas

Ante cualquier duda, pregunta o comentario no dude en contactarme vía email.
