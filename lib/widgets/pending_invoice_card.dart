import 'package:flutter/material.dart';
import '../models/invoice.dart';

class PendingInvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const PendingInvoiceCard({Key? key, required this.invoice}) : super(key: key);

  Color _getDaysLeftColor(int? daysLeft) {
    if (daysLeft == null || daysLeft <= 0) return Colors.red;
    if (daysLeft <= 7) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/invoice-details', arguments: invoice);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.client,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          invoice.id,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        invoice.amount,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invoice.daysLeft != null && invoice.daysLeft! > 0
                            ? '${invoice.daysLeft} days left'
                            : 'Overdue',
                        style: TextStyle(
                          fontSize: 12,
                          color: _getDaysLeftColor(invoice.daysLeft),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Due:',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        invoice.dueDate,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Send reminder
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Send Reminder'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
