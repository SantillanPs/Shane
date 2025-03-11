import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final List<InvoiceItemForm> _items = [InvoiceItemForm()];
  DateTime? _selectedDate;

  void _addItem() {
    setState(() {
      _items.add(InvoiceItemForm());
    });
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      setState(() {
        _items.removeAt(index);
      });
    }
  }

  double get _total {
    return _items.fold(0, (sum, item) => sum + (item.amount ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Save invoice
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Selection
              _buildSectionTitle('Client Information'),
              _buildDropdown(
                label: 'Client',
                hint: 'Select client',
                items: const [
                  DropdownMenuItem(value: 'acme', child: Text('Acme Corp')),
                  DropdownMenuItem(
                    value: 'wayne',
                    child: Text('Wayne Enterprises'),
                  ),
                  DropdownMenuItem(
                    value: 'stark',
                    child: Text('Stark Industries'),
                  ),
                  DropdownMenuItem(value: 'pied', child: Text('Pied Piper')),
                ],
                onChanged: (value) {},
              ),

              const SizedBox(height: 16),

              // Invoice Details
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(label: 'Invoice #', hint: 'INV-001'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(label: 'Date', context: context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDateField(label: 'Due Date', context: context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Status',
                      hint: 'Select status',
                      value: 'unpaid',
                      items: const [
                        DropdownMenuItem(value: 'draft', child: Text('Draft')),
                        DropdownMenuItem(
                          value: 'unpaid',
                          child: Text('Unpaid'),
                        ),
                        DropdownMenuItem(value: 'paid', child: Text('Paid')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Items
              _buildSectionTitle('Items'),

              ...List.generate(_items.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Item ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (_items.length > 1)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeItem(index),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                            onChanged: (value) {
                              _items[index].description = value;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Qty',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _items[index].quantity =
                                          int.tryParse(value) ?? 0;
                                      _items[index].updateAmount();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Rate',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _items[index].rate =
                                          double.tryParse(value) ?? 0;
                                      _items[index].updateAmount();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Amount',
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text:
                                        _items[index].amount?.toStringAsFixed(
                                          2,
                                        ) ??
                                        '0.00',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              OutlinedButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Additional Information
              _buildSectionTitle('Additional Information'),

              _buildTextField(
                label: 'Notes',
                hint: 'Additional notes for the client',
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                label: 'Payment Terms',
                hint: 'Payment terms and conditions',
                maxLines: 2,
              ),

              const SizedBox(height: 24),

              // Total
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text('\$${_total.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax (0%)',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const Text('\$0.00'),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${_total.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          maxLines: maxLines,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate?.toString().split(' ')[0] ?? 'Select date',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(hint),
              items: items,
              onChanged: onChanged,
              isExpanded: true,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class InvoiceItemForm {
  String? description;
  int quantity = 1;
  double rate = 0;
  double? amount;

  InvoiceItemForm() {
    updateAmount();
  }

  void updateAmount() {
    amount = quantity * rate;
  }
}
