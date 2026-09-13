const fs = require('fs');
const path = require('path');

const rootDir = 'i:/___IA_viajes/toledo';
const flutterDataDir = path.join(rootDir, 'flutter/assets/data');

// 1. GENERATE audioguides.json
const audioDefs = [
  {
    id: 'audio-santo-domingo',
    title: 'Convento de Santo Domingo El Real',
    subtitle: 'Patrimonio Desconocido del Consorcio',
    monument: 'Santo Domingo El Real',
    durationSeconds: 206,
    durationFormatted: '3:26 min',
    file: 'convento-santo-domingo-el-real.mp3',
    txtFile: 'convento-santo-domingo-el-real.txt',
    lat: 39.8603,
    lng: -4.0275
  },
  {
    id: 'audio-comendadoras',
    title: 'Convento de Comendadoras de Santiago',
    subtitle: 'Caballeros Santiaguistas y Azulejería Mudéjar',
    monument: 'Comendadoras de Santiago',
    durationSeconds: 202,
    durationFormatted: '3:22 min',
    file: 'convento-comendadoras-de-santiago.mp3',
    txtFile: 'convento-comendadoras-de-santiago.txt',
    lat: 39.8609,
    lng: -4.0268
  },
  {
    id: 'audio-san-juan-reyes',
    title: 'Monasterio de San Juan de los Reyes',
    subtitle: 'Cumbre del Gótico Isabelino y Reyes Católicos',
    monument: 'San Juan de los Reyes',
    durationSeconds: 487,
    durationFormatted: '8:07 min',
    file: 'monasterio-san-juan-de-los-reyes.mp3',
    txtFile: 'monasterio-san-juan-de-los-reyes.txt',
    lat: 39.8581,
    lng: -4.0315
  },
  {
    id: 'audio-santa-maria-blanca',
    title: 'Sinagoga de Santa María la Blanca',
    subtitle: 'La Armonía Almohade de las Tres Culturas',
    monument: 'Santa María la Blanca',
    durationSeconds: 246,
    durationFormatted: '4:06 min',
    file: 'sinagoga-santa-maria-la-blanca.mp3',
    txtFile: 'sinagoga-santa-maria-la-blanca.txt',
    lat: 39.8572,
    lng: -4.0302
  },
  {
    id: 'audio-sinagoga-transito',
    title: 'Sinagoga del Tránsito / Museo Sefardí',
    subtitle: 'La Joya de Samuel ha-Leví y el Firmamento Mudéjar',
    monument: 'Sinagoga del Tránsito',
    durationSeconds: 244,
    durationFormatted: '4:04 min',
    file: 'sinagoga-del-transito-museo-sefardi.mp3',
    txtFile: 'sinagoga-del-transito-museo-sefardi.txt',
    lat: 39.8558,
    lng: -4.0294
  },
  {
    id: 'audio-paseo-juderia',
    title: 'Paseo por Rincones y Miradores de la Judería',
    subtitle: 'Ruta Circular de 6 Paradas por el Laberinto Sefardí',
    monument: 'Judería Mayor & Mirador San Cristóbal',
    durationSeconds: 705,
    durationFormatted: '11:45 min',
    file: 'paseo-rincones-miradores-juderia.mp3',
    txtFile: 'paseo-rincones-miradores-juderia.txt',
    lat: 39.8549,
    lng: -4.0271
  }
];

const audioguides = audioDefs.map(a => {
  const txtPath = path.join(rootDir, 'audios/texto', a.txtFile);
  let transcript = '';
  if (fs.existsSync(txtPath)) {
    transcript = fs.readFileSync(txtPath, 'utf8').trim();
  }
  return {
    id: a.id,
    title: a.title,
    subtitle: a.subtitle,
    monument: a.monument,
    durationSeconds: a.durationSeconds,
    durationFormatted: a.durationFormatted,
    audioAsset: `assets/audios/${a.file}`,
    lat: a.lat,
    lng: a.lng,
    transcript: transcript
  };
});

fs.writeFileSync(path.join(flutterDataDir, 'audioguides.json'), JSON.stringify(audioguides, null, 2), 'utf8');

// 2. GENERATE itinerary.json
const itinerary = {
  days: [
    {
      id: 'dia-1',
      dayNumber: 1,
      dateFormatted: 'Miércoles, 21 de Octubre 2026',
      title: 'Llegada, Rutas del Consorcio, Gastronomía y Misterios Subterráneos',
      summary: 'Llegada al Parking Safont, Centro de Gestión de Recursos Culturales, conventos de clausura, selección de restaurantes baratos (12€–15€), Judería Mayor y tour nocturno subterráneo.',
      items: [
        {
          id: 'item-d1-1',
          timeSlot: '10:00 – 10:30',
          title: 'Llegada al Parking Safont & Escaleras Mecánicas',
          category: 'Aparcamiento & Acceso',
          badgeText: 'GRATUITO',
          badgeType: 'free',
          duration: '30 min',
          distance: 'Parking Safont · Escaleras Miradero',
          cost: '0,00 €',
          isFree: true,
          locationName: 'Parking Gratuito de Safont',
          lat: 39.8628,
          lng: -4.0189,
          audioId: null,
          shortDescription: 'Llegada a las 10:00 h al aparcamiento disuasorio oficial junto al río Tajo (+1.000 plazas, gratuito 24/7). Ubicado fuera de las cámaras de la ZBE para evitar multas de tráfico. Conexión peatonal directa en 2 min mediante las Escaleras Mecánicas de Safont hasta el Paseo del Miradero.',
          highlights: [
            'Llegada en coche a las 10:00 h a Ronda de Juanelo',
            'Estacionamiento gratuito 24/7, vigilado e iluminado',
            'Escaleras mecánicas gratuitas: Salvan 50 metros de desnivel en 2 min',
            'Evita sanciones automáticas de la Zona de Bajas Emisiones (ZBE)'
          ],
          tips: 'No intentes entrar en coche al casco histórico. Aparca en Safont y sube por las escaleras mecánicas.'
        },
        {
          id: 'item-d1-2',
          timeSlot: '10:30 – 11:00',
          title: 'Centro de Gestión de Recursos Culturales',
          category: 'Patrimonio Consorcio',
          badgeText: 'VISITAS GRATUITAS',
          badgeType: 'free',
          duration: '30 min',
          distance: '850 m a pie desde Safont (12 min)',
          cost: '0,00 €',
          isFree: true,
          locationName: 'Plaza Amador de los Ríos, Toledo',
          lat: 39.8587,
          lng: -4.0252,
          audioId: null,
          shortDescription: 'Oficina oficial del Consorcio de Toledo para gestionar e iniciar las visitas guiadas gratuitas del programa Patrimonio Desconocido. En el subsuelo de la plaza se ubican los restos arqueológicos de las Termas Romanas de Amador de los Ríos (siglos I-II d.C.).',
          highlights: [
            'Llegada a pie a las 10:30 h tras paseo llano por Zocodover y Martín Gamero',
            'Dirección: Plaza Amador de los Ríos, Toledo',
            'Teléfono: 925 25 30 80 (M-S: 10:00 a 14:00, 16:00 a 20:00)',
            'Punto de información y salida para las visitas guiadas gratuitas',
            'Enlace a pie de 4 min (300 m) hacia Santo Domingo El Real a las 11:00 h'
          ],
          tips: 'Confirmar y acreditar aquí las reservas para la ruta guiada gratuita de los conventos.'
        },
        {
          id: 'item-d1-3',
          timeSlot: '11:00 – 13:30',
          title: 'Conventos del Consorcio: Santo Domingo El Real y Comendadoras',
          category: 'Patrimonio Exclusivo',
          badgeText: 'GRATUITO',
          badgeType: 'free',
          duration: '2h 30m',
          distance: 'Casco Histórico',
          cost: '0,00 €',
          isFree: true,
          locationName: 'Plaza de Santo Domingo el Real',
          lat: 39.8603,
          lng: -4.0275,
          audioId: 'audio-santo-domingo',
          shortDescription: 'Acceso exclusivo al programa Patrimonio Desconocido del Consorcio de Toledo. Monasterio dominico de 1364 y Convento de Comendadoras de Santiago con azulejería del siglo XVI y clausura milenaria.',
          highlights: [
            'Visita guiada oficial gratuita del Consorcio los miércoles',
            'Santo Domingo El Real: portada mudéjar y sepulcros reales',
            'Comendadoras de Santiago: zócalos de azulejería y Claustro de los Laureles',
            'Posibilidad de comprar dulces conventuales artesanos en el torno'
          ],
          tips: 'Punto de inicio en la vecina Plaza de Santo Domingo El Real, a solo 300 m de Plaza Amador de los Ríos.'
        },
        {
          id: 'item-d1-4',
          timeSlot: '13:30 – 15:30',
          title: 'Dónde Comer Barato en Toledo (Menús 12€ – 15€)',
          category: 'Gastronomía',
          badgeText: '12€ – 15€ / MENÚ',
          badgeType: 'price',
          duration: '2h',
          distance: 'Casco Histórico & Alrededores',
          cost: '15,00 €',
          isFree: false,
          locationName: 'La Maruja / El Telón / Ave Fénix / El Trébol',
          lat: 39.8568,
          lng: -4.0298,
          audioId: null,
          shortDescription: 'Selección verificada in situ según la guía La Maleta Inquieta 2026: restaurantes auténticos con menú de 12€ a 15€ sin trampas para turistas: La Maruja (patio en Judería), El Telón (Santa Bárbara, 12€), Ave Fénix (universidad, carcamusas) y Cervecería El Trébol (tapeo en alcazaba islámica), más el mítico Bar Ludeña.',
          highlights: [
            'La Maruja (15€): Menú con patio interior cubierto en plena Judería (C/ Cortes 1)',
            'El Telón (12€–15€): El menú más barato, cocina casera de barrio (Av. Santa Bárbara 2)',
            'Ave Fénix (15€): Carcamusas toledanas y solomillo en salsa (C/ Alfonso X 2)',
            'Cervecería El Trébol (~15€): Tapeo y bomba del Trébol dentro de la alcazaba islámica (C/ Santa Fe 1)',
            'Bar Ludeña (12€–16€): Cuna donde se inventaron las carcamusas (Plaza de la Magdalena 10)'
          ],
          tips: '5 Reglas de oro: Aléjate 200 m de Zocodover, evita cartas plastificadas con fotos, pide menú del día (ahorro 8€-12€), sube cuestas y come temprano (13:30 h).'
        },
        {
          id: 'item-d1-5',
          timeSlot: '15:30 – 19:30',
          title: 'La Judería Mayor & Joyas del Mudéjar',
          category: 'Monumento & Audioguías',
          badgeText: 'MONUMENTAL',
          badgeType: 'tour',
          duration: '4h',
          distance: '~1,5 km a pie',
          cost: '11,00 €',
          isFree: false,
          locationName: 'Judería de Toledo',
          lat: 39.8572,
          lng: -4.0302,
          audioId: 'audio-paseo-juderia',
          shortDescription: 'Paseo inmersivo por el laberinto sefardí: San Juan de los Reyes (claustro gótico), Sinagoga de Santa María la Blanca, Sinagoga del Tránsito / Museo Sefardí y recorrido a pie audioguiado por miradores.',
          highlights: [
            '15:30 - Monasterio de San Juan de los Reyes (4€) · Audioguía disponible',
            '16:30 - Sinagoga de Santa María la Blanca (4€) · Audioguía disponible',
            '17:30 - Sinagoga del Tránsito & Museo Sefardí (3€) · Audioguía disponible',
            '18:45 - Paseo audioguiado de 6 paradas: Miqvé, Mezuzot, Cobertizos y Mirador de San Cristóbal'
          ],
          tips: 'La entrada a los monumentos se puede pagar individualmente o mediante la Pulsera Turística toledana.'
        },
        {
          id: 'item-d1-6',
          timeSlot: '20:00 – 21:30',
          title: 'Tour Nocturno: Toledo Subterráneo',
          category: 'Tour Guiado Especializado',
          badgeText: 'TOUR NOCTURNO',
          badgeType: 'tour',
          duration: '1h 30m',
          distance: 'Casco subterráneo',
          cost: '15,00 €',
          isFree: false,
          locationName: 'Rutas de Toledo (C/ Sixto Ramón Parro 9)',
          lat: 39.8569,
          lng: -4.0228,
          audioId: null,
          shortDescription: 'Ruta nocturna guiada por la empresa Rutas de Toledo para descender a los subterráneos ocultos bajo las casas: termas romanas, aljibes islámicos y sótanos legendarios de la inquisición.',
          highlights: [
            'Descenso a 3 o 4 subterráneos privados habitualmente cerrados',
            'Misterios y leyendas de la tradición toledana al anochecer',
            'Punto de encuentro céntrico a 2 minutos de la Catedral'
          ],
          tips: 'Punto de salida: Calle Sixto Ramón Parro 9. Reserva confirmada previamente.'
        }
      ]
    },
    {
      id: 'dia-2',
      dayNumber: 2,
      dateFormatted: 'Jueves, 22 de Octubre 2026',
      title: 'Catedral Primada, Gastronomía Manchega y Los Hitos en Orgaz',
      summary: 'Visita profunda de la Catedral con ojos toledanos, desplazamiento al pueblo histórico de Orgaz, almuerzo en mesón y atardecer visigodo en Los Hitos.',
      items: [
        {
          id: 'item-d2-1',
          timeSlot: '10:30 – 13:00',
          title: 'Visita Guiada: La Catedral con Ojos Toledanos',
          category: 'Tour Guiado Oficial',
          badgeText: '35€ GUIADA + ENTRADA',
          badgeType: 'tour',
          duration: '2h 30m',
          distance: 'Interior Catedral',
          cost: '35,00 €',
          isFree: false,
          locationName: 'Catedral Primada de Toledo',
          lat: 39.8571,
          lng: -4.0238,
          audioId: null,
          shortDescription: 'Visita guiada experta de 2,5 horas que incluye la entrada completa (10€ incluida en el precio). Recorrido por el Transparente de Narciso Tomé, la sillería del coro, la Sacristía con cuadros de El Greco y la Custodia de Enrique de Arfe.',
          highlights: [
            'Guía toledano oficial acreditado',
            'Explicación en detalle del Transparente y la Capilla Mayor',
            'Sacristía: Colección de obras maestras de El Greco, Tiziano y Goya',
            'La Custodia procesional de oro y plata más suntuosa del orbe'
          ],
          tips: 'Punto de encuentro según voucher en la Plaza del Ayuntamiento.'
        },
        {
          id: 'item-d2-2',
          timeSlot: '13:30 – 15:00',
          title: 'Viaje a Orgaz & Almuerzo Manchego Tradicional',
          category: 'Gastronomía Local',
          badgeText: '< 20€ / MENÚ',
          badgeType: 'price',
          duration: '1h 30m',
          distance: '33 km en coche (~30 min)',
          cost: '15,00 €',
          isFree: false,
          locationName: 'Mesón Las Bodegas (Orgaz)',
          lat: 39.6479,
          lng: -3.8745,
          audioId: null,
          shortDescription: 'Traslado en coche desde Toledo a la villa medieval de Orgaz por la CM-42 / N-401. Almuerzo en Mesón Las Bodegas degustando pisto manchego, tiznao, migas del pastor y cordero lechal.',
          highlights: [
            'Ruta rápida por autovía (30 min desde el parking Safont)',
            'Orgaz: Pueblo de empedrado blanco y arquitectura noble tradicional',
            'Menú auténtico con cocina manchega tradicional a precio asequible'
          ],
          tips: 'Aparcamiento sencillo y gratuito en las inmediaciones de la Plaza Mayor de Orgaz.'
        },
        {
          id: 'item-d2-3',
          timeSlot: '15:15 – 19:30',
          title: 'Ruta de la Hispania Visigoda: Orgaz, Arisgotas & Los Hitos',
          category: 'Arqueología & Historia',
          badgeText: '100% GRATUITO',
          badgeType: 'free',
          duration: '4h 15m',
          distance: 'Ruta en coche + senderos',
          cost: '0,00 €',
          isFree: true,
          locationName: 'Yacimiento de Los Hitos',
          lat: 39.6054,
          lng: -3.8927,
          audioId: null,
          shortDescription: 'Exploración del Castillo de los Condes de Orgaz, Museo de Arte Visigodo de Arisgotas y el extraordinario Yacimiento Arqueológico de Los Hitos, palacio y monasterio visigodo del siglo VI previo a la invasión musulmana.',
          highlights: [
            'Castillo de Orgaz (exterior y muralla): s. XIV',
            'Museo Visigodo de Arisgotas: relieves esculpidos y frisos visigodos',
            'Yacimiento de Los Hitos: Pabellón palatino de dos alturas anterior a Santa María del Naranco',
            'Puesta de sol sobre los Montes de Toledo y regreso'
          ],
          tips: 'El yacimiento de Los Hitos es de acceso abierto al aire libre durante todo el año.'
        }
      ]
    }
  ]
};

fs.writeFileSync(path.join(flutterDataDir, 'itinerary.json'), JSON.stringify(itinerary, null, 2), 'utf8');

// 3. GENERATE budget.json
const budget = {
  currency: '€',
  totalPerPerson: 129.26,
  subtotalActivities: 91.00,
  subtotalAccommodation: 38.26,
  items: [
    {
      id: 'b-1',
      day: 'Día 1 Mañana',
      concept: 'Parking Safont & Centro de Recursos Culturales',
      category: 'Transporte & Cultura',
      priceOfficial: 0.00,
      priceActual: 0.00,
      isFree: true,
      notes: 'Parking gratuito 24/7 y gestión de rutas del Consorcio'
    },
    {
      id: 'b-2',
      day: 'Día 1 Mediodía',
      concept: 'Conventos Santo Domingo & Comendadoras',
      category: 'Patrimonio Consorcio',
      priceOfficial: 8.00,
      priceActual: 0.00,
      isFree: true,
      notes: 'Gratuito programa Patrimonio Desconocido'
    },
    {
      id: 'b-3',
      day: 'Día 1 Almuerzo',
      concept: 'Restaurantes Baratos Toledo (La Maleta Inquieta)',
      category: 'Gastronomía',
      priceOfficial: 15.00,
      priceActual: 15.00,
      isFree: false,
      notes: 'Menú del día 12€–15€ (La Maruja, El Telón, Ave Fénix, El Trébol)'
    },
    {
      id: 'b-4',
      day: 'Día 1 Tarde',
      concept: 'San Juan de los Reyes + Santa María la Blanca',
      category: 'Monumentos',
      priceOfficial: 8.00,
      priceActual: 8.00,
      isFree: false,
      notes: '4€ cada entrada (o Pulsera Turística)'
    },
    {
      id: 'b-5',
      day: 'Día 1 Tarde',
      concept: 'Sinagoga del Tránsito / Museo Sefardí',
      category: 'Monumentos',
      priceOfficial: 3.00,
      priceActual: 3.00,
      isFree: false,
      notes: 'Tarifa general reducida estatal'
    },
    {
      id: 'b-6',
      day: 'Día 1 Noche',
      concept: 'Tour Toledo Subterráneo (Rutas de Toledo)',
      category: 'Tour Guiado',
      priceOfficial: 15.00,
      priceActual: 15.00,
      isFree: false,
      notes: '1,5 horas de recorrido subterráneo'
    },
    {
      id: 'b-7',
      day: 'Día 2 Mañana',
      concept: 'Catedral Primada "Con ojos toledanos"',
      category: 'Tour Guiado',
      priceOfficial: 35.00,
      priceActual: 35.00,
      isFree: false,
      notes: '2,5 horas e incluye entrada oficial completa'
    },
    {
      id: 'b-8',
      day: 'Día 2 Almuerzo',
      concept: 'Menú manchego en Orgaz (Las Bodegas)',
      category: 'Gastronomía',
      priceOfficial: 15.00,
      priceActual: 15.00,
      isFree: false,
      notes: 'Cocina manchega tradicional < 20€'
    },
    {
      id: 'b-9',
      day: 'Día 2 Tarde',
      concept: 'Castillo y Villa de Orgaz',
      category: 'Visita Libre',
      priceOfficial: 0.00,
      priceActual: 0.00,
      isFree: true,
      notes: 'Paseo monumental libre'
    },
    {
      id: 'b-10',
      day: 'Día 2 Tarde',
      concept: 'Museo de Arte Visigodo de Arisgotas',
      category: 'Museos',
      priceOfficial: 4.00,
      priceActual: 0.00,
      isFree: true,
      notes: 'Entrada libre y gratuita'
    },
    {
      id: 'b-11',
      day: 'Día 2 Tarde',
      concept: 'Yacimiento Arqueológico Los Hitos',
      category: 'Arqueología',
      priceOfficial: 5.00,
      priceActual: 0.00,
      isFree: true,
      notes: 'Acceso libre y público todo el año'
    },
    {
      id: 'b-12',
      day: 'Alojamiento',
      concept: 'Casa de la Mezquita (Cuesta Carmelitas Descalzos 5)',
      category: 'Hospedaje',
      priceOfficial: 60.00,
      priceActual: 38.26,
      isFree: false,
      notes: 'Coste confirmado por persona y noche'
    },
    {
      id: 'b-13',
      day: 'Parking',
      concept: 'Parking Safont Toledo + Escaleras Mecánicas',
      category: 'Transporte',
      priceOfficial: 24.00,
      priceActual: 0.00,
      isFree: true,
      notes: 'Disuasorio vigilado junto al Tajo (Gratis)'
    }
  ]
};

fs.writeFileSync(path.join(flutterDataDir, 'budget.json'), JSON.stringify(budget, null, 2), 'utf8');

// 4. GENERATE restaurants.json
const restaurantsData = {
  tips: [
    { number: 1, title: 'Aléjate 200 metros de Zocodover', desc: 'Basta separarse 200 m del eje Zocodover–Plaza Mayor para que el precio del menú baje de 5 € a 10 € por persona.' },
    { number: 2, title: 'Evita cartas plastificadas con fotos en 4 idiomas', desc: 'Señal infalible de comida congelada pensada para turistas con sobreprecio.' },
    { number: 3, title: 'Pide siempre el Menú del Día', desc: 'En España y en Toledo, el menú del día ahorra de 8 € a 12 € por persona respecto a pedir a la carta.' },
    { number: 4, title: 'Sube las cuestas para bajar los precios', desc: 'Las zonas altas del casco histórico (universidad, San Pedro Mártir) tienen precios de toledanos.' },
    { number: 5, title: 'Come temprano (13:30 h)', desc: 'Llegar a las 13:30 h garantiza mesa sin colas y tener disponibles todas las opciones de la pizarra antes de que se agoten.' }
  ],
  typicalDishes: [
    { name: 'Las Carcamusas', desc: 'Guiso toledano de magro de cerdo con tomate casero, guisantes, jamón y toque picante en cazuela de barro.' },
    { name: 'La Sopa Castellana', desc: 'Caldo reconfortante de pan de pueblo, ajo dorado, pimentón de la Vera y huevo escalfado.' },
    { name: 'Judías con Perdiz', desc: 'Guiso estrella de caza menor de los Montes de Toledo con alubias tiernas.' },
    { name: 'Vino D.O. Méntrida', desc: 'Tinto autóctono de la provincia incluido frecuentemente en el menú del día sin suplemento.' }
  ],
  restaurants: [
    {
      id: 'la-maruja',
      name: 'La Maruja',
      badge: 'PATIO INTERIOR · JUDERÍA',
      price: '15,00 €',
      priceCategory: '15€ Menú Completo',
      address: 'Calle Cortes, 1, 45002 Toledo',
      zone: 'Judería Mayor (a 5 min de San Juan de los Reyes)',
      type: 'Comida Tradicional Toledana',
      lat: 39.8568,
      lng: -4.0298,
      description: 'Restaurante tradicional con un precioso patio interior cubierto, íntimo y fresco. Menú casero con guisos castellanos, pollo en pepitoria, carcamusas y postre casero. Precio local en plena Judería.',
      tip: 'Reservar con antelación en festivos o fines de semana.'
    },
    {
      id: 'el-telon',
      name: 'El Telón',
      badge: 'EL MÁS BARATO · SANTA BÁRBARA',
      price: '12,00 € – 15,00 €',
      priceCategory: '12€–15€ Menú Casero',
      address: 'Av. de Santa Bárbara, 2, 45006 Toledo',
      zone: 'Barrio Santa Bárbara (a 12 min de Zocodover)',
      type: 'Casa de Comidas de Barrio',
      lat: 39.8637,
      lng: -4.0135,
      description: 'Auténtica casa de comidas de toda la vida fuera del circuito turístico. 80% clientela local (vecinos, profesores y funcionarios). Platos de cuchara diarios, pan de obrador del barrio y raciones donde "te sobra postre".',
      tip: 'Llegar antes de las 14:00 h; a las 14:30 h suele llenarse.'
    },
    {
      id: 'ave-fenix',
      name: 'Ave Fénix',
      badge: 'ZONA UNIVERSITARIA · CARCAMUSAS',
      price: '15,00 €',
      priceCategory: '15€ Menú Completo',
      address: 'Calle Alfonso X el Sabio, 2, 45002 Toledo',
      zone: 'Campus San Pedro Mártir (a 8 min de Zocodover)',
      type: 'Tradicional & Universitarios',
      lat: 39.8589,
      lng: -4.0264,
      description: 'Restaurante universitario con uno de los menús más económicos del casco alto. Especialistas en carcamusas toledanas caseras y solomillo en salsa, con primeros generosos como sopa castellana o ensaladas.',
      tip: 'Pedir las carcamusas al centro para compartir y el solomillo como segundo individual.'
    },
    {
      id: 'el-trebol',
      name: 'Cervecería El Trébol',
      badge: 'ALCAZABA ISLÁMICA S. X · TAPEO',
      price: '~15,00 €',
      priceCategory: '~15€ Tapeo con Cañas',
      address: 'Calle de Santa Fe, 1, 45001 Toledo',
      zone: 'Junto a Zocodover y Alcázar',
      type: 'Tasca Histórica de Tapeo',
      lat: 39.8598,
      lng: -4.0211,
      description: 'Cervecería histórica situada en la antigua alcazaba islámica del siglo X con muros de piedra originales. Ideal para tapear: la célebre Bomba del Trébol (patata rellena de carne con salsas), patatas bravas, morteruelo y carcamusas.',
      tip: 'Pedir mesa o taburete en la zona del muro de piedra islámico.'
    },
    {
      id: 'bar-ludena',
      name: 'Bar Ludeña',
      badge: 'CUNA DE LAS CARCAMUSAS',
      price: '12,00 € – 16,00 €',
      priceCategory: '12€–16€ Menú / Raciones',
      address: 'Plaza de la Magdalena, 10, 45001 Toledo',
      zone: 'Plaza de la Magdalena (a 2 min de Zocodover)',
      type: 'Taberna Histórica Centenaria',
      lat: 39.8596,
      lng: -4.0224,
      description: 'La gran institución toledana donde D. José Ludeña inventó las carcamusas en los años 50. Cazuelas de barro con magro de cerdo, jamón, guisantes y salsa picante, acompañadas de pan candeal.',
      tip: 'Plato obligado: Cazuela de carcamusas caseras con vino de la casa.'
    }
  ]
};

fs.writeFileSync(path.join(flutterDataDir, 'restaurants.json'), JSON.stringify(restaurantsData, null, 2), 'utf8');

// 5. GENERATE map_points.json
const mapPoints = {
  routes: [
    {
      id: 'route-llegada',
      title: 'Llegada: Parking Safont ➔ Escaleras Miradero ➔ Plaza Amador de los Ríos',
      color: '#0284C7',
      distance: '850 m',
      time: '15 min',
      points: [
        { lat: 39.8628, lng: -4.0189, title: '1. Parking Safont (10:00 h)', type: 'parking' },
        { lat: 39.8606, lng: -4.0217, title: '2. Escaleras Mecánicas Safont', type: 'access' },
        { lat: 39.8601, lng: -4.0219, title: '3. Salida Miradero', type: 'mirador' },
        { lat: 39.8595, lng: -4.0215, title: '4. Plaza de Zocodover', type: 'monument' },
        { lat: 39.8587, lng: -4.0252, title: '5. C. Recursos Culturales (10:30 h)', type: 'monument' },
        { lat: 39.8603, lng: -4.0275, title: '6. Convento Sto. Domingo (11:00 h)', type: 'church' }
      ]
    },
    {
      id: 'route-juderia',
      title: 'Paseo por los Rincones y Miradores de la Judería Mayor',
      color: '#C28833',
      distance: '850 m',
      time: '45 min',
      points: [
        { lat: 39.8558, lng: -4.0294, title: '1. Mirador del Tránsito', type: 'mirador' },
        { lat: 39.8562, lng: -4.0287, title: '2. Casa del Judío (Miqvé)', type: 'monument' },
        { lat: 39.8566, lng: -4.0280, title: '3. Huellas de Sefarad & Mezuzot', type: 'monument' },
        { lat: 39.8571, lng: -4.0268, title: '4. Cobertizos & Pozo Amargo', type: 'monument' },
        { lat: 39.8565, lng: -4.0260, title: '5. Calle de Santo Tomé', type: 'shop' },
        { lat: 39.8549, lng: -4.0271, title: '6. Mirador de San Cristóbal', type: 'mirador' }
      ]
    }
  ],
  landmarks: [
    { id: 'safont', title: 'Parking Gratuito Safont (Llegada 10:00 h)', category: 'Parking', lat: 39.8628, lng: -4.0189, icon: 'local_parking' },
    { id: 'escaleras', title: 'Escaleras Mecánicas del Miradero', category: 'Acceso', lat: 39.8606, lng: -4.0217, icon: 'escalator' },
    { id: 'centro-recursos', title: 'Centro Gestión Recursos Culturales (10:30 h)', category: 'Cultura', lat: 39.8587, lng: -4.0252, icon: 'account_balance' },
    { id: 'hotel', title: 'Casa de la Mezquita (Alojamiento)', category: 'Alojamiento', lat: 39.8598, lng: -4.0242, icon: 'hotel' },
    { id: 'zocodover', title: 'Plaza de Zocodover', category: 'Centro', lat: 39.8595, lng: -4.0215, icon: 'place' },
    { id: 'catedral', title: 'Catedral Primada de Toledo', category: 'Monumento', lat: 39.8571, lng: -4.0238, icon: 'church' },
    { id: 'santo-domingo', title: 'Convento Santo Domingo El Real', category: 'Monumento', lat: 39.8603, lng: -4.0275, icon: 'church' },
    { id: 'comendadoras', title: 'Convento Comendadoras de Santiago', category: 'Monumento', lat: 39.8609, lng: -4.0268, icon: 'church' },
    { id: 'san-juan-reyes', title: 'Monasterio San Juan de los Reyes', category: 'Monumento', lat: 39.8581, lng: -4.0315, icon: 'fort' },
    { id: 'santa-maria-blanca', title: 'Sinagoga Santa María la Blanca', category: 'Monumento', lat: 39.8572, lng: -4.0302, icon: 'temple_hindu' },
    { id: 'transito', title: 'Sinagoga del Tránsito / Museo Sefardí', category: 'Monumento', lat: 39.8558, lng: -4.0294, icon: 'museum' },
    { id: 'rutas-toledo', title: 'Punto Salida: Toledo Subterráneo', category: 'Tour', lat: 39.8569, lng: -4.0228, icon: 'explore' },
    { id: 'resto-maruja', title: 'Restaurante La Maruja (Menú 15€ · Patio Judería)', category: 'Restaurante', lat: 39.8568, lng: -4.0298, icon: 'restaurant' },
    { id: 'resto-telon', title: 'Restaurante El Telón (Menú 12€-15€ · Santa Bárbara)', category: 'Restaurante', lat: 39.8637, lng: -4.0135, icon: 'restaurant' },
    { id: 'resto-avefenix', title: 'Restaurante Ave Fénix (Menú 15€ · Alfonso X)', category: 'Restaurante', lat: 39.8589, lng: -4.0264, icon: 'restaurant' },
    { id: 'resto-trebol', title: 'Cervecería El Trébol (Tapeo ~15€ · Alcazaba)', category: 'Restaurante', lat: 39.8598, lng: -4.0211, icon: 'restaurant' },
    { id: 'resto-ludena', title: 'Bar Ludeña (Cuna de las Carcamusas)', category: 'Restaurante', lat: 39.8596, lng: -4.0224, icon: 'restaurant' },
    { id: 'castillo-orgaz', title: 'Castillo y Villa de Orgaz', category: 'Excursión', lat: 39.6482, lng: -3.8751, icon: 'castle' },
    { id: 'arisgotas', title: 'Museo de Arte Visigodo Arisgotas', category: 'Excursión', lat: 39.6136, lng: -3.8864, icon: 'museum' },
    { id: 'los-hitos', title: 'Yacimiento Arqueológico Los Hitos', category: 'Arqueología', lat: 39.6054, lng: -3.8927, icon: 'account_balance' }
  ]
};

fs.writeFileSync(path.join(flutterDataDir, 'map_points.json'), JSON.stringify(mapPoints, null, 2), 'utf8');

console.log('Todos los archivos JSON generados con éxito en:', flutterDataDir);
