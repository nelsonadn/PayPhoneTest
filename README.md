# PayPhoneTest

Prueba técnica Payphone que consiste en una Aplicación de iOS en SwiftUI con Arquitectura MVVM+C (Modal-View-ViewModel + Combine), la app lista usuarios, muestra el detalle y permite crear nuevos usuarios. Usa las librerías de Alamofire para consumir el servicio API desde https://jsonplaceholder.typicode.com/users y RealmSwift para persistencia local.

# Estructura principal:

- `App`: punto de entrada y coordinador global
- `Common`: reutilizables o helpers
- `Core`: servicios de red y almacenamiento
- `Models`: modelos de datos (User)
- `Scenes`: pantallas y view models (Create, Detail, List)

Deployment target:

- iOS 15.6

# Instalación:

- Abrir `PayPhoneTestApp/PayPhoneTest.xcodeproj`
- Actualizar las dependencias de Swift Package Manager a la última versión disponible
- Seleccionar la app y el simulaor (Para correrla en Dispositivo físico se requiere ajustar el Provisioning Profile y Certificado de distribución)
- Compilar y ejecutar el proyecto

## Resumen

- Arquitectura: MVVM+C
- Lenguaje: Swift
- UI: SwiftUI
- Navegación: Coordinator
- Persistencia local: RealmSwift
- Consumo de API: Alamofire
- Ubicación: Core Location
