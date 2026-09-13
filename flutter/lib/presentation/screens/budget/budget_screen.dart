import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/toledo_colors.dart';
import '../../providers/budget_provider.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  Future<void> _openMaps(String query) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(budgetDataProvider);
    final paidItems = ref.watch(paidItemsProvider);

    return Scaffold(
      backgroundColor: ToledoColors.bgBody,
      body: budgetAsync.when(
        data: (budget) {
          // Calcular total pagado vs pendiente
          double totalPaid = 0;
          for (final item in budget.items) {
            if (paidItems.contains(item.id)) {
              totalPaid += item.priceActual;
            }
          }

          return CustomScrollView(
            slivers: [
              // Header Imperial
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                  decoration: const BoxDecoration(
                    color: ToledoColors.darkSlate,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ToledoColors.accent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ToledoColors.accent.withOpacity(0.4)),
                        ),
                        child: Text(
                          'PRESUPUESTO & GUÍA PRÁCTICA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: ToledoColors.accent,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Gastos & Logística',
                        style: GoogleFonts.cinzel(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Tarjeta de Resumen Económico
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ToledoColors.darkCard,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: ToledoColors.accent.withOpacity(0.4)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'TOTAL ESTIMADO POR PERSONA',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: ToledoColors.textLight,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${budget.totalPerPerson.toStringAsFixed(2)} €',
                                      style: GoogleFonts.cinzel(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: ToledoColors.accent,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: ToledoColors.badgeFreeBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'PAGADO HASTA AHORA',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: ToledoColors.badgeFreeText,
                                        ),
                                      ),
                                      Text(
                                        '${totalPaid.toStringAsFixed(2)} €',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: ToledoColors.badgeFreeText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: Colors.white12, height: 1),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Actividades: ${budget.subtotalActivities.toStringAsFixed(2)} €',
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  'Alojamiento: ${budget.subtotalAccommodation.toStringAsFixed(2)} €',
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sección 1: Alojamiento & ZBE Tips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    children: [
                      // Tarjeta Alojamiento
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: ToledoColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: ToledoColors.primaryLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.hotel_rounded, color: ToledoColors.primary, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Casa de la Mezquita',
                                        style: GoogleFonts.cinzel(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: ToledoColors.primaryDark,
                                        ),
                                      ),
                                      const Text(
                                        'Cuesta de Carmelitas Descalzos, 5',
                                        style: TextStyle(fontSize: 12, color: ToledoColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.navigation_outlined, color: ToledoColors.primary),
                                  onPressed: () => _openMaps('Cuesta de Carmelitas Descalzos 5 Toledo'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Alojamiento confirmado para el grupo. Tarifa: ~38,26 € por persona/noche. Ubicado en el corazón del casco a 350 m de la salida de las escaleras mecánicas del Miradero.',
                              style: TextStyle(fontSize: 12.5, color: ToledoColors.textMain, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tarjeta Parking Safont & ZBE
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ToledoColors.badgePriceBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: ToledoColors.badgePriceBorder),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.local_parking_rounded, color: ToledoColors.badgePriceText, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PARKING SAFONT (RECOMENDADO)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: ToledoColors.badgePriceText,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'El casco histórico tiene cámaras ZBE con multas automáticas. Deja el coche gratis en el Parking Safont (junto al río) y sube cómodamente al centro por las escaleras mecánicas del Miradero (3 minutos a pie).',
                                    style: TextStyle(fontSize: 12, color: ToledoColors.badgePriceText, height: 1.4),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _openMaps('Parking Safont Toledo'),
                                    child: const Text(
                                      'Abrir Parking Safont en GPS →',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: ToledoColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Título Desglose de Gastos
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DESGLOSE DE GASTOS',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: ToledoColors.primaryDark,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const Text(
                        'Marcar como pagado',
                        style: TextStyle(fontSize: 11, color: ToledoColors.textLight),
                      ),
                    ],
                  ),
                ),
              ),

              // Lista interactiva de gastos
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = budget.items[index];
                      final isPaid = paidItems.contains(item.id);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isPaid ? ToledoColors.badgeFreeBorder : ToledoColors.border),
                        ),
                        child: CheckboxListTile(
                          activeColor: ToledoColors.badgeFreeText,
                          value: isPaid,
                          onChanged: (_) {
                            ref.read(paidItemsProvider.notifier).toggleItem(item.id);
                          },
                          title: Text(
                            item.concept,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              decoration: isPaid ? TextDecoration.lineThrough : null,
                              color: isPaid ? ToledoColors.textMuted : ToledoColors.textMain,
                            ),
                          ),
                          subtitle: Text(
                            '${item.day} · ${item.notes}',
                            style: const TextStyle(fontSize: 11, color: ToledoColors.textLight),
                          ),
                          secondary: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.isFree ? ToledoColors.badgeFreeBg : ToledoColors.badgePriceBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.isFree ? 'Gratis' : '${item.priceActual.toStringAsFixed(2)} €',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: item.isFree ? ToledoColors.badgeFreeText : ToledoColors.badgePriceText,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: budget.items.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: ToledoColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error cargando presupuesto: $err'),
        ),
      ),
    );
  }
}
