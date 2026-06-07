import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/mock/horeca_data.dart';
import '../../data/mock/ukraine_locations.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/searchable_dropdown.dart';
import '../widgets/checkout_widgets.dart';
import '../utils/ui_utils.dart';
import '../utils/form_validators.dart';

class CheckoutServiceScreen extends StatefulWidget {
  final String id;
  const CheckoutServiceScreen({super.key, required this.id});
  @override
  State<CheckoutServiceScreen> createState() => _CheckoutServiceScreenState();
}

class _CheckoutServiceScreenState extends State<CheckoutServiceScreen> {
  bool isCompleted = false;
  bool _isFormValid = false;
  String payMethod = "card";

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
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
        FormValidators.isValidCompany(_companyController.text) &&
        FormValidators.isValidEmail(_emailController.text) &&
        FormValidators.isValidDate(_dateController.text) &&
        (payMethod != "card" || (FormValidators.isValidCardNumber(_cardNumberController.text) &&
            FormValidators.isValidExpiry(_expiryController.text) &&
            FormValidators.isValidCvc(_cvcController.text)));
  }

  void _checkFormValidity() {
    final valid = _validate();
    if (valid != _isFormValid) setState(() { _isFormValid = valid; });
  }

  @override
  void initState() {
    super.initState();
    _cityController.addListener(() {
      if (_cityController.text != _lastCity) {
        _lastCity = _cityController.text;
        _addressController.clear();
      }
    });
    for (final c in [_nameController, _companyController, _phoneController, _emailController, _cityController, _addressController, _dateController, _cardNumberController, _expiryController, _cvcController]) { c.addListener(_checkFormValidity); }
  }

  @override
  void dispose() {
    for (final c in [_nameController, _companyController, _phoneController, _emailController, _cityController, _addressController, _dateController, _notesController, _cardNumberController, _expiryController, _cvcController]) { c.dispose(); }
    super.dispose();
  }

  void _autofill() {
    setState(() {
      _nameController.text = "Марія Скрипник";
      _companyController.text = "Арома";
      _phoneController.text = "0951234567";
      _emailController.text = "maria@example.com";
      _cityController.text = "Київ";
      _addressController.text = "Відділення №1: вул. Пирогівський шлях, 135";
      _dateController.text = "03.06.2026";
      _cardNumberController.text = "4242424242424242";
      _expiryController.text = "12/27";
      _cvcController.text = "123";
    });
    _checkFormValidity();
  }

  void _submit() {
    if (!_validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(FormValidators.universalError)));
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() { isCompleted = true; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = getHorecaItem(widget.id);
    if (s == null) return const Scaffold(body: Center(child: Text("Послугу не знайдено")));
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    if (isCompleted) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle), child: const Icon(LucideIcons.check, color: Colors.white, size: 40)),
                const SizedBox(height: 24),
                const Text("Дякуємо!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text("Ваше замовлення на послугу «${s.name}» прийнято. Наш технолог зв'яжеться з вами найближчим часом.", style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground, height: 1.5), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  onPressed: () => context.go('/horeca'),
                  child: const Text("До каталогу послуг", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Замовлення послуги", style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(LucideIcons.chevronLeft, color: AppColors.foreground), onPressed: () => Navigator.pop(context)),
      ),
      body: Form(
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Container(height: 60, width: 60, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)), clipBehavior: Clip.antiAlias, child: Image.asset(s.image, fit: BoxFit.cover)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.category.toUpperCase(), style: const TextStyle(fontSize: 8, color: AppColors.mutedForeground, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(s.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(s.price == 0 ? "Безкоштовно" : "${s.price.toInt()} ₴ / ${s.unit}", style: const TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(children: [Icon(LucideIcons.clipboardList, color: AppColors.foreground, size: 16), SizedBox(width: 8), Text("Контактні дані", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))]),
                        TextButton.icon(onPressed: _autofill, icon: const Icon(LucideIcons.copy, size: 15), label: const Text("Автозаповнення", style: TextStyle(fontSize: 12))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    CheckoutTextField(label: "Ім'я та прізвище *", controller: _nameController, placeholder: "Марія Скрипник", validator: (value) => FormValidators.isValidName(value ?? "") ? null : FormValidators.universalError),
                    CheckoutTextField(label: "Назва закладу", controller: _companyController, placeholder: "Арома", validator: (value) => FormValidators.isValidCompany(value ?? "") ? null : FormValidators.universalError),
                    Row(
                      children: [
                        Expanded(child: CheckoutTextField(label: "Телефон *", controller: _phoneController, placeholder: "0951234567", isPhone: true, validator: (value) => FormValidators.isValidPhone(value ?? "") ? null : FormValidators.universalError)),
                        const SizedBox(width: 12),
                        Expanded(child: CheckoutTextField(label: "Email", controller: _emailController, placeholder: "you@example.com", validator: (value) => FormValidators.isValidEmail(value ?? "") ? null : FormValidators.universalError)),
                      ],
                    ),
                    SearchableDropdown(label: "Місто *", placeholder: "Введіть та оберіть місто", items: ukraineLocations, controller: _cityController, validator: (value) => FormValidators.isValidCity(value ?? "") ? null : FormValidators.universalError),
                    SearchableDropdown(
                      label: "Адреса виконання *",
                      placeholder: "Введіть та оберіть адресу",
                      items: getAddressesForCity(_cityController.text),
                      controller: _addressController,
                      validator: (value) {
                        final cityVal = _cityController.text.trim();
                        return (FormValidators.isValidCity(cityVal) && getAddressesForCity(cityVal).contains(value?.trim() ?? "")) ? null : FormValidators.universalError;
                      },
                    ),
                    CheckoutTextField(label: "Бажана дата", controller: _dateController, placeholder: "ДД.ММ.РРРР", validator: (value) => FormValidators.isValidDate(value ?? "") ? null : FormValidators.universalError),
                    CheckoutTextField(label: "Коментар", controller: _notesController, placeholder: "Деталі замовлення...", maxLines: 3),
                    const SizedBox(height: 24),
                    const Row(children: [Icon(LucideIcons.creditCard, color: AppColors.foreground, size: 18), SizedBox(width: 8), Text("Оплата", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 12),
                    PaymentMethodSelector(selectedMethod: payMethod, onChanged: (val) => setState(() { payMethod = val; _checkFormValidity(); })),
                    if (payMethod == "card") CardDetailsForm(cardNumberController: _cardNumberController, expiryController: _expiryController, cvcController: _cvcController),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _isFormValid ? AppColors.accent : AppColors.mutedForeground, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: _isFormValid ? _submit : null,
                    child: const Text("Підтвердити замовлення", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}