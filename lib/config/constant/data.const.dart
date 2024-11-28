import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final Map<String, dynamic>? data;
  final String? imageURL;

  PushMessage(
      {required this.messageId,
      required this.title,
      required this.body,
      required this.sentDate,
      this.data,
      this.imageURL});

  @override
  String toString() {
    return '''
    PushMessage:
    messageId: $messageId, 
    title: $title,
    body: $body,
    sentDate: $sentDate,
    data: $data,
    imageURL: $imageURL
    ''';
  }
}

class ServicioPublico {
  final String nombre;
  final String tipo;
  final String direccion;
  final String horario;
  final List<String> servicios;
  final String telefono;
  final String imagen;
  final String descripcion;
  final LatLng ubicacion;

  const ServicioPublico({
    required this.nombre,
    required this.tipo,
    required this.direccion,
    required this.horario,
    required this.servicios,
    required this.telefono,
    required this.imagen,
    required this.descripcion,
    required this.ubicacion,
  });
}

class Perfil {
  String id;
  String nombreParking;
  int cantEspacios;
  String horarioAtencion;
  String correoElectronico;
  String contrasena;
  String telefono;
  String direccion;
  String coordenadas;
  String urlGoogleMaps;
  String imagenURL;
  List<Regla> reglas;
  List<Servicio> servicios;
  List<Comunicado> comunicados;

  Perfil({
    required this.id,
    required this.nombreParking,
    required this.cantEspacios,
    required this.horarioAtencion,
    required this.correoElectronico,
    required this.contrasena,
    required this.telefono,
    required this.direccion,
    required this.coordenadas,
    required this.urlGoogleMaps,
    required this.imagenURL,
    required this.reglas,
    required this.servicios,
    required this.comunicados,
  });
}

class Regla {
  String id;
  String descripcion;
  String categoria;
  String color;

  Regla({
    required this.id,
    required this.descripcion,
    required this.categoria,
    required this.color,
  });
}

class Servicio {
  String id;
  String nombre;
  String categoria;
  double precio;
  double descuento;

  Servicio({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.descuento,
  });
}

class Comunicado {
  String id;
  String contenido;
  String tipo;

  Comunicado({
    required this.id,
    required this.contenido,
    required this.tipo,
  });
}

// Lista de perfiles con datos realistas
List<Perfil> perfiles = [
  Perfil(
    id: '1',
    nombreParking: 'Parking Centro',
    cantEspacios: 120,
    horarioAtencion: '24 horas',
    correoElectronico: 'contacto@parkingcentro.com',
    contrasena: 'password123',
    telefono: '+591 3 3333333',
    direccion: 'Av. Monseñor Rivero #123',
    coordenadas: '-17.77660536395018, -63.19440665909384',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.77660536395018,-63.19440665909384',
    imagenURL:
        'https://i.pinimg.com/736x/cf/67/6a/cf676a2db1f60484fa441b8a6e21e74f.jpg',
    reglas: [
      Regla(
        id: 'r1',
        descripcion: 'No se permite fumar dentro del estacionamiento.',
        categoria: 'Reglas de Cumplimiento Obligatorio',
        color: '#FF6B6B',
      ),
      Regla(
        id: 'r2',
        descripcion: 'Velocidad máxima de 10 km/h.',
        categoria: 'Responsabilidades del Estacionamiento',
        color: '#4ECDC4',
      ),
      Regla(
        id: 'r3',
        descripcion: 'Prohibido estacionar en áreas no designadas.',
        categoria: 'Limitaciones de Responsabilidad',
        color: '#95A5A6',
      ),
    ],
    servicios: [
      Servicio(
        id: 's1',
        nombre: 'Estacionamiento Auto (30 min)',
        categoria: 'Estacionamiento Auto',
        precio: 10.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's2',
        nombre: 'Estacionamiento Auto (Día completo)',
        categoria: 'Estacionamiento Auto',
        precio: 50.0,
        descuento: 5.0,
      ),
      Servicio(
        id: 's3',
        nombre: 'Lavado Básico Auto (30 min)',
        categoria: 'Servicios de Limpieza',
        precio: 30.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's4',
        nombre: 'Aspirado Profundo (30 min)',
        categoria: 'Servicios de Limpieza',
        precio: 20.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's5',
        nombre: 'Carga Batería (30 min)',
        categoria: 'Servicios Adicionales',
        precio: 40.0,
        descuento: 5.0,
      ),
    ],
    comunicados: [
      Comunicado(
        id: 'c1',
        contenido:
            'El estacionamiento estará cerrado el próximo domingo por mantenimiento.',
        tipo: 'Cierre Programado',
      ),
      Comunicado(
        id: 'c2',
        contenido: 'Nueva tarifa nocturna disponible.',
        tipo: 'Cambio en el Servicio',
      ),
    ],
  ),
  Perfil(
    id: '2',
    nombreParking: 'Estacionamiento Los Pinos',
    cantEspacios: 80,
    horarioAtencion: '6:00 AM - 10:00 PM',
    correoElectronico: 'info@lospinosparking.com',
    contrasena: 'securepass',
    telefono: '+591 3 4444444',
    direccion: 'Calle Los Pinos #456',
    coordenadas: '-17.77300123858324, -63.185106981060926',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.77300123858324,-63.185106981060926',
    imagenURL:
        'https://i.pinimg.com/736x/cf/1a/a7/cf1aa758a1edaff87c742ad239964ab4.jpg',
    reglas: [
      Regla(
        id: 'r4',
        descripcion: 'Mantener los vehículos cerrados.',
        categoria: 'Reglas de Cumplimiento Obligatorio',
        color: '#FF6B6B',
      ),
      Regla(
        id: 'r5',
        descripcion: 'Respetar las señalizaciones internas.',
        categoria: 'Responsabilidades del Estacionamiento',
        color: '#4ECDC4',
      ),
      Regla(
        id: 'r6',
        descripcion: 'No se permite música a alto volumen.',
        categoria: 'Limitaciones de Responsabilidad',
        color: '#95A5A6',
      ),
    ],
    servicios: [
      Servicio(
        id: 's6',
        nombre: 'Estacionamiento Moto (1 hora)',
        categoria: 'Estacionamiento Moto',
        precio: 8.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's7',
        nombre: 'Estacionamiento Moto (Mensual)',
        categoria: 'Estacionamiento Moto',
        precio: 100.0,
        descuento: 10.0,
      ),
      Servicio(
        id: 's8',
        nombre: 'Lavado Completo Moto (30 min)',
        categoria: 'Servicios de Limpieza',
        precio: 15.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's9',
        nombre: 'Revisión de Niveles (15 min)',
        categoria: 'Servicios Adicionales',
        precio: 10.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's10',
        nombre: 'Auxilio Mecánico Básico (30 min)',
        categoria: 'Servicios Adicionales',
        precio: 50.0,
        descuento: 5.0,
      ),
    ],
    comunicados: [
      Comunicado(
        id: 'c3',
        contenido: 'Hemos ampliado nuestra capacidad de estacionamiento.',
        tipo: 'Cambio en el Servicio',
      ),
      Comunicado(
        id: 'c4',
        contenido: 'Promoción especial para clientes frecuentes.',
        tipo: 'Alerta Importante',
      ),
    ],
  ),
  Perfil(
    id: '3',
    nombreParking: 'Parking Las Palmas',
    cantEspacios: 90,
    horarioAtencion: '7:00 AM - 11:00 PM',
    correoElectronico: 'contacto@parkinglaspalmas.com',
    contrasena: 'palmas123',
    telefono: '+591 3 5555555',
    direccion: 'Av. Las Palmas #789',
    coordenadas: '-17.767234541658752, -63.19786669663837',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.767234541658752,-63.19786669663837',
    imagenURL:
        'https://i.pinimg.com/736x/55/28/ac/5528ac7449f2472a3b811c342ea655ec.jpg',
    reglas: [
      Regla(
        id: 'r7',
        descripcion: 'Prohibido dejar objetos de valor en el vehículo.',
        categoria: 'Reglas de Cumplimiento Obligatorio',
        color: '#FF6B6B',
      ),
      Regla(
        id: 'r8',
        descripcion: 'Uso obligatorio de mascarilla.',
        categoria: 'Responsabilidades del Estacionamiento',
        color: '#4ECDC4',
      ),
    ],
    servicios: [
      Servicio(
        id: 's11',
        nombre: 'Estacionamiento Auto (4 horas)',
        categoria: 'Estacionamiento Auto',
        precio: 20.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's12',
        nombre: 'Estacionamiento Auto (Mensual)',
        categoria: 'Estacionamiento Auto',
        precio: 200.0,
        descuento: 15.0,
      ),
      Servicio(
        id: 's13',
        nombre: 'Lavado Básico Moto (15 min)',
        categoria: 'Servicios de Limpieza',
        precio: 10.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's14',
        nombre: 'Presión de Neumáticos (10 min)',
        categoria: 'Servicios Adicionales',
        precio: 5.0,
        descuento: 0.0,
      ),
    ],
    comunicados: [
      Comunicado(
        id: 'c5',
        contenido: 'Nueva área de estacionamiento techado disponible.',
        tipo: 'Cambio en el Servicio',
      ),
      Comunicado(
        id: 'c6',
        contenido: 'Descuentos especiales por el Día del Automóvil.',
        tipo: 'Promoción',
      ),
    ],
  ),
  Perfil(
    id: '4',
    nombreParking: 'Estacionamiento El Trompillo',
    cantEspacios: 70,
    horarioAtencion: '5:00 AM - 12:00 AM',
    correoElectronico: 'info@eltrompillo.com',
    contrasena: 'trompillo2021',
    telefono: '+591 3 6666666',
    direccion: 'Calle El Trompillo #1011',
    coordenadas: '-17.763218627298283, -63.18910802869957',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.763218627298283,-63.18910802869957',
    imagenURL:
        'https://i.pinimg.com/736x/61/46/4d/61464d8f5960206ccd702552930ae7a2.jpg',
    reglas: [
      Regla(
        id: 'r9',
        descripcion: 'Estacionar en un solo espacio asignado.',
        categoria: 'Reglas de Cumplimiento Obligatorio',
        color: '#FF6B6B',
      ),
      Regla(
        id: 'r10',
        descripcion: 'No arrojar basura en el estacionamiento.',
        categoria: 'Responsabilidades del Estacionamiento',
        color: '#4ECDC4',
      ),
    ],
    servicios: [
      Servicio(
        id: 's7',
        nombre: 'Limpieza Interior + Exterior (1.5 horas)',
        categoria: 'Limpieza',
        precio: 100.0,
        descuento: 10.0,
      ),
      Servicio(
        id: 's8',
        nombre: 'Lavado Exterior Premium (45 min)',
        categoria: 'Limpieza',
        precio: 60.0,
        descuento: 5.0,
      ),
    ],
    comunicados: [
      Comunicado(
        id: 'c7',
        contenido: 'Actualización de tarifas a partir del próximo mes.',
        tipo: 'Cambio en el Servicio',
      ),
      Comunicado(
        id: 'c8',
        contenido: 'Evento especial: Exhibición de autos clásicos este sábado.',
        tipo: 'Promoción',
      ),
    ],
  ),
  Perfil(
    id: '5',
    nombreParking: 'Parking Urubó',
    cantEspacios: 150,
    horarioAtencion: '24 horas',
    correoElectronico: 'contacto@parkingurubo.com',
    contrasena: 'urubo2021',
    telefono: '+591 3 7777777',
    direccion: 'Carretera al Urubó km 5',
    coordenadas: '-17.765381006963572, -63.183593333181705',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.765381006963572,-63.183593333181705',
    imagenURL:
        'https://i.pinimg.com/736x/44/16/a9/4416a9b65a0f1381e799eab8209b5515.jpg',
    reglas: [
      Regla(
        id: 'r11',
        descripcion: 'Uso obligatorio de cinturón de seguridad al ingresar.',
        categoria: 'Reglas de Cumplimiento Obligatorio',
        color: '#FF6B6B',
      ),
      Regla(
        id: 'r12',
        descripcion: 'Prohibido el ingreso de mascotas.',
        categoria: 'Limitaciones de Responsabilidad',
        color: '#95A5A6',
      ),
    ],
    servicios: [
      Servicio(
        id: 's9',
        nombre: 'Estacionamiento para bicicletas',
        categoria: 'Eco-Friendly',
        precio: 5.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's10',
        nombre: 'Zona de carga para vehículos eléctricos',
        categoria: 'Eco-Friendly',
        precio: 20.0,
        descuento: 5.0,
      ),
    ],
    comunicados: [
      Comunicado(
        id: 'c9',
        contenido:
            'Inauguración de la nueva zona de restaurantes en el complejo.',
        tipo: 'Cambio en el Servicio',
      ),
      Comunicado(
        id: 'c10',
        contenido:
            'Servicio de estacionamiento gratuito por promoción de apertura.',
        tipo: 'Promoción',
      ),
    ],
  ),
  Perfil(
    id: '6',
    nombreParking: 'Estacionamiento Los Tajibos',
    cantEspacios: 60,
    horarioAtencion: '8:00 AM - 9:00 PM',
    correoElectronico: 'info@lostajibosparking.com',
    contrasena: 'tajibos2021',
    telefono: '+591 3 8888888',
    direccion: 'Calle Los Tajibos #1313',
    coordenadas: '-17.760850094946143, -63.19440635121649',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.760850094946143,-63.19440635121649',
    imagenURL:
        'https://i.pinimg.com/736x/bc/d5/bf/bcd5bf0fcb8bc16d07373e8813f0a214.jpg',
    reglas: [
      Regla(
        id: 'r13',
        descripcion: 'Respetar el límite de altura de 2.5 metros.',
        categoria: 'Reglas de Cumplimiento Obligatorio',
        color: '#FF6B6B',
      ),
      Regla(
        id: 'r14',
        descripcion: 'No se permite lavar vehículos en el lugar.',
        categoria: 'Limitaciones de Responsabilidad',
        color: '#95A5A6',
      ),
    ],
    servicios: [
      Servicio(
        id: 's11',
        nombre: 'Wi-Fi gratuito en áreas designadas',
        categoria: 'Cortesía',
        precio: 0.0,
        descuento: 0.0,
      ),
      Servicio(
        id: 's12',
        nombre: 'Cámaras de seguridad 24/7',
        categoria: 'Seguridad',
        precio: 0.0,
        descuento: 0.0,
      ),
    ],
    comunicados: [
      Comunicado(
        id: 'c11',
        contenido:
            'Horario especial por festividades: Cerrado el 25 de diciembre.',
        tipo: 'Cierre Programado',
      ),
      Comunicado(
        id: 'c12',
        contenido: 'Participa en nuestro sorteo anual de fin de año.',
        tipo: 'Promoción',
      ),
    ],
  ),
  Perfil(
    id: '7',
    nombreParking: 'Parking El Deber',
    cantEspacios: 100,
    horarioAtencion: '24 horas',
    correoElectronico: 'contacto@parkingeldeber.com',
    contrasena: 'eldeber2021',
    telefono: '+591 3 9999999',
    direccion: 'Av. El Deber #100',
    coordenadas: '-17.815957009810955, -63.17589602946231',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.815957009810955,-63.17589602946231',
    imagenURL:
        'https://i.pinimg.com/736x/61/68/22/616822e0f889c63f1764f8deb4f3b215.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '8',
    nombreParking: 'Estacionamiento La Casona',
    cantEspacios: 80,
    horarioAtencion: '6:00 AM - 10:00 PM',
    correoElectronico: 'info@estlacasona.com',
    contrasena: 'lacasona2021',
    telefono: '+591 3 1111111',
    direccion: 'Calle La Casona #200',
    coordenadas: '-17.80680242603089, -63.157528113954676',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.80680242603089,-63.157528113954676',
    imagenURL:
        'https://i.pinimg.com/736x/b5/58/84/b55884c1eb618d5464cc9fb26e8fea35.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '9',
    nombreParking: 'Parking Los Álamos',
    cantEspacios: 120,
    horarioAtencion: '7:00 AM - 11:00 PM',
    correoElectronico: 'contacto@parkinglosalamos.com',
    contrasena: 'losalamos2021',
    telefono: '+591 3 2222222',
    direccion: 'Av. Los Álamos #300',
    coordenadas: '-17.79806100894614, -63.18310672690349',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.79806100894614,-63.18310672690349',
    imagenURL:
        'https://i.pinimg.com/736x/a5/d1/20/a5d120a54b1359c0c725815e0f2df369.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '10',
    nombreParking: 'Estacionamiento El Cristo',
    cantEspacios: 90,
    horarioAtencion: '24 horas',
    correoElectronico: 'info@estelcristo.com',
    contrasena: 'elcristo2021',
    telefono: '+591 3 3333333',
    direccion: 'Av. El Cristo #400',
    coordenadas: '-17.790210503760665, -63.17404507875644',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.790210503760665,-63.17404507875644',
    imagenURL:
        'https://i.pinimg.com/736x/b5/a9/9a/b5a99a9ddd8ac6b673fd7e4ede776347.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '11',
    nombreParking: 'Parking San Martín',
    cantEspacios: 75,
    horarioAtencion: '5:00 AM - 12:00 AM',
    correoElectronico: 'contacto@parkingsanmartin.com',
    contrasena: 'sanmartin2021',
    telefono: '+591 3 4444444',
    direccion: 'Calle San Martín #500',
    coordenadas: '-17.780937996652, -63.17428971341288',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.780937996652,-63.17428971341288',
    imagenURL:
        'https://i.pinimg.com/736x/13/c8/41/13c84110d2a8a198c4b040d13f856b0d.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '12',
    nombreParking: 'Estacionamiento La Ramada',
    cantEspacios: 110,
    horarioAtencion: '6:00 AM - 9:00 PM',
    correoElectronico: 'info@estlaramada.com',
    contrasena: 'laramada2021',
    telefono: '+591 3 5555555',
    direccion: 'Av. La Ramada #600',
    coordenadas: '-17.784579113361467, -63.18709516888314',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.784579113361467,-63.18709516888314',
    imagenURL:
        'https://i.pinimg.com/736x/08/df/98/08df98bf5451155adf0a12f336e2fb30.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '13',
    nombreParking: 'Parking Mutualista',
    cantEspacios: 85,
    horarioAtencion: '7:00 AM - 10:00 PM',
    correoElectronico: 'contacto@parkingmutualista.com',
    contrasena: 'mutualista2021',
    telefono: '+591 3 6666666',
    direccion: 'Calle Mutualista #700',
    coordenadas: '-17.77972475092255, -63.18448551734134',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.77972475092255,-63.18448551734134',
    imagenURL:
        'https://i.pinimg.com/736x/8b/00/24/8b00246f38dd8b4bf0d162a3c36f7408.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '14',
    nombreParking: 'Estacionamiento Las Américas',
    cantEspacios: 95,
    horarioAtencion: '8:00 AM - 11:00 PM',
    correoElectronico: 'info@estlasamericas.com',
    contrasena: 'lasamericas2021',
    telefono: '+591 3 7777777',
    direccion: 'Av. Las Américas #800',
    coordenadas: '-17.775563777287346, -63.18236146776811',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.775563777287346,-63.18236146776811',
    imagenURL:
        'https://i.pinimg.com/736x/3a/d7/5b/3ad75ba9166931eb49f3c0c6d8534733.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '15',
    nombreParking: 'Parking Beni',
    cantEspacios: 130,
    horarioAtencion: '24 horas',
    correoElectronico: 'contacto@parkingbeni.com',
    contrasena: 'beni2021',
    telefono: '+591 3 8888888',
    direccion: 'Av. Beni #900',
    coordenadas: '-17.778452929344933, -63.17344018392354',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.778452929344933,-63.17344018392354',
    imagenURL:
        'https://i.pinimg.com/736x/af/fa/08/affa080177af75fa0a98929c7240320e.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
  Perfil(
    id: '16',
    nombreParking: 'Estacionamiento Urbari',
    cantEspacios: 70,
    horarioAtencion: '6:00 AM - 10:00 PM',
    correoElectronico: 'info@esturbari.com',
    contrasena: 'urbari2021',
    telefono: '+591 3 9999999',
    direccion: 'Calle Urbari #1000',
    coordenadas: '-17.77949253400758, -63.16658208062246',
    urlGoogleMaps:
        'https://maps.google.com/?q=-17.77949253400758,-63.16658208062246',
    imagenURL:
        'https://i.pinimg.com/736x/80/37/a4/8037a4a981d27e9c87b218e3f300e00f.jpg',
    reglas: [],
    servicios: [],
    comunicados: [],
  ),
];
