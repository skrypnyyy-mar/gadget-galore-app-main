import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import '../../data/mock/ukraine_locations.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../bloc/cart/cart_state.dart';
import '../../bloc/auth/auth_notifier.dart';
import '../../core/theme/app_colors.dart';
import '../../core/config/env.dart';
import '../widgets/searchable_dropdown.dart';
import '../widgets/checkout_widgets.dart';
import '../utils/delivery_utils.dart';
import '../utils/ui_utils.dart';
import '../utils/form_validators.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String payMethod = "card";
  bool isLoading = false;
  bool _isFormValid = false;
  double? _deliveryCost;
  Future<double>? _deliveryCostFuture;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  String _lastCity = "";

  bool _validate() {
    return FormValidators.isValidName(_nameController.text) &&
        FormValidators.isValidPhone(_phoneController.text) &&
        FormValidators.isValidCity(_cityController.text) &&
        _addressController.text.trim().isNotEmpty &&
        getAddressesForCity(_cityController.text.trim()).contains(_addressController.text.trim()) &&
        (payMethod != "card" || (FormValidators.isValidCardNumber(_cardNumberController.text) &&
            FormValidators.isValidExpiry(_expiryController.text) &&
            FormValidators.isValidCvc(_cvcController.text)));
  }

  void _checkFormValidity() {
    final valid = _validate() && _deliveryCost != null;
    if (valid != _isFormValid) setState(() { _isFormValid = valid; });
  }

  @override
  void initState() {
    super.initState();
    _deliveryCostFuture = estimateDeliveryCost(context.read<CartBloc>().state.items).then((cost) {
      if (mounted) setState(() { _deliveryCost = cost; _checkFormValidity(); });
      return cost;
    });
    _cityController.addListener(() {
      if (_cityController.text != _lastCity) {
        _lastCity = _cityController.text;
        _addressController.clear();
      }
    });
    for (final c in [_nameController, _phoneController, _cityController, _addressController, _cardNumberController, _expiryController, _cvcController]) { c.addListener(_checkFormValidity); }
  }

  @override
  void dispose() {
    for (final c in [_nameController, _phoneController, _cityController, _addressController, _cardNumberController, _expiryController, _cvcController]) { c.dispose(); }
    super.dispose();
  }

  void autofillData() {
    setState(() {
      _nameController.text = "Марія Скрипник";
      _phoneController.text = "0951234567";
      _cityController.text = "Київ";
      _addressController.text = "Відділення №1: вул. Пирогівський шлях, 135";
      _cardNumberController.text = "4242424242424242";
      _expiryController.text = "12/27";
      _cvcController.text = "123";
    });
    _checkFormValidity();
  }

  Future<void> _submit() async {
    if (!_validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FormValidators.universalError)));
      return;
    }
    setState(() => isLoading = true);
    final cartBloc = context.read<CartBloc>();
    final router = GoRouter.of(context);
    final total = cartBloc.state.subtotal + (_deliveryCost ?? 100.0);
    try {
      final token = AuthNotifier.instance.token;
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/checkout'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'items': cartBloc.state.items.map((i) => {'productId': i.product.id, 'name': i.product.name, 'quantity': i.quantity, 'price': i.product.price}).toList(),
          'total': total,
          'deliveryCost': _deliveryCost ?? 100.0,
          'paymentMethod': payMethod,
        }),
      );
      if (response.statusCode == 200) {
        cartBloc.add(ClearCart());
        if (mounted) router.go('/success');
      } else {
        final err = jsonDecode(response.body)['error'] ?? 'Checkout failed';
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Помилка: $err')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Помилка мережі: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Оформлення", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground), onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 20.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(children: [Icon(LucideIcons.truck, color: AppColors.foreground, size: 18), SizedBox(width: 8), Text("Доставка", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))]),
                            TextButton.icon(onPressed: autofillData, icon: const Icon(LucideIcons.copy, size: 16), label: const Text("Збережені дані (Автозаповнення)")),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CheckoutTextField(label: "Ім'я та прізвище *", controller: _nameController, placeholder: "Марія Скрипник", validator: (value) => FormValidators.isValidName(value ?? "") ? null : FormValidators.universalError),
                        CheckoutTextField(label: "Телефон *", controller: _phoneController, placeholder: "0951234567", isPhone: true, validator: (value) => FormValidators.isValidPhone(value ?? "") ? null : FormValidators.universalError),
                        SearchableDropdown(label: "Місто *", placeholder: "Введіть та оберіть місто", items: ukraineLocations, controller: _cityController, validator: (value) => FormValidators.isValidCity(value ?? "") ? null : FormValidators.universalError),
                        SearchableDropdown(
                          label: "Адреса відділення *",
                          placeholder: "Введіть та оберіть відділення Нової Пошти",
                          items: getAddressesForCity(_cityController.text),
                          controller: _addressController,
                          validator: (value) {
                            final cityVal = _cityController.text.trim();
                            return (FormValidators.isValidCity(cityVal) && getAddressesForCity(cityVal).contains(value?.trim() ?? "")) ? null : FormValidators.universalError;
                          },
                        ),
                        const SizedBox(height: 24),
                        const Row(children: [Icon(LucideIcons.creditCard, color: AppColors.foreground, size: 18), SizedBox(width: 8), Text("Оплата", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))]),
                        const SizedBox(height: 12),
                        PaymentMethodSelector(selectedMethod: payMethod, onChanged: (val) => setState(() { payMethod = val; _checkFormValidity(); })),
                        if (payMethod == "card") CardDetailsForm(cardNumberController: _cardNumberController, expiryController: _expiryController, cvcController: _cvcController),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return FutureBuilder<double>(
                      future: _deliveryCostFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.border)),
                            child: const SafeArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent)),
                                  SizedBox(width: 16),
                                  Text("Розрахунок вартості доставки...", style: TextStyle(fontSize: 14, color: AppColors.mutedForeground)),
                                ],
                              ),
                            ),
                          );
                        }
                        final deliveryCost = snapshot.data ?? 100.0;
                        final total = state.subtotal + deliveryCost;
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
                          child: SafeArea(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Доставка: ${deliveryCost.toInt()} ₴", style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                                    const SizedBox(height: 4),
                                    Text("До сплати: ${total.toInt()} ₴", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                                  ],
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: _isFormValid ? AppColors.accent : AppColors.mutedForeground, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                                  onPressed: _isFormValid ? _submit : null,
                                  child: Text(payMethod == "apple" ? "Сплатити Apple Pay" : "Сплатити", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          if (isLoading) Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}