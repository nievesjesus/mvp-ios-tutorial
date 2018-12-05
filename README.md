### MVP Tutorial

En este tutorial explicaremos cómo hemos usar el patrón MVP al desarrollo de aplicaciones iOS, vamos a usar el api de https://reqres.in/ para mostrar una lista de usuarios, todo esto sin usar ninguna librería externa, aprenderemos a comunicar el presenter con la vista (y viceversa), a enviar todo al controlador y pasear un objeto con SWIFT usando unicamente Codable Protocol.

La principal diferencia entre el patrón MVP y otros patrones de UI es la completa independencia entre vista y modelo, dicho en otras palabras la vista no sabe que existe un modelo y el modelo no sabe que existe una vista. Esto es muy bueno para hacer Tests.

### Crea un nuevo proyecto

En primer lugar, abre  Xcode y luego completa los campos para crear un nuevo proyecto.

<img width="420" alt="asset" src="https://user-images.githubusercontent.com/2607274/49516267-f7622080-f877-11e8-8bc4-942a70e62e8f.png">


### Define la estructura de carpetas

Vamos a crear 4 carpetas;

service; En esta carpeta vamos a tener las clases que se encargan de consultar los servicios

view; Dónde vamos a manejar todas las vistas de la aplicación.

model; En esta carpeta vamos a guardar todos los modelos de nuestro proyecto.

presenter; Es donde vamos almacenar nuestros presenters.

<img width="420" alt="asset" src="https://user-images.githubusercontent.com/2607274/49516429-558f0380-f878-11e8-85a8-b484b6752b77.png">

### Model

Si consultamos la api de usuarios (https://reqres.in/api/users?page=2) una respuesta como esta

```json
{
    "page": 2,
    "per_page": 3,
    "total": 12,
    "total_pages": 4,
    "data": [
        {
            "id": 4,
            "first_name": "Eve",
            "last_name": "Holt",
            "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/marcoramires/128.jpg"
        },
        {
            "id": 5,
            "first_name": "Charles",
            "last_name": "Morris",
            "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/stephenmoon/128.jpg"
        },
        {
            "id": 6,
            "first_name": "Tracey",
            "last_name": "Ramos",
            "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/bigmancho/128.jpg"
        }
    ]
}
```

A partir de este resultado podemos armar nuestro modelo en base a eso, tenemos un paginador y dentro del objeto data vienen nuestros usuarios, deberíamos armar un modelo para la paginación y otro para el usuario, luego hacer uno donde ambos se combinan, en este caso vamos solo a crear un modelo de usuario y un combinado de los campos de la paginacion con el modelo de usuario.

Creamos el modelo del Usuario

```swift
import Foundation

struct UserModel: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let avatar: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

//Aqui establecemos el modelo a usar en la consulta al servicio, el cual se compone de la paginacion y del array de usuarios.
struct PagedUsers: Codable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data:[UserModel]
    
    // Especificamos las llaves de los campos en el JSON a nuestros objetos personalizados, solo los que tengan un nombre diferente al objeto, como en el caso de totalPages, su indice es total_pages
    private enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
    }
}
```

### Service
En esta carpeta vamos a crear nuestros servicios, pero primero necesitamos crear una clase base para ser reutilizada en todos nuestros servicios, la llamaremos BaseService

Este tutorial es orientado únicamente al MVP, de momento no vamos a ver nada relacionado con capas de abstracción de red ni métodos de consultas a las apis, usaremos una clase para el manejo de los request (service/Networking/NetworkLayer.swift) la cual maneja las consultas y las respuestas de una api (en otro tutorial explicaremos a detalle esta clase):

####  Obtener usuarios

Creamos un archivo llamado UserService.swift dentro de la carpeta service.

```swift
import Foundation

struct getUsers: RequestType {
    typealias ResponseType = [PagedUsers]
    var data: RequestData {
        return RequestData(path: "https://reqres.in/api/users?page=1")
    }
}
```


## Vista

Ya creamos nuestro modelo y nuestra capa de servicio, ahora es momento de crear la vista para los usuarios. En java se conocen cómo interfaces, aquí los llamamos protocols, lo vamos a usar para definir las acciones que se ejecutaran en la vista desde el presenter.

## Presenter

Ya tenemos creada algunas clases, ahora para unir todo necesitamos el presenter, que es quien se encarga de unir las funciones de cada una de las capas anteriores.

Necesitamos iniciar UsersService y UsersView, también debemos definir getUsersList, que es donde se comunican UsersService y UsersView y luego envían el resultado al ViewController.

Ya en este paso tenemos toda la estructura de MVP armada, ahora solo nos queda crear algunos elementos gráficos para mostrar y un loading.


## ViewController

Este es un ejemplo de como seria la estructura del ViewController

```swift
import UIKit

class ViewController: UIViewController {

    private var viewProgress: UIActivityIndicatorView!
    private var tbView: UITableView!
    private var users = [UserModel]()
    private var presenter = UsersPresenter(getUserService: GetUsers())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        //Establecemos el delegate par el presenter.
        self.presenter.attachView(view: self)
        //Llamamos el servicio que consulta los usuarios desde el presenter.
        self.presenter.getUsersList()
    }

}

extension ViewController {

    func setupView() {
        self.setupTableView()
        self.setupProgressView()

    }

    func setupProgressView() {
        self.viewProgress = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        self.viewProgress.center = self.view.center
        self.viewProgress.isHidden = true
        self.view.addSubview(self.viewProgress)
    }

    func setupTableView() {
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        self.tbView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        self.tbView.dataSource = self
        self.view.addSubview(self.tbView)
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "identifier")
        let user = users[indexPath.row]
        cell.textLabel?.text = user.firstName + " " + user.lastName
        return cell
    }

}

// Hacemos implementación de las funciones de UserView que son llamadas desde el presenter y enviar datos hasta el controlador actual.
extension ViewController: UsersView {

    func startLoading() {
        viewProgress.startAnimating()
        viewProgress.isHidden = false
    }

    func stopLoading() {
        viewProgress.stopAnimating()
        viewProgress.isHidden = true
    }

    func showData(_ users: [UserModel]) {
        self.users = users
        self.tbView.reloadData()
    }

}
```