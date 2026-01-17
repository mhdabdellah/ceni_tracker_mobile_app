import 'package:ceni_scanner/kitItems/kit_items_model.dart';
import 'package:flutter/material.dart';

class MaterialElectoralFormProvider extends ChangeNotifier {
  final KitItemsModel formData = KitItemsModel();
  int currentStep = 0;
  final List<KitItem> kitItems;

  MaterialElectoralFormProvider({required this.kitItems}) {
    // Initialize the form data for each kit item.
    for (var kitItem in kitItems) {
      formData.quantities[kitItem.name] = kitItem.quantity ?? 0;
      formData.isChecked[kitItem.name] = true;
    }
  }

  /// Build the steps for the Stepper widget.
  List<Step> buildSteps() {
    return kitItems.map((kitItem) {
      return Step(
        title: Text('${kitItem.name} (${kitItem.quantity})'),
        content: Row(
          children: [
            Checkbox(
              value: formData.isChecked[kitItem.name] ?? true,
              onChanged: (newValue) {
                bool isChecked = newValue ?? true;
                // Update the checkbox and quantity accordingly.
                toggleItem(kitItem.name, isChecked, kitItem.quantity ?? 0);
              },
            ),
            Expanded(
              child: TextFormField(
                initialValue: formData.quantities[kitItem.name]?.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  int quantity = int.tryParse(value) ?? 0;
                  updateItemQuantity(kitItem.name, quantity);
                },
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Move to the next step if available.
  void nextStep() {
    if (currentStep < kitItems.length - 1) {
      currentStep++;
      notifyListeners();
    }
  }

  /// Move to the previous step.
  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  /// Update both the checkbox state and quantity value.
  void toggleItem(String kitItemName, bool isChecked, int defaultQuantity) {
    formData.toggleChecked(kitItemName, isChecked);
    // If unchecked, set quantity to zero; otherwise, use the default.
    formData.updateQuantity(kitItemName, isChecked ? defaultQuantity : 0);
    notifyListeners();
  }

  /// Update only the quantity for a kit item.
  void updateItemQuantity(String kitItemName, int quantity) {
    formData.updateQuantity(kitItemName, quantity);
    notifyListeners();
  }
}
