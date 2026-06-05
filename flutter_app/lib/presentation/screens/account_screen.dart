import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import '../../bloc/auth/auth_notifier.dart';
import '../../core/theme/app_colors.dart';
import '../../core/config/env.dart';
import '../utils/ui_utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  bool _isEditing = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final token = AuthNotifier.instance.token;
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _profile = data;
          _nameController.text = data['name'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _cityController.text = data['city'] ?? '';
          _addressController.text = data['address'] ?? '';
        });
      }
    } catch (_) {
      // Fallback silently
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    try {
      final token = AuthNotifier.instance.token;
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'city': _cityController.text.trim(),
          'address': _addressController.text.trim(),
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _profile = data;
          _isEditing = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Профіль оновлено')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка збереження: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    final menu = [
      {"icon": LucideIcons.package, "label": "Мої замовлення", "route": "/orders"},
      {"icon": LucideIcons.wrench, "label": "Мої послуги", "route": "/services"},
      {"icon": LucideIcons.mapPin, "label": "Адреси доставки", "route": null},
      {"icon": LucideIcons.creditCard, "label": "Способи оплати", "route": null},
      {"icon": LucideIcons.settings, "label": "Налаштування", "route": null},
      {"icon": LucideIcons.logOut, "label": "Вихід", "route": "logout"},
    ];

    final displayName = (_profile?['name'] != null && _profile!['name'].toString().trim().isNotEmpty)
        ? _profile!['name']
        : 'Користувач';
    final displayEmail = _profile?['email'] ?? '';
    final letter = getAvatarLetter(_profile?['name'], _profile?['email']);
    final avatarColor = getAvatarColor(displayEmail.isNotEmpty ? displayEmail : displayName);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Акаунт", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground),
          onPressed: () => context.go('/'),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(LucideIcons.edit, color: AppColors.foreground, size: 20),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(LucideIcons.check, color: AppColors.accent, size: 20),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile details card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.shadowSoft,
                      ),
                      child: _isEditing
                          ? Column(
                              children: [
                                TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Ім'я")),
                                const SizedBox(height: 8),
                                TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Телефон")),
                                const SizedBox(height: 8),
                                TextField(controller: _cityController, decoration: const InputDecoration(labelText: "Місто")),
                                const SizedBox(height: 8),
                                TextField(controller: _addressController, decoration: const InputDecoration(labelText: "Адреса")),
                              ],
                            )
                          : Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: avatarColor,
                                  child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(displayEmail, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                                  ],
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Menu list
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.shadowSoft,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menu.length,
                        separatorBuilder: (context, idx) => const Divider(height: 1, color: AppColors.border),
                        itemBuilder: (context, idx) {
                          final item = menu[idx];
                          return ListTile(
                            leading: Icon(item["icon"] as IconData, color: AppColors.mutedForeground, size: 20),
                            title: Text(item["label"] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            trailing: const Icon(LucideIcons.chevronRight, color: AppColors.mutedForeground, size: 16),
                            onTap: () {
                              final route = item["route"];
                              if (route == "logout") {
                                AuthNotifier.instance.logout();
                                context.go('/');
                              } else if (route != null) {
                                context.push(route as String);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Сервіс '${item["label"]}' незабаром з'явиться!")),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ----------------------------------------------------
// 8. HORECA SERVICES SCREEN
// ----------------------------------------------------