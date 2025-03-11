import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../widgets/pending_invoice_card.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Invoice> _pendingInvoices = getPendingInvoices();
  String _searchQuery = '';
  String _sortBy = 'dueDate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Invoice> get _filteredInvoices {
    return _pendingInvoices.where((invoice) {
      return invoice.client.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          invoice.id.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  double get _totalPending {
    return _pendingInvoices.fold(
      0,
      (sum, invoice) => sum + _parseAmount(invoice.amount),
    );
  }

  double _parseAmount(String amount) {
    // Remove $ and commas, then parse to double
    return double.parse(amount.replaceAll('\$', '').replaceAll(',', ''));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Invoices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Pending Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Pending',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${_totalPending.toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.access_time,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search clients or invoice numbers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Overdue'),
              ],
            ),

            const SizedBox(height: 16),

            // Filter and Sort Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredInvoices.length} pending invoices',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'dueDate', child: Text('Due Date')),
                    DropdownMenuItem(value: 'amount', child: Text('Amount')),
                    DropdownMenuItem(
                      value: 'client',
                      child: Text('Client Name'),
                    ),
                    DropdownMenuItem(
                      value: 'invoiceDate',
                      child: Text('Invoice Date'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortBy = value;
                      });
                    }
                  },
                  hint: const Text('Sort by'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All Pending
                  _buildPendingList(_filteredInvoices),

                  // Upcoming
                  _buildPendingList(
                    _filteredInvoices
                        .where(
                          (invoice) =>
                              invoice.daysLeft != null && invoice.daysLeft! > 0,
                        )
                        .toList(),
                  ),

                  // Overdue
                  _buildPendingList(
                    _filteredInvoices
                        .where(
                          (invoice) =>
                              invoice.daysLeft != null &&
                              invoice.daysLeft! <= 0,
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingList(List<Invoice> invoices) {
    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: PendingInvoiceCard(invoice: invoice),
        );
      },
    );
  }
}
