import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const List<Map<String, String>> countries = [
  {'name': 'Afghanistan', 'code': 'af', 'flag': '🇦🇫'},
  {'name': 'Albania', 'code': 'al', 'flag': '🇦🇱'},
  {'name': 'Algeria', 'code': 'dz', 'flag': '🇩🇿'},
  {'name': 'Angola', 'code': 'ao', 'flag': '🇦🇴'},
  {'name': 'Australia', 'code': 'au', 'flag': '🇦🇺'},
  {'name': 'Austria', 'code': 'at', 'flag': '🇦🇹'},
  {'name': 'Azerbaijan', 'code': 'az', 'flag': '🇦🇿'},
  {'name': 'Argentina', 'code': 'ar', 'flag': '🇦🇷'},
  // ... add more countries as needed
];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedCountryCode;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('settings');
    selectedCountryCode = box.get('country', defaultValue: 'us');
  }

  void _showCountryPicker() async {
    String tempSelected = selectedCountryCode ?? 'us';
    TextEditingController searchController = TextEditingController();
    List<Map<String, String>> filteredCountries = List.from(countries);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void filterCountries(String query) {
              setModalState(() {
                filteredCountries =
                    countries
                        .where(
                          (country) => country['name']!.toLowerCase().contains(
                            query.toLowerCase(),
                          ),
                        )
                        .toList();
              });
            }

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: 520,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Select your country',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: filterCountries,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = filteredCountries[index];
                          return ListTile(
                            leading: Text(
                              country['flag'] ?? '',
                              style: const TextStyle(fontSize: 28),
                            ),
                            title: Text(
                              country['name'] ?? '',
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: Radio<String>(
                              value: country['code']!,
                              groupValue: tempSelected,
                              activeColor: Colors.red.shade700,
                              onChanged: (value) {
                                setModalState(() {
                                  tempSelected = value!;
                                });
                              },
                            ),
                            onTap: () {
                              setModalState(() {
                                tempSelected = country['code']!;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedCountryCode = tempSelected;
                            });
                            Hive.box('settings').put('country', tempSelected);
                            Navigator.pop(context);
                          },
                          child: const Text('Save', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
        title: const Text(
          'NEWST',
          style: TextStyle(
            fontFamily: 'Serif',
            color: Color(0xFFD32F2F),
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 56,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage('https://i.ibb.co/6bQ6q6d/avatar-demo.png'),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Usama Elgendy',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile Info',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _ProfileListTile(icon: Icons.person_outline, title: 'Personal Info'),
                const Divider(),
                _ProfileListTile(icon: Icons.language, title: 'Language'),
                const Divider(),
                _ProfileListTile(
                  icon: Icons.flag_outlined,
                  title: 'Country',
                  subtitle:
                      countries.firstWhere(
                        (c) => c['code'] == selectedCountryCode,
                        orElse: () => countries[0],
                      )['name'],
                  onTap: _showCountryPicker,
                ),
                const Divider(),
                _ProfileListTile(
                  icon: Icons.article_outlined,
                  title: 'Terms & Conditions',
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red.shade700),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(Icons.arrow_forward, color: Colors.red.shade700),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFAFAFA),
    );
  }
}

class _ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  const _ProfileListTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle:
          subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 13)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
