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
      title: 'Senderismo, Conventos Secretos y Misterios Subterráneos',
      summary: 'Inicio panorámico en los riscos del Tajo, clausura del Consorcio, almuerzo tradicional, joyas de la Judería y paseo subterráneo nocturno.',
      items: [
        {
          id: 'item-d1-1',
          timeSlot: '08:30 – 10:45',
          title: 'Circuito Ermita del Valle: Peña del Rey Moro & Cerro del Bú',
          category: 'Naturaleza & Senderismo',
          badgeText: 'GRATUITO',
          badgeType: 'free',
          duration: '2h 15m',
          distance: '~1.280 m a pie',
          cost: '0,00 €',
          isFree: true,
          locationName: 'Ermita del Valle',
          lat: 39.8516,
          lng: -4.0178,
          audioId: null,
          shortDescription: 'Paseo circular desde la Ermita del Valle hacia la Peña del Rey Moro (escalones de roca) y el yacimiento de la Edad del Bronce del Cerro del Bú, con vistas espectaculares del Alcázar y el río encajonado.',
          highlights: [
            'Parking libre junto a la Ermita del Valle (inicio del circuito)',
            'Tramo 1: Ermita a Peña del Rey Moro (180 m · escalinata en roca viva)',
            'Tramo 2: Peña a Cerro del Bú (450 m · sendero entre jaras)',
            'Tramo 3: Cerro del Bú de vuelta al parking (650 m · panorámica frontal)'
          ],
          tips: 'Llevar calzado deportivo con suela de buen agarre. La peña tiene escalones tallados en roca viva.'
        },
        {
          id: 'item-d1-2',
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
          tips: 'Se recomienda reservar previamente en la web del Consorcio de Toledo para garantizar plaza.'
        },
        {
          id: 'item-d1-3',
          timeSlot: '13:30 – 15:30',
          title: 'Almuerzo Toledano Tradicional',
          category: 'Gastronomía',
          badgeText: '< 20€ / MENÚ',
          badgeType: 'price',
          duration: '2h',
          distance: 'Cerca de Zocodover',
          cost: '15,00 €',
          isFree: false,
          locationName: 'Bar Ludeña / Cuchara de Palo',
          lat: 39.8596,
          lng: -4.0224,
          audioId: null,
          shortDescription: 'Degustación de la cocina típica toledana en el mítico Bar Ludeña (creadores de las famosas carcamusas toledanas) o Cuchara de Palo, manteniendo el presupuesto ajustado bajo 20€ por comensal.',
          highlights: [
            'Plato estrella: Carcamusas toledanas con salsa de tomate picante y guisantes',
            'Vino de la Mancha o cerveza artesana toledana Domus',
            'Ubicación óptima entre la ruta matinal y la Judería de la tarde'
          ],
          tips: 'Llegar sobre las 13:30 para asegurar mesa sin esperas en el interior.'
        },
        {
          id: 'item-d1-4',
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
          id: 'item-d1-5',
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
          timeSlot: '08:00 – 09:15',
          title: '(Opcional) Entrada Libre Matinal a la Catedral Primada',
          category: 'Patrimonio Religioso',
          badgeText: 'GRATUITO',
          badgeType: 'free',
          duration: '1h 15m',
          distance: 'Plaza del Ayuntamiento',
          cost: '0,00 €',
          isFree: true,
          locationName: 'Puerta del Reloj (Catedral)',
          lat: 39.8576,
          lng: -4.0242,
          audioId: null,
          shortDescription: 'Acceso libre reservado al culto por la Puerta del Reloj. Ideal para contemplar las naves góticas en soledad antes de la apertura turística y el tour oficial.',
          highlights: [
            'Entrada de culto sin coste por la fachada norte',
            'Silencio absoluto e iluminación matinal en las vidrieras',
            'Paseo previo por la Plaza del Ayuntamiento y Palacio Arzobispal'
          ],
          tips: 'No incluye museos catedralicios ni coro (que se verán en el tour de las 10:30 h).'
        },
        {
          id: 'item-d2-2',
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
          id: 'item-d2-3',
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
          id: 'item-d2-4',
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
      concept: 'Cerro del Bú + Mirador del Valle',
      category: 'Senderismo',
      priceOfficial: 0.00,
      priceActual: 0.00,
      isFree: true,
      notes: 'Ruta de senderismo libre'
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
      concept: 'Menú tradicional Bar Ludeña / Cuchara de Palo',
      category: 'Gastronomía',
      priceOfficial: 15.00,
      priceActual: 15.00,
      isFree: false,
      notes: 'Carcamusas y menú tradicional < 20€'
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

// 4. GENERATE map_points.json
const mapPoints = {
  routes: [
    {
      id: 'route-valle',
      title: 'Sendero del Valle: Peña del Rey Moro & Cerro del Bú',
      color: '#852221',
      distance: '1,28 km',
      time: '45 min - 1 h',
      points: [
        { lat: 39.8516, lng: -4.0178, title: 'Parking Ermita del Valle', type: 'parking' },
        { lat: 39.8524, lng: -4.0201, title: 'Peña del Rey Moro', type: 'mirador' },
        { lat: 39.8532, lng: -4.0163, title: 'Yacimiento Cerro del Bú', type: 'monument' },
        { lat: 39.8516, lng: -4.0178, title: 'Regreso Ermita del Valle', type: 'parking' }
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
    { id: 'safont', title: 'Parking Gratuito Safont', category: 'Parking', lat: 39.8628, lng: -4.0189, icon: 'local_parking' },
    { id: 'escaleras', title: 'Escaleras Mecánicas del Miradero', category: 'Acceso', lat: 39.8606, lng: -4.0217, icon: 'escalator' },
    { id: 'hotel', title: 'Casa de la Mezquita (Alojamiento)', category: 'Alojamiento', lat: 39.8598, lng: -4.0242, icon: 'hotel' },
    { id: 'zocodover', title: 'Plaza de Zocodover', category: 'Centro', lat: 39.8595, lng: -4.0215, icon: 'place' },
    { id: 'catedral', title: 'Catedral Primada de Toledo', category: 'Monumento', lat: 39.8571, lng: -4.0238, icon: 'church' },
    { id: 'san-juan-reyes', title: 'Monasterio San Juan de los Reyes', category: 'Monumento', lat: 39.8581, lng: -4.0315, icon: 'fort' },
    { id: 'santa-maria-blanca', title: 'Sinagoga Santa María la Blanca', category: 'Monumento', lat: 39.8572, lng: -4.0302, icon: 'temple_hindu' },
    { id: 'transito', title: 'Sinagoga del Tránsito / Museo Sefardí', category: 'Monumento', lat: 39.8558, lng: -4.0294, icon: 'museum' },
    { id: 'santo-domingo', title: 'Convento Santo Domingo El Real', category: 'Monumento', lat: 39.8603, lng: -4.0275, icon: 'church' },
    { id: 'comendadoras', title: 'Convento Comendadoras de Santiago', category: 'Monumento', lat: 39.8609, lng: -4.0268, icon: 'church' },
    { id: 'rutas-toledo', title: 'Punto Salida: Toledo Subterráneo', category: 'Tour', lat: 39.8569, lng: -4.0228, icon: 'explore' },
    { id: 'castillo-orgaz', title: 'Castillo y Villa de Orgaz', category: 'Excursión', lat: 39.6482, lng: -3.8751, icon: 'castle' },
    { id: 'arisgotas', title: 'Museo de Arte Visigodo Arisgotas', category: 'Excursión', lat: 39.6136, lng: -3.8864, icon: 'museum' },
    { id: 'los-hitos', title: 'Yacimiento Arqueológico Los Hitos', category: 'Arqueología', lat: 39.6054, lng: -3.8927, icon: 'account_balance' }
  ]
};

fs.writeFileSync(path.join(flutterDataDir, 'map_points.json'), JSON.stringify(mapPoints, null, 2), 'utf8');

console.log('Todos los archivos JSON generados con éxito en:', flutterDataDir);
