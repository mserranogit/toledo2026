# Plan de Implementación: Toledo 2026 Mobile (Flutter)
**De Versión Web/PC a Experiencia Móvil Nativa de Alto Rendimiento**

---

## 1. Visión del Producto Móvil & Filosofía de Diseño

### 1.1. Del Escritorio a la Palma de la Mano
La versión web para escritorio (`html/visita-1/index.html`) presenta una estructura monolítica eficiente para pantallas grandes: una barra lateral fija de 290 px con 12 secciones y un panel de lectura continuo con más de 1.500 líneas de contenido. 

Trasladar esa estructura tal cual a un smartphone generaría una experiencia deficiente: fatiga de scroll infinito, dificultad para alcanzar controles con una sola mano, pérdida de orientación y dependencia crítica de la conexión a internet.

La aplicación móvil en **Flutter** se desarrollará directamente en el directorio raíz **`flutter/`** ya creado en el proyecto, redefiniendo la experiencia bajo cuatro leyes fundamentales:
1. **Ergonomía de Pulgar (Thumb Zone):** Navegación principal en barra inferior (*Bottom Navigation Bar*), acciones críticas al alcance del pulgar y hojas modales inferiores (*Draggable Bottom Sheets*) para profundizar sin perder contexto.
2. **Estética Imperial Premium:** Traslación fiel de la paleta toledana (Granate Imperial `#852221`, Oro Damasquinado `#c28833`, Pizarra Oscura `#111827`) con micro-interacciones hápticas, tipografías refinadas (*Cinzel* y *Plus Jakarta Sans*) y tarjetas con elevaciones sutiles.
3. **Cartografía Abierta con OpenStreetMap (OSM):** Integración nativa de la API gratuita de OpenStreetMap mediante `flutter_map`, con marcadores interactivos, polilíneas de ruta y caché inteligente para visualización offline.
4. **100% Offline-First Real:** En las callejuelas estrechas de la judería toledana, en los subterráneos excavados en roca y en el cañón del Tajo, la cobertura móvil cae drásticamente. Toda la información, mapas OSM cacheados, fichas de monumentos y las 6 pistas de audioguía deben funcionar de forma autónoma sin un solo byte de conexión.

---

## 2. Sistema de Diseño Visual (Design Tokens)

Se replican con exactitud milimétrica los tokens de estilo definidos en `styles.css`, adaptados a `ThemeData` y extensiones de tema en Flutter.

### 2.1. Paleta Cromática Imperial
```dart
abstract class ToledoColors {
  // Primarios Imperiales
  static const Color primary = Color(0xFF852221);       // Carmesí / Granate Imperial
  static const Color primaryDark = Color(0xFF631716);   // Granate Profundo
  static const Color primaryLight = Color(0xFFFBEEED);  // Tinte Suave Carmesí

  // Acentos y Damasquinado
  static const Color accent = Color(0xFFC28833);        // Oro Viejo Toledano
  static const Color accentDark = Color(0xFF92400E);    // Oro Bronce
  static const Color accentLight = Color(0xFFFCF6EB);   // Fondo Crema Áureo

  // Fondos y Superficies
  static const Color bgBody = Color(0xFFF8FAFC);        // Fondo general (Slate 50)
  static const Color surface = Color(0xFFFFFFFF);       // Superficie de tarjetas
  static const Color surfaceAlt = Color(0xFFF1F5F9);    // Superficie alterna (Slate 100)
  static const Color darkSlate = Color(0xFF111827);     // Pizarra Nocturna Imperial
  static const Color darkCard = Color(0xFF1E293B);      // Tarjeta en modo oscuro

  // Tipografía y Textos
  static const Color textMain = Color(0xFF1E293B);      // Texto principal de alto contraste
  static const Color textMuted = Color(0xFF64748B);     // Subtítulos y metadatos
  static const Color textLight = Color(0xFF94A3B8);     // Leyendas y bordes tenues

  // Bordes y Divisores
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFFCBD5E1);

  // Insignias y Píldoras Semánticas (Badges)
  static const Color badgeFreeBg = Color(0xFFECFDF5);
  static const Color badgeFreeText = Color(0xFF065F46);
  static const Color badgeFreeBorder = Color(0xFFA7F3D0);

  static const Color badgeTourBg = Color(0xFFF5F3FF);
  static const Color badgeTourText = Color(0xFF5B21B6);
  static const Color badgeTourBorder = Color(0xFFDDD6FE);

  static const Color badgePriceBg = Color(0xFFFFFBEB);
  static const Color badgePriceText = Color(0xFF92400E);
  static const Color badgePriceBorder = Color(0xFFFDE68A);

  static const Color badgeWarnBg = Color(0xFFFEF2F2);
  static const Color badgeWarnText = Color(0xFF991B1B);
  static const Color badgeWarnBorder = Color(0xFFFECACA);
}
```

### 2.2. Tipografías Oficiales
- **Titulares y Reales:** `Cinzel` (Google Fonts), peso 700/800 con espaciado de letras `letterSpacing: 1.5` a `3.0`.
- **Cuerpo y Lectura:** `Plus Jakarta Sans` (Google Fonts), pesos 400 (regular), 500 (medium), 600 (semi-bold) y 700 (bold).
- **Estrategia Offline de Fuentes:** Las familias tipográficas se empaquetan en `flutter/assets/fonts/` para garantizar renderizado instantáneo sin peticiones de red a Google Fonts.

### 2.3. Radios, Elevaciones y Micro-Animaciones
- **Bordes Redondeados:** `radius-sm: 8.0`, `radius-md: 14.0`, `radius-lg: 20.0`.
- **Sombras:** Sombras multicapa suaves con tintes cálidos (`BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4))`).
- **Retroalimentación Háptica:** Activación de vibración suave (`HapticFeedback.lightImpact()`) al alternar audios, interactuar con el mapa OSM o cambiar de día.

---

## 3. Re-Arquitectura de Navegación Móvil (Optimización UX)

### 3.1. Crítica de la Estructura Web Monolítica
| Elemento en Web PC | Problema en Móvil | Solución Móvil Optimizada |
| :--- | :--- | :--- |
| **Sidebar de 12 enlaces** | Ocupa toda la pantalla o requiere 2 clics para abrir/cerrar | **Bottom Navigation Bar (4 pestañas)** + Selector Segmentado de Días |
| **Página única de 1.500 líneas** | Caída de FPS en listas largas, sobrecarga de memoria | **Vistas tabulares + Slivers virtuales** (`CustomScrollView` + `SliverList`) |
| **Mapas externos enlazados** | Obliga a abandonar la web a apps externas continuamente | **Mapa integrado OpenStreetMap nativo** con marcadores y polilíneas |
| **Reproductores de audio dispersos** | Si haces scroll pierdes el control del audio | **Mini-Player flotante persistente** + Hoja completa al tocarlo |
| **Tablas de presupuesto rígidas** | Scroll horizontal incómodo en pantallas < 400px | **Tarjetas de gastos individuales** con desglose interactivo |

### 3.2. Las 4 Pestañas de la Barra Inferior (BottomNav)

```
┌─────────────────────────────────────────────────────────────┐
│                       PANTALLA MÓVIL                        │
│                                                             │
│   [AppBar Colapsable: Toledo 2026 · Día 1 / Día 2 Switch]  │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │ [Card Hito 1] Mirador del Valle & Cerro del Bú      │   │
│   │ ⏱ 08:30 · 🆓 Gratis · 🎧 Audioguía lista          │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │ [Card Hito 2] Conventos del Consorcio               │   │
│   │ ⏱ 11:00 · 🎟 Reserva Consorcio · 🎧 Audioguía       │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
│   [ MINI-PLAYER PERSISTENTE: ▶ 3. Paseo Judería (04:12) ]   │
├─────────────────────────────────────────────────────────────┤
│  🧭 ITINERARIO  │   🗺️ MAPAS   │  🎧 AUDIOS  │  💰 GASTOS   │
└─────────────────────────────────────────────────────────────┘
```

1. **🧭 Itinerario (Home):**
   - Selector superior dinámico: **Día 1 (21 Oct)** | **Día 2 (22 Oct)** | **Alojamiento & ZBE**.
   - Tarjetas cronológicas con badges de horario, coste y duración estimada.
   - Botón directo de reproducción de audioguía integrado en la tarjeta.
   - Botón directo para ubicar el hito en el mapa interactivo de OpenStreetMap.

2. **🗺️ Mapas & Rutas GPS (OpenStreetMap Nativo):**
   - Motor cartográfico **OpenStreetMap** mediante `flutter_map`.
   - Selector de capa/recorrido:
     - **Ruta 1: Ermita del Valle ➔ Peña del Rey Moro ➔ Cerro del Bú** (1,28 km a pie).
     - **Ruta 2: Judería Mayor & Miradores** (850 m a pie, 6 paradas).
     - **Ruta 3: En Coche a Orgaz & Los Hitos** (Trayecto interurbano).
     - **Puntos Críticos:** Parking Safont, escaleras mecánicas del Miradero y Casa de la Mezquita.
   - Marcadores personalizados con iconos temáticos (🅿️, 🥾, ⛪, 🕍, 👑, 🏛️).
   - Botón de geolocalización del usuario en tiempo real sobre el mapa de Toledo.
   - Modo fallback con esquemas vectoriales topológicos SVG de alto contraste.

3. **🎧 Audioguías (Centro Multimedia):**
   - Catálogo completo de las 6 pistas de audioguía integradas:
     1. *Convento Santo Domingo El Real* (3:26 min)
     2. *Convento Comendadoras de Santiago* (3:22 min)
     3. *Monasterio de San Juan de los Reyes* (8:07 min)
     4. *Sinagoga de Santa María la Blanca* (4:06 min)
     5. *Sinagoga del Tránsito / Museo Sefardí* (4:04 min)
     6. *Paseo por Rincones y Miradores de la Judería* (11:45 min)
   - Transcripción sincronizada en texto (reutilizando los textos de `audios/texto/*.txt`).
   - Control de velocidad (1.0x, 1.2x, 1.5x) y saltos de ±15 segundos.

4. **💰 Presupuesto & Guía Práctica:**
   - Resumen total por persona: **129,26 €** (91,00 € actividades + 38,26 € alojamiento).
   - Checkbox interactivo: el viajero puede marcar qué actividades ya ha pagado o reservado.
   - Tarjeta de Alojamiento (Casa de la Mezquita / Casa de las Meninas) y consejos de Parking (Safont + Escaleras Mecánicas).

---

## 4. Integración de OpenStreetMap (API Gratuita & Offline)

### 4.1. Arquitectura de Mapas con `flutter_map`
OpenStreetMap se integrará como motor cartográfico principal en la aplicación mediante el paquete `flutter_map` (v7+), que proporciona renderizado acelerado por hardware sin necesidad de claves de pago de Google Maps o Mapbox.

```dart
// Configuración de la capa de teselas OpenStreetMap
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'es.toledo2026.guia',
  tileProvider: CachedTileProvider(
    // Estrategia de caché local en disco para navegación offline
    maxStale: const Duration(days: 30),
  ),
)
```

### 4.2. Estrategia de Caché y Funcionamiento Offline de Mapas
1. **Precaché de Zona Toledo & Orgaz:**
   - La aplicación implementará un mecanismo con `flutter_map_cache` o `dio_cache_interceptor` para almacenar en caché persistente las teselas de zoom 13 a 17 correspondientes a:
     - Casco histórico de Toledo y meandro del Valle (Lat: `39.8450` a `39.8650`, Lon: `-4.0400` a `-4.0100`).
     - Zona de Orgaz, Arisgotas y Los Hitos (Lat: `39.6100` a `39.6500`, Lon: `-3.9000` a `-3.8600`).
2. **Descarga Previa con 1 Toque:**
   - Botón en la pantalla de mapas: *"Descargar mapa de Toledo para uso sin internet"* (~8-12 MB en disco).
3. **Capa Fallback Vectorial SVG:**
   - Si no hay conexión y no se han descargado teselas, se muestra automáticamente el mapa esquemático vectorial interactivo SVG integrado en assets, con soporte de pan y zoom.

### 4.3. Coordenadas Exactas Georreferenciadas
```dart
class ToledoGeoPoints {
  // Parkings & Acceso
  static const LatLng parkingSafont = LatLng(39.8628, -4.0189);
  static const LatLng escalerasMecanicas = LatLng(39.8606, -4.0217);
  static const LatLng parkingErmitaValle = LatLng(39.8516, -4.0178);
  static const LatLng casaMezquita = LatLng(39.8598, -4.0242);

  // Ruta Sendero del Valle Día 1
  static const LatLng penaReyMoro = LatLng(39.8524, -4.0201);
  static const LatLng cerroDelBu = LatLng(39.8532, -4.0163);

  // Monumentos Día 1
  static const LatLng conventoSantoDomingo = LatLng(39.8603, -4.0275);
  static const LatLng conventoComendadoras = LatLng(39.8609, -4.0268);
  static const LatLng sanJuanDeLosReyes = LatLng(39.8581, -4.0315);
  static const LatLng santaMariaLaBlanca = LatLng(39.8572, -4.0302);
  static const LatLng sinagogaTransito = LatLng(39.8558, -4.0294);
  static const LatLng miradorSanCristobal = LatLng(39.8549, -4.0271);

  // Día 2 (Toledo & Orgaz)
  static const LatLng catedralPrimada = LatLng(39.8571, -4.0238);
  static const LatLng castilloOrgaz = LatLng(39.6482, -3.8751);
  static const LatLng museoArisgotas = LatLng(39.6136, -3.8864);
  static const LatLng yacimientoLosHitos = LatLng(39.6054, -3.8927);
}
```

---

## 5. Estructura de Directorios en la Carpeta `flutter/`

El proyecto se ubicará íntegramente dentro de la carpeta **`flutter/`** del repositorio:

```
i:\___IA_viajes\toledo\flutter/
├── android/
├── ios/
├── assets/
│   ├── audios/
│   │   ├── convento-comendadoras-de-santiago.mp3
│   │   ├── convento-santo-domingo-el-real.mp3
│   │   ├── monasterio-san-juan-de-los-reyes.mp3
│   │   ├── paseo-rincones-miradores-juderia.mp3
│   │   ├── sinagoga-del-transito-museo-sefardi.mp3
│   │   └── sinagoga-santa-maria-la-blanca.mp3
│   ├── data/
│   │   ├── itinerary.json
│   │   ├── audioguides.json
│   │   ├── routes_geojson.json
│   │   └── budget.json
│   ├── fonts/
│   │   ├── Cinzel-Bold.ttf
│   │   ├── Cinzel-Regular.ttf
│   │   ├── PlusJakartaSans-Regular.ttf
│   │   ├── PlusJakartaSans-Medium.ttf
│   │   └── PlusJakartaSans-Bold.ttf
│   ├── images/
│   │   ├── aparcamiento.png
│   │   └── hero_toledo.webp
│   └── svg/
│       ├── map_valle_cerro_bu.svg
│       └── map_juderia_walk.svg
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   └── toledo_geo_points.dart
│   │   ├── theme/
│   │   │   ├── toledo_colors.dart
│   │   │   ├── toledo_typography.dart
│   │   │   └── toledo_theme.dart
│   │   └── utils/
│   │       ├── map_launcher.dart
│   │       └── offline_cache_manager.dart
│   ├── data/
│   │   ├── datasources/
│   │   │   └── local_data_source.dart
│   │   ├── models/
│   │   │   ├── itinerary_item_model.dart
│   │   │   ├── audio_track_model.dart
│   │   │   ├── map_point_model.dart
│   │   │   └── expense_item_model.dart
│   │   └── repositories/
│   │       ├── itinerary_repository_impl.dart
│   │       └── audio_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── itinerary_item.dart
│   │   │   ├── audio_track.dart
│   │   │   └── expense_item.dart
│   │   └── repositories/
│   │       ├── itinerary_repository.dart
│   │       └── audio_repository.dart
│   ├── presentation/
│   │   ├── providers/
│   │   │   ├── itinerary_provider.dart
│   │   │   ├── audio_player_provider.dart
│   │   │   ├── map_provider.dart
│   │   │   ├── budget_provider.dart
│   │   │   └── navigation_provider.dart
│   │   ├── screens/
│   │   │   ├── main_navigation_shell.dart
│   │   │   ├── itinerary/
│   │   │   │   ├── itinerary_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── day_selector_pill.dart
│   │   │   │       ├── timeline_card.dart
│   │   │   │       └── monument_detail_sheet.dart
│   │   │   ├── maps/
│   │   │   │   ├── osm_map_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── osm_map_view.dart
│   │   │   │       ├── route_selector_bar.dart
│   │   │   │       ├── point_detail_card.dart
│   │   │   │       └── interactive_topo_svg_fallback.dart
│   │   │   ├── audios/
│   │   │   │   ├── audio_catalog_screen.dart
│   │   │   │   ├── full_player_sheet.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── persistent_mini_player.dart
│   │   │   │       └── audio_track_tile.dart
│   │   │   └── practical/
│   │   │       ├── budget_screen.dart
│   │   │       ├── accommodation_card.dart
│   │   │       └── zbe_parking_guide.dart
│   │   └── widgets/
│   │       ├── toledo_badge.dart
│   │       └── glass_card.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
```

---

## 6. Dependencias Oficiales (`flutter/pubspec.yaml`)

```yaml
name: toledo_mobile
description: Guía Turística Experta e Interactiva Toledo 2026 en Flutter
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # Arquitectura y Estado
  flutter_riverpod: ^2.5.1
  flutter_hooks: ^0.20.5
  hooks_riverpod: ^2.5.1

  # OpenStreetMap y Cartografía Offline
  flutter_map: ^7.0.2
  flutter_map_caching: ^1.0.0
  latlong2: ^0.9.1
  geolocator: ^12.0.0

  # Tipografía y Vectores
  google_fonts: ^6.2.1
  flutter_svg: ^2.0.10+1

  # Audio Profesional & Reproducción en Segundo Plano
  just_audio: ^0.9.38
  audio_service: ^0.18.15
  audio_session: ^0.1.19

  # Navegación y Utilidades Nativas
  url_launcher: ^6.3.0
  share_plus: ^9.0.0
  shared_preferences: ^2.2.3

  # Interacción y Animaciones
  animations: ^2.0.11

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.2

flutter:
  uses-material-design: true

  assets:
    - assets/audios/
    - assets/data/
    - assets/fonts/
    - assets/images/
    - assets/svg/
```

---

## 7. Especificación de Componentes Móviles Clave

### 7.1. Pantalla de Mapa Nativo OpenStreetMap (`OsmMapView`)
- Utiliza `flutter_map` centrado inicialmente en el casco histórico de Toledo (`39.8571, -4.0238`) con nivel de zoom 15.0.
- **Capas Superpuestas:**
  - `TileLayer`: Teselas de OpenStreetMap con cabecera identificativa y caché en disco.
  - `PolylineLayer`: Trazado coloreado de las rutas peatonales (Rojo imperial para el sendero del Valle, Carmesí para la Judería).
  - `MarkerLayer`: Marcadores personalizados con forma de pin toledano, mostrando el número de parada y el icono representativo.
- Al tocar un marcador, se abre un panel flotante inferior (*Bottom Sheet* deslizante) con foto, horario, botón de audioguía y botón GPS.

### 7.2. Mini-Player Flotante Persistente (`PersistentMiniPlayer`)
- Suspendido sobre el `BottomNavigationBar`, disponible en cualquier pantalla (Itinerario, Mapa o Presupuesto).
- Fondo translúcido con efecto glassmorphism oscuro (`ToledoColors.darkSlate.withOpacity(0.95)`), ribete dorado y barra de progreso áurea.
- Controles táctiles inmediatos: Play/Pause, Rebobinado 15s y Despliegue de la vista completa (`FullPlayerSheet`).
- **Segundo Plano Real:** Con `audio_service`, el audio sigue sonando con el móvil en el bolsillo mientras el usuario camina guiado por las indicaciones.

### 7.3. Tarjeta de Línea de Tiempo (`TimelineCard`)
- Muestra el tramo horario (`15:30 – 16:30`), título en tipografía señorial y badge de coste.
- Botón directo *"Ver en Mapa OSM"*: traslada la vista del mapa a las coordenadas exactas del monumento con una animación suave de cámara.
- Botón directo de audioguía en formato píldora (`▶ Escuchar 4:06`).

### 7.4. Calculadora de Gastos y Presupuesto (`BudgetScreen`)
- Tarjeta de cabecera con el total calculado: **129,26 €** por persona.
- Desglose por categorías (Tours guiados, Monumentos, Almuerzos toledanos, Alojamiento).
- Interruptor interactivo *"¿Pagado?"* guardado localmente con `shared_preferences`.

---

## 8. Plan de Ejecución Fase por Fase

### Fase 1: Creación del Proyecto Flutter en `/flutter` y Pipeline de Assets
- [ ] Inicializar el proyecto Flutter en el directorio ya existente `i:\___IA_viajes\toledo\flutter`.
- [ ] Configurar `pubspec.yaml` con `flutter_map`, `just_audio`, `flutter_riverpod`, etc.
- [ ] Copiar las 6 pistas MP3 desde `audios/mp3/` a `flutter/assets/audios/`.
- [ ] Estructurar los archivos JSON de datos en `flutter/assets/data/`: `itinerary.json`, `audioguides.json` y `routes_geojson.json`.
- [ ] Descargar e instalar las fuentes Cinzel y Plus Jakarta Sans en `flutter/assets/fonts/`.

### Fase 2: Sistema de Diseño & Entidades de Dominio
- [ ] Crear `toledo_colors.dart` y `toledo_theme.dart` reflejando fielmente los estilos del CSS.
- [ ] Definir los modelos de datos tipados (`ItineraryItem`, `AudioTrack`, `MapPoint`, `ExpenseItem`).
- [ ] Implementar el servicio `LocalDataSource` para lectura instantánea de JSON desde assets.

### Fase 3: Integración de OpenStreetMap y Rutas Georreferenciadas
- [ ] Implementar `OsmMapScreen` con `flutter_map` y `latlong2`.
- [ ] Incorporar la capa de polilíneas para el Sendero del Valle (Peña del Rey Moro + Cerro del Bú) y la Judería Mayor.
- [ ] Diseñar los marcadores personalizados con interacción táctil para mostrar `PointDetailCard`.
- [ ] Implementar la estrategia de almacenamiento en caché para visualización sin internet.

### Fase 4: Motor de Audio y Reproductor Persistente
- [ ] Implementar `AudioPlayerHandler` con `just_audio` y `audio_service` para reproducción en background.
- [ ] Crear el widget `PersistentMiniPlayer` integrado en el shell de navegación.
- [ ] Diseñar `FullPlayerSheet` con selector de velocidad y vista de transcripción completa.

### Fase 5: Pantallas de Itinerario, Alojamiento y Presupuesto
- [ ] Desarrollar la pantalla de Itinerario con selector segmentado de días y tarjetas de monumento.
- [ ] Desarrollar la vista de presupuesto interactivo con checkboxes de estado de pago.
- [ ] Crear la sección informativa de ZBE, Parking Safont y acceso a Casa de la Mezquita.

### Fase 6: Pruebas de Rendimiento y Validación Offline
- [ ] Comprobación exhaustiva en Modo Avión (cero peticiones de red).
- [ ] Verificación de fluidez a 60 fps con motor Impeller.
- [ ] Validación de la persistencia de audio con pantalla bloqueada.

---

## 9. Resumen de Requisitos Cumplidos

| Requisito | Implementación en este Plan | Estado |
| :--- | :--- | :--- |
| **Ubicación del código** | Se desarrollará directamente en la carpeta existente **`flutter/`** | Configurado |
| **API OpenStreetMap** | Mapas interactivos nativos con `flutter_map` (OpenStreetMap gratuito) + caché offline | Incorporado |
| **Optimización móvil** | Bottom Navigation, Thumb Zone, Slivers, Mini-Player persistente, hojas modales | Diseñado |
| **Diseño moderno & premium** | Tipografías Cinzel + Plus Jakarta, sombras suaves, micro-interacciones hápticas | Especificado |
| **Colores y estilo idénticos** | Carmesí Imperial (`#852221`), Oro Viejo (`#C28833`), Pizarra (`#111827`) y badges del HTML | Replicado al 100% |
| **Modo 100% Offline** | Audios MP3 locales en assets, JSON embebido, fuentes locales y teselas OSM en caché | Totalmente autónomo |
| **Audioguías integradas** | Reproducción en segundo plano con `just_audio` y `audio_service` | Integrado |
