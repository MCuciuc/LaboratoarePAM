import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical App',
      theme: ThemeData(
        primaryColor: const Color(0xFF149BB0),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF149BB0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profil
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/frame.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Hi, Jonathan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('May you always be healthy', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.black87),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search something',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Card cu programarea curentă
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppointmentDetailsScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Appointment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Icon(Icons.calendar_today, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text('22 October, 2023', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.access_time, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text('08:00 AM - 10.30 AM', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('assets/Rectangle 22454.png', width: 45, height: 45, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Dr. Richar Kandowen',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Child Specialist',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chat_bubble_outline, color: Colors.black87),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Health Services
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Health Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: primaryColor))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _ServiceIcon(icon: Icons.cleaning_services, label: 'Tooth'),
                  _ServiceIcon(icon: Icons.remove_red_eye, label: 'Eye'),
                  _ServiceIcon(icon: Icons.air, label: 'Lungs'),
                  _ServiceIcon(icon: Icons.hearing, label: 'Ear'),
                ],
              ),
              const SizedBox(height: 24),

              // Nearby Doctor
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nearby Doctor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: primaryColor))),
                ],
              ),
              _DoctorTile(
                name: 'Dr. Emmly Lestiryno',
                role: 'General Practitioner',
                distance: '3167 Durgan Shores - 500M from you',
                imagePath: 'assets/Ellipse 142.png',
              ),
              _DoctorTile(
                name: 'Dr. Sonja Littel',
                role: 'Dental Specialist',
                distance: '950 Sigrid Port - 753M from you',
                imagePath: 'assets/Ellipse 142 (1).png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ServiceIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: Colors.orangeAccent),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _DoctorTile extends StatelessWidget {
  final String name;
  final String role;
  final String distance;
  final String imagePath;

  const _DoctorTile({
    required this.name,
    required this.role,
    required this.distance,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AppointmentDetailsScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    role,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Color(0xFF149BB0)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          distance,
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.favorite_border, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF149BB0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Appointment',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Card Doctor
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset('assets/Rectangle 35.png', width: 80, height: 90, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Dr.Upul',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            _roundIconButton(Icons.chat_bubble_outline),
                            const SizedBox(width: 4),
                            _roundIconButton(Icons.phone_outlined),
                            const SizedBox(width: 4),
                            _roundIconButton(Icons.videocam_outlined),
                          ],
                        ),
                        const Text('Denteeth', style: TextStyle(color: primaryColor, fontSize: 12)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('\$120.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Details
              const Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Worem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum, ac aliquet odio mattis.',
                style: TextStyle(color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 24),

              // Working Hours
              _buildSectionHeader('Working Hours'),
              const SizedBox(height: 12),
              Row(
                children: [
                  _timeChip('10.00 AM', false),
                  const SizedBox(width: 8),
                  _timeChip('11.00 AM', true),
                  const SizedBox(width: 8),
                  _timeChip('12.00 PM', false),
                ],
              ),
              const SizedBox(height: 24),

              // Date
              _buildSectionHeader('Date'),
              const SizedBox(height: 12),
              Row(
                children: [
                  _dateChip('Sun 4', true),
                  const SizedBox(width: 8),
                  _dateChip('Mon 5', false),
                  const SizedBox(width: 8),
                  _dateChip('Tue 6', false),
                ],
              ),
              const SizedBox(height: 32),

              // Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {},
                  child: const Text('Book an Appointment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _roundIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(color: Color(0xFFEFEFEF), shape: BoxShape.circle),
      child: Icon(icon, size: 16, color: Colors.black87),
    );
  }

  static Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: Color(0xFF149BB0)))),
      ],
    );
  }

  static Widget _timeChip(String text, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF149BB0) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static Widget _dateChip(String text, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF149BB0) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}