import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../widgets/propemange_widgets.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late RangeValues _currentPriceRange;
  late List<int> _selectedBHKs;
  late List<String> _selectedTypes;
  late String _constructionStatus;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    _currentPriceRange = provider.priceRange;
    _selectedBHKs = List.from(provider.selectedBHKs);
    _selectedTypes = List.from(provider.selectedPropertyTypes);
    _constructionStatus = provider.constructionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text('Budget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    '₹${(_currentPriceRange.start / 100000).toStringAsFixed(0)}L - ₹${(_currentPriceRange.end / 100000).toStringAsFixed(0)}L',
                    style: TextStyle(color: PropeMangeColors.primaryGreen, fontWeight: FontWeight.bold),
                  ),
                  RangeSlider(
                    values: _currentPriceRange,
                    min: 0,
                    max: 50000000,
                    divisions: 50,
                    activeColor: PropeMangeColors.primaryGreen,
                    onChanged: (values) {
                      setState(() => _currentPriceRange = values);
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('BHK (Configuration)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildMultiChoiceChips(
                    ['1', '2', '3', '4', '5'],
                    _selectedBHKs.map((e) => e.toString()).toList(),
                    (val) {
                      int bhk = int.parse(val);
                      setState(() {
                        if (_selectedBHKs.contains(bhk)) {
                          _selectedBHKs.remove(bhk);
                        } else {
                          _selectedBHKs.add(bhk);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Property Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildMultiChoiceChips(
                    ['House', 'Apartment', 'Commercial', 'Plot'],
                    _selectedTypes,
                    (val) {
                      setState(() {
                        if (_selectedTypes.contains(val)) {
                          _selectedTypes.remove(val);
                        } else {
                          _selectedTypes.add(val);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Construction Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildSingleChoiceChips(
                    ['Any', 'Ready to Move', 'Under Construction'],
                    _constructionStatus,
                    (val) => setState(() => _constructionStatus = val),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Provider.of<PropertyProvider>(context, listen: false).resetFilters();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: PropeMangeColors.primaryGreen),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('Reset', style: TextStyle(color: PropeMangeColors.primaryGreen)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<PropertyProvider>(context, listen: false).setAdvancedFilters(
                      priceRange: _currentPriceRange,
                      selectedBHKs: _selectedBHKs,
                      selectedPropertyTypes: _selectedTypes,
                      constructionStatus: _constructionStatus,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PropeMangeColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Consumer<PropertyProvider>(
                    builder: (context, provider, child) {
                      return Text(
                        'Show ${provider.properties.length} Homes',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultiChoiceChips(List<String> labels, List<String> selectedLabels, Function(String) onSelected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels.map((label) {
        final isSelected = selectedLabels.contains(label);
        return _buildFilterChip(label, isSelected, () => onSelected(label));
      }).toList(),
    );
  }

  Widget _buildSingleChoiceChips(List<String> labels, String selectedLabel, Function(String) onSelected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels.map((label) {
        final isSelected = selectedLabel == label;
        return _buildFilterChip(label, isSelected, () => onSelected(label));
      }).toList(),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? PropeMangeColors.primaryGreen.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? PropeMangeColors.primaryGreen : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? PropeMangeColors.primaryGreen : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
