import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/models/order.dart';
import '../../data/api/api_service.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/status_badge.dart';
import '../widgets/custom_app_bar.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.instance.getAuthenticated('/orders');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _orders = data.map((json) => Order.fromJson(json)).toList();
        });
      }
    } catch (_) {
      // Silently handle errors
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "Мої замовлення"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.packageOpen, size: 48, color: AppColors.mutedForeground),
                      const SizedBox(height: 16),
                      const Text("У вас ще немає замовлень", style: TextStyle(fontSize: 16, color: AppColors.mutedForeground)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/catalog'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        child: const Text("Перейти до каталогу", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadOrders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      final dateStr = order.createdAt.length >= 10 ? order.createdAt.substring(0, 10) : order.createdAt;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Замовлення #${(index + 1)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  StatusBadge(status: order.status),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(dateStr, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                              const Divider(height: 20),
                              ...order.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text("${item.name} x${item.quantity}", style: const TextStyle(fontSize: 13))),
                                    Text("${(item.price * item.quantity).toInt()} ₴", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Всього:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text("${order.total.toInt()} ₴", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.accent)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}