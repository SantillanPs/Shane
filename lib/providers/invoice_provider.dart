import 'package:flutter/material.dart';
import '../models/invoice.dart';

class InvoiceProvider extends ChangeNotifier {
  List<Invoice> _invoices = getSampleInvoices();
  String _searchQuery = '';
  String _sortBy = 'dueDate';
  
  List<Invoice> get invoices => _invoices;
  List<Invoice> get pendingInvoices => _invoices
      .where((invoice) => invoice.status == 'Pending' || invoice.status == 'Unpaid')
      .toList();
  
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }
  
  List<Invoice> getFilteredInvoices() {
    return _invoices.where((invoice) {
      return invoice.client.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          invoice.id.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
  
  double get unpaidTotal {
    return _invoices
        .where((invoice) => invoice.status == 'Unpaid')
        .fold(0, (sum, invoice) => sum + _parseAmount(invoice.amount));
  }

  double get paidTotal {
    return _invoices
        .where((invoice) => invoice.status == 'Paid')
        .fold(0, (sum, invoice) => sum + _parseAmount(invoice.amount));
  }
  
  double get totalPending {
    return pendingInvoices.fold(
      0,
      (sum, invoice) => sum + _parseAmount(invoice.amount),
    );
  }
  
  double _parseAmount(String amount) {
    return double.parse(amount.replaceAll('\$', '').replaceAll(',', ''));
  }
  
  void addInvoice(Invoice invoice) {
    _invoices.add(invoice);
    notifyListeners();
  }
  
  void updateInvoice(Invoice invoice) {
    final index = _invoices.indexWhere((element) => element.id == invoice.id);
    if (index != -1) {
      _invoices[index] = invoice;
      notifyListeners();
    }
  }
  
  void deleteInvoice(String id) {
    _invoices.removeWhere((invoice) => invoice.id == id);
    notifyListeners();
  }
  
  void markAsPaid(String id) {
    final index = _invoices.indexWhere((element) => element.id == id);
    if (index != -1) {
      // Create a new invoice with updated status
      final updatedInvoice = Invoice(
        id: _invoices[index].id,
        client: _invoices[index].client,
        amount: _invoices[index].amount,
        date: _invoices[index].date,
        dueDate: _invoices[index].dueDate,
        status: 'Paid',
        items: _invoices[index].items,
        notes: _invoices[index].notes,
        paymentTerms: _invoices[index].paymentTerms,
        address: _invoices[index].address,
        email: _invoices[index].email,
        subtotal: _invoices[index].subtotal,
        tax: _invoices[index].tax,
        total: _invoices[index].total,
      );
      _invoices[index] = updatedInvoice;
      notifyListeners();
    }
  }
}

