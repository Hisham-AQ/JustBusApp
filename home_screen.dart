import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController fromCtrl = TextEditingController(text: 'Home');
  final TextEditingController toCtrl = TextEditingController(text: 'JUST');

  DateTime selectedDate = DateTime(2026, 1, 1);
  int persons = 1;

  @override
  void dispose() {
    fromCtrl.dispose();
    toCtrl.dispose();
    super.dispose();
  }

  void swapLocations() {
    final tmp = fromCtrl.text;
    setState(() {
      fromCtrl.text = toCtrl.text;
      toCtrl.text = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final just = LatLng(32.4953, 35.9900);

    return Scaffold(
      body: Stack(
        children: [
          // MAP (full screen)
          FlutterMap(
            options: MapOptions(
              initialCenter: just,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.justbus_v1',
              ),
              // marker at JUST
              MarkerLayer(
                markers: [
                  Marker(
                    point: just,
                    width: 46,
                    height: 46,
                    child: const Icon(Icons.directions_bus_rounded, size: 40, color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),

          // TOP OVERLAY (Search + Menu)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 18,
                            offset: Offset(0, 8),
                            color: Color(0x22000000),
                          )
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search_rounded),
                          SizedBox(width: 10),
                          Text(
                            'Search location',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 8),
                          color: Color(0x22000000),
                        )
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM SHEET (UI)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30,
                    offset: Offset(0, -10),
                    color: Color(0x22000000),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Where would like\nto go today ?',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // From/To box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _InputPill(controller: fromCtrl),
                                const SizedBox(height: 12),
                                _InputPill(controller: toCtrl),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: swapLocations,
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F4B63),
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: const Icon(
                                Icons.swap_vert_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Date + Persons row
                    Row(
                      children: [
                        Expanded(
                          child: _SmallInfoCard(
                            icon: Icons.calendar_month_rounded,
                            text: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2035),
                              );
                              if (picked != null) {
                                setState(() => selectedDate = picked);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SmallInfoCard(
                            icon: Icons.people_alt_rounded,
                            text: '$persons Person',
                            onTap: () {
                              setState(() {
                                persons = (persons % 5) + 1; // 1..5 quick
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Search button
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: later navigate to results / routes
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Searching: ${fromCtrl.text} → ${toCtrl.text}')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F4B63),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Search',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* =======================
   Small widgets
======================= */

class _InputPill extends StatelessWidget {
  final TextEditingController controller;
  const _InputPill({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _SmallInfoCard({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }
}
