import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/toledo_colors.dart';
import '../widgets/persistent_mini_player.dart';
import 'itinerary/itinerary_screen.dart';
import 'map/osm_map_screen.dart';
import 'restaurants/restaurants_screen.dart';
import 'audio/audioguides_screen.dart';
import 'budget/budget_screen.dart';

final currentNavIndexProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentNavIndexProvider);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final screens = const [
      ItineraryScreen(),
      OsmMapScreen(),
      RestaurantsScreen(),
      AudioguidesScreen(),
      BudgetScreen(),
    ];

    final titles = const [
      'Itinerario por Días',
      'Mapa General OSM',
      'Dónde Comer Barato',
      'Audioguías Oficiales',
      'Gastos & Logística',
    ];

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ToledoColors.bgBody,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
          tooltip: 'Abrir menú principal',
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: ToledoColors.primary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ToledoColors.accent, width: 1.2),
              ),
              child: const Icon(Icons.shield_outlined, color: ToledoColors.accent, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOLEDO 2026',
                    style: GoogleFonts.cinzel(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    titles[currentIndex],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: ToledoColors.textLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: _CollapsibleNavigationDrawer(
        currentIndex: currentIndex,
        onSelectIndex: (index) {
          ref.read(currentNavIndexProvider.notifier).state = index;
        },
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PersistentMiniPlayer(),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleNavigationDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelectIndex;

  const _CollapsibleNavigationDrawer({
    required this.currentIndex,
    required this.onSelectIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ToledoColors.darkSlate,
      child: Column(
        children: [
          // Cabecera Imperial del Panel Colapsable
          DrawerHeader(
            decoration: const BoxDecoration(
              color: ToledoColors.primaryDark,
              border: Border(bottom: BorderSide(color: ToledoColors.accent, width: 1.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 52,
                  decoration: BoxDecoration(
                    color: ToledoColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: ToledoColors.accent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shield_rounded, color: ToledoColors.accent, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOLEDO 2026',
                        style: GoogleFonts.cinzel(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Panel de Navegación',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: ToledoColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Secciones Principales
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              children: [
                _DrawerMenuItem(
                  icon: Icons.explore_rounded,
                  title: 'Itinerario por Días',
                  subtitle: 'Lista de tarjetas y mapa diario',
                  isSelected: currentIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectIndex(0);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.map_rounded,
                  title: 'Mapa General OSM',
                  subtitle: 'Todos los monumentos y rutas',
                  isSelected: currentIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectIndex(1);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.restaurant_rounded,
                  title: 'Dónde Comer Barato',
                  subtitle: 'Menús de 12€-15€ y carcamusas',
                  isSelected: currentIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectIndex(2);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.headphones_rounded,
                  title: 'Audioguías Oficiales',
                  subtitle: 'Locuciones históricas offline',
                  isSelected: currentIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectIndex(3);
                  },
                ),
                _DrawerMenuItem(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Gastos & Logística',
                  subtitle: 'Alojamiento, parking y cuentas',
                  isSelected: currentIndex == 4,
                  onTap: () {
                    Navigator.pop(context);
                    onSelectIndex(4);
                  },
                ),
              ],
            ),
          ),

          // Pie del Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.offline_pin_rounded, color: ToledoColors.accent, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Guía 100% Offline Activada',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected ? ToledoColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? ToledoColors.accent : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : ToledoColors.accent,
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.cinzel(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : ToledoColors.textLight,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            color: isSelected ? Colors.white.withOpacity(0.8) : Colors.white38,
          ),
        ),
      ),
    );
  }
}
