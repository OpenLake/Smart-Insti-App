
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ultimate_theme.dart';
import '../../services/transport_service.dart';

final busRoutesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  return ref.read(transportServiceProvider).getBusRoutes();
});

class TransportScreen extends ConsumerWidget {
  const TransportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(busRoutesProvider);

    return Scaffold(
      backgroundColor: UltimateTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Transport Tracker", style: GoogleFonts.outfit(color: UltimateTheme.textColor, fontWeight: FontWeight.bold)),
        backgroundColor: UltimateTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: UltimateTheme.textColor),
      ),
      body: routesAsync.when(
        data: (routes) {
            if (routes.isEmpty) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Icon(Icons.directions_bus_outlined, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text("No active bus routes", style: GoogleFonts.outfit(color: Colors.grey, fontSize: 18))
                        ],
                    )
                );
            }
            return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: routes.length,
                itemBuilder: (context, index) {
                    final route = routes[index];
                    return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        child: ExpansionTile(
                            leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Icon(Icons.directions_bus, color: Colors.blue),
                            ),
                            title: Text(route['routeName'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                            subtitle: Text("Bus: ${route['busNumber'] ?? 'N/A'}", style: GoogleFonts.outfit(color: Colors.grey[600])),
                            children: [
                                Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            if (route['driverName'] != null)
                                                Padding(
                                                    padding: const EdgeInsets.only(bottom: 12),
                                                    child: Row(
                                                        children: [
                                                            const Icon(Icons.person, size: 16, color: Colors.grey),
                                                            const SizedBox(width: 8),
                                                            Text("Driver: ${route['driverName']}", style: GoogleFonts.outfit()),
                                                            const Spacer(),
                                                            if (route['driverContact'] != null)
                                                                const Icon(Icons.phone, size: 16, color: Colors.green)
                                                        ],
                                                    ),
                                                ),
                                            const Divider(),
                                            const SizedBox(height: 8),
                                            Text("Stops & Schedule", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: UltimateTheme.primaryColor)),
                                            const SizedBox(height: 8),
                                            ...(route['stops'] as List).map<Widget>((stop) {
                                                return Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                                    child: Row(
                                                        children: [
                                                            const Icon(Icons.circle, size: 8, color: Colors.blue),
                                                            const SizedBox(width: 12),
                                                            Expanded(child: Text(stop['stopName'], style: GoogleFonts.outfit())),
                                                            Text(stop['time'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                                                        ],
                                                    ),
                                                );
                                            }).toList(),
                                            const SizedBox(height: 12),
                                            Wrap(
                                                spacing: 8,
                                                children: (route['schedule'] as List).map<Widget>((day) => 
                                                    Chip(
                                                        label: Text(day.substring(0, 3), style: const TextStyle(fontSize: 10)),
                                                        visualDensity: VisualDensity.compact,
                                                    )
                                                ).toList(),
                                            )
                                        ],
                                    ),
                                )
                            ],
                        ),
                    );
                },
            );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e"))
      ),
    );
  }
}
