class Invoice {
  final String id;
  final String client;
  final String amount;
  final String date;
  final String dueDate;
  final String status;
  final List<InvoiceItem> items;
  final String notes;
  final String paymentTerms;
  final String address;
  final String email;
  final double subtotal;
  final double tax;
  final double total;
  final int? daysLeft;

  Invoice({
    required this.id,
    required this.client,
    required this.amount,
    required this.date,
    required this.status,
    this.dueDate = '',
    this.items = const [],
    this.notes = '',
    this.paymentTerms = '',
    this.address = '',
    this.email = '',
    this.subtotal = 0,
    this.tax = 0,
    this.total = 0,
    this.daysLeft,
  });
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double rate;
  final double amount;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.rate,
    required this.amount,
  });
}

// Sample data
List<Invoice> getSampleInvoices() {
  return [
    Invoice(
      id: 'INV-001',
      client: 'Acme Corp',
      amount: '\$1,200.00',
      date: 'Mar 10, 2025',
      dueDate: 'Apr 10, 2025',
      status: 'Unpaid',
      address: '123 Business Ave, Suite 200, San Francisco, CA 94107',
      email: 'billing@acmecorp.com',
      items: [
        InvoiceItem(
          description: 'Website Redesign',
          quantity: 1,
          rate: 800,
          amount: 800,
        ),
        InvoiceItem(
          description: 'Hosting (Premium Plan)',
          quantity: 2,
          rate: 200,
          amount: 400,
        ),
      ],
      subtotal: 1200,
      tax: 0,
      total: 1200,
      notes: 'Thank you for your business.',
      paymentTerms: 'Payment due within 30 days.',
      daysLeft: 30,
    ),
    Invoice(
      id: 'INV-002',
      client: 'Wayne Enterprises',
      amount: '\$3,800.00',
      date: 'Mar 5, 2025',
      status: 'Paid',
    ),
    Invoice(
      id: 'INV-003',
      client: 'Stark Industries',
      amount: '\$2,040.00',
      date: 'Mar 1, 2025',
      dueDate: 'Mar 31, 2025',
      status: 'Unpaid',
      daysLeft: 20,
    ),
    Invoice(
      id: 'INV-004',
      client: 'Pied Piper',
      amount: '\$8,780.00',
      date: 'Feb 28, 2025',
      status: 'Paid',
    ),
    Invoice(
      id: 'INV-005',
      client: 'Oscorp',
      amount: '\$3,500.00',
      date: 'Feb 25, 2025',
      dueDate: 'Mar 25, 2025',
      status: 'Pending',
      daysLeft: 14,
    ),
    Invoice(
      id: 'INV-007',
      client: 'Umbrella Corp',
      amount: '\$950.00',
      date: 'Mar 5, 2025',
      dueDate: 'Mar 20, 2025',
      status: 'Pending',
      daysLeft: 9,
    ),
    Invoice(
      id: 'INV-009',
      client: 'Cyberdyne Systems',
      amount: '\$4,200.00',
      date: 'Feb 28, 2025',
      dueDate: 'Mar 15, 2025',
      status: 'Pending',
      daysLeft: 4,
    ),
  ];
}

List<Invoice> getPendingInvoices() {
  return getSampleInvoices()
      .where(
        (invoice) => invoice.status == 'Pending' || invoice.status == 'Unpaid',
      )
      .toList();
}
