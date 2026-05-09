import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'map_picker_screen.dart'; // ── MAP PICKER SCREEN IMPORT ──

// ── GLOBAL ADDRESS MODEL & STATE ──
class UserAddress {
  String type; // Home, Office, Other
  String fullName;
  String countryCode; // E.g., +91, +1
  String phoneNumber; // 10 digit number
  String houseNo;
  String area;
  String pincode;

  // ── SMART GETTERS (Baaki files ko change hone se bachaenge) ──
  String get phone => "$countryCode $phoneNumber"; 
  String get completeAddress => "$houseNo, $area, Pincode/Zip - $pincode";
  String get shortAddress => "$houseNo, $pincode";

  UserAddress({
    required this.type,
    required this.fullName,
    required this.countryCode,
    required this.phoneNumber,
    required this.houseNo,
    required this.area,
    required this.pincode,
  });
}

// Global list of addresses. Starts empty.
List<UserAddress> globalSavedAddresses = [];

// Notifier to track which address is currently selected. -1 means none selected.
ValueNotifier<int> selectedAddressNotifier = ValueNotifier<int>(-1);

// ── ADDRESS SCREEN UI ──
class AddressScreen extends StatefulWidget {
  final bool isDark;
  final Color themeColor;

  const AddressScreen({super.key, required this.isDark, required this.themeColor});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Color get _bgColor => widget.isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  Color get _cardBgColor => widget.isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _textPrimary => widget.isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _textSecondary => widget.isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);
  Color get _borderColor => widget.isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Select Delivery Address', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: globalSavedAddresses.isEmpty
                ? _buildEmptyState()
                : _buildAddressList(),
          ),
          
          // ── ADD NEW ADDRESS BUTTON (Opens Map First) ──
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () async {
                  // 1. Open Map Picker
                  final result = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => MapPickerScreen(isDark: widget.isDark, themeColor: widget.themeColor))
                  );

                  // 2. If user confirmed location on map, open form with pre-filled data
                  if (result != null && result is Map) {
                    _showAddressSheet(
                      mapHouse: result['house'],
                      mapArea: result['area'],
                      mapPin: result['pin'],
                    );
                  }
                },
                icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
                label: const Text('Add New Address', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 80, color: _textSecondary.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text("No Addresses Saved", style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text("Please add a delivery address to continue", style: TextStyle(color: _textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: globalSavedAddresses.length,
      itemBuilder: (context, index) {
        final addr = globalSavedAddresses[index];
        final isSelected = selectedAddressNotifier.value == index;
        IconData typeIcon = addr.type == 'Home' ? Icons.home_rounded : addr.type == 'Office' ? Icons.work_outline : Icons.location_on_outlined;

        return GestureDetector(
          onTap: () {
            selectedAddressNotifier.value = index;
            Navigator.pop(context); // Go back after selecting
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? widget.themeColor.withOpacity(0.05) : _cardBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? widget.themeColor : _borderColor, width: isSelected ? 1.5 : 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(typeIcon, color: isSelected ? widget.themeColor : _textSecondary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(addr.type, style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                              const SizedBox(width: 8),
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: widget.themeColor, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('SELECTED', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                )
                            ],
                          ),
                          Row(
                            children: [
                              // ── EDIT BUTTON ──
                              GestureDetector(
                                onTap: () => _showAddressSheet(editIndex: index),
                                child: Icon(Icons.edit_outlined, color: widget.themeColor, size: 20),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 12),
                                Icon(Icons.check_circle, color: widget.themeColor, size: 20),
                              ]
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(addr.completeAddress, style: TextStyle(color: _textSecondary, fontSize: 12, height: 1.4)),
                      const SizedBox(height: 8),
                      Text('${addr.fullName}  •  ${addr.phone}', style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── BOTTOM SHEET FOR ADDING/EDITING ADDRESS ──
  void _showAddressSheet({int? editIndex, String? mapHouse, String? mapArea, String? mapPin}) {
    bool isEdit = editIndex != null;
    UserAddress? existingAddr = isEdit ? globalSavedAddresses[editIndex] : null;

    // Pre-fill Logic: Edit Data > Map Data > Default/Empty
    TextEditingController nameCtrl = TextEditingController(text: existingAddr?.fullName ?? '');
    TextEditingController codeCtrl = TextEditingController(text: existingAddr?.countryCode ?? '+91'); 
    TextEditingController phoneCtrl = TextEditingController(text: existingAddr?.phoneNumber ?? '');
    
    TextEditingController houseCtrl = TextEditingController(
      text: existingAddr?.houseNo ?? mapHouse ?? '' 
    ); 
    TextEditingController areaCtrl = TextEditingController(
      text: existingAddr?.area ?? mapArea ?? '' 
    );  
    TextEditingController pinCtrl = TextEditingController(
      text: existingAddr?.pincode ?? mapPin ?? '' 
    );   
    
    String tempType = existingAddr?.type ?? 'Home';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBgColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, 
                left: 20, right: 20, top: 20
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isEdit ? 'Edit Address' : 'Enter Address Details', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    
                    // Address Type Choice
                    Row(
                      children: ['Home', 'Office', 'Other'].map((type) {
                        bool isSelected = tempType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ChoiceChip(
                            label: Text(type),
                            selected: isSelected,
                            onSelected: (val) => setSheetState(() => tempType = type),
                            selectedColor: widget.themeColor.withOpacity(0.2),
                            backgroundColor: widget.isDark ? Colors.grey.shade800 : Colors.grey.shade200, 
                            labelStyle: TextStyle(
                              color: isSelected ? widget.themeColor : (widget.isDark ? Colors.white : Colors.black87), 
                              fontWeight: FontWeight.bold
                            ),
                            showCheckmark: false,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField('Full Name', nameCtrl),
                    const SizedBox(height: 12),
                    
                    // Country Code + Phone Row
                    Row(
                      children: [
                        SizedBox(
                          width: 80, 
                          child: _buildTextField('Code', codeCtrl, isCode: true, maxLength: 4)
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('Phone Number', phoneCtrl, isPhone: true, maxLength: 10)
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _buildTextField('Flat / House No. / Building', houseCtrl),
                    const SizedBox(height: 12),
                    _buildTextField('Area / Locality / Sector', areaCtrl),
                    const SizedBox(height: 12),
                    _buildTextField('Pincode / Zipcode', pinCtrl, isPhone: true, maxLength: 10), 
                    const SizedBox(height: 24),
                    
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.themeColor, 
                          padding: const EdgeInsets.symmetric(vertical: 16), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                        ),
                        onPressed: () {
                          // Validation
                          if (houseCtrl.text.isEmpty || pinCtrl.text.isEmpty || nameCtrl.text.isEmpty || phoneCtrl.text.length < 10) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields & enter 10 digit number')));
                            return;
                          }

                          UserAddress newAddr = UserAddress(
                            type: tempType,
                            fullName: nameCtrl.text,
                            countryCode: codeCtrl.text,
                            phoneNumber: phoneCtrl.text,
                            houseNo: houseCtrl.text,
                            area: areaCtrl.text,
                            pincode: pinCtrl.text,
                          );

                          if (isEdit) {
                            globalSavedAddresses[editIndex] = newAddr;
                            // Force refresh if editing the selected address
                            if (selectedAddressNotifier.value == editIndex) {
                              int current = selectedAddressNotifier.value;
                              selectedAddressNotifier.value = -1;
                              selectedAddressNotifier.value = current;
                            }
                          } else {
                            globalSavedAddresses.add(newAddr);
                            selectedAddressNotifier.value = globalSavedAddresses.length - 1;
                          }
                          
                          setState(() {}); // Refresh list
                          Navigator.pop(context); // Close Bottom Sheet
                          
                          // If it was a new address added (via map), go back to previous screen
                          if (!isEdit && mapHouse != null) {
                             // Do nothing, map was already popped
                          } else if (!isEdit) {
                             Navigator.pop(context); 
                          }
                        },
                        child: Text(isEdit ? 'Update Address' : 'Save Address', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPhone = false, bool isCode = false, int maxLines = 1, int? maxLength}) {
    List<TextInputFormatter>? formatters;
    
    if (isPhone) {
      formatters = [FilteringTextInputFormatter.digitsOnly]; 
    } else if (isCode) {
      formatters = [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))]; 
    }

    return TextField(
      controller: controller,
      keyboardType: (isPhone || isCode) ? TextInputType.phone : TextInputType.text,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: formatters,
      style: TextStyle(color: _textPrimary, fontSize: 14),
      decoration: InputDecoration(
        counterText: "", 
        labelText: label,
        labelStyle: TextStyle(color: _textSecondary),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _borderColor), borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.themeColor), borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: widget.isDark ? Colors.white10 : Colors.grey.shade50,
      ),
    );
  }
}