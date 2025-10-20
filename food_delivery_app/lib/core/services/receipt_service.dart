import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Receipt Service - Generates and manages order receipts
class ReceiptService {
  static final ReceiptService instance = ReceiptService._internal();
  factory ReceiptService() => instance;
  ReceiptService._internal();

  /// Generate receipt as text
  Future<String> generateReceiptText(ReceiptData data) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('═══════════════════════════════════');
    buffer.writeln('         FOOD DELIVERY RECEIPT');
    buffer.writeln('═══════════════════════════════════');
    buffer.writeln();

    // Order Info
    buffer.writeln('Order #: ${data.orderNumber}');
    buffer.writeln('Date: ${_formatDateTime(data.orderDate)}');
    buffer.writeln('Status: ${data.status}');
    buffer.writeln();

    // Restaurant Info
    buffer.writeln('───────────────────────────────────');
    buffer.writeln('RESTAURANT');
    buffer.writeln('───────────────────────────────────');
    buffer.writeln(data.restaurantName);
    if (data.restaurantAddress != null) {
      buffer.writeln(data.restaurantAddress);
    }
    buffer.writeln();

    // Delivery Address
    buffer.writeln('───────────────────────────────────');
    buffer.writeln('DELIVERY ADDRESS');
    buffer.writeln('───────────────────────────────────');
    buffer.writeln(data.deliveryAddress);
    buffer.writeln();

    // Items
    buffer.writeln('───────────────────────────────────');
    buffer.writeln('ITEMS');
    buffer.writeln('───────────────────────────────────');
    for (final item in data.items) {
      buffer.writeln('${item.quantity}x ${item.name}');
      if (item.addons.isNotEmpty) {
        buffer.writeln('   Add-ons: ${item.addons.join(", ")}');
      }
      buffer.writeln('   ${_formatCurrency(item.price)} × ${item.quantity} = ${_formatCurrency(item.totalPrice)}');
      buffer.writeln();
    }

    // Pricing
    buffer.writeln('───────────────────────────────────');
    buffer.writeln('PRICING');
    buffer.writeln('───────────────────────────────────');
    buffer.writeln('Subtotal:        ${_formatCurrency(data.subtotal)}');

    if (data.deliveryFee > 0) {
      buffer.writeln('Delivery Fee:    ${_formatCurrency(data.deliveryFee)}');
    }

    if (data.serviceFee > 0) {
      buffer.writeln('Service Fee:     ${_formatCurrency(data.serviceFee)}');
    }

    if (data.tax > 0) {
      buffer.writeln('Tax:             ${_formatCurrency(data.tax)}');
    }

    if (data.discount > 0) {
      buffer.writeln('Discount:       -${_formatCurrency(data.discount)}');
      if (data.promoCode != null) {
        buffer.writeln('Promo Code:      ${data.promoCode}');
      }
    }

    buffer.writeln('───────────────────────────────────');
    buffer.writeln('TOTAL:           ${_formatCurrency(data.total)}');
    buffer.writeln('═══════════════════════════════════');
    buffer.writeln();

    // Payment Method
    buffer.writeln('Payment Method: ${data.paymentMethod}');
    if (data.paymentStatus != null) {
      buffer.writeln('Payment Status: ${data.paymentStatus}');
    }
    buffer.writeln();

    // Footer
    buffer.writeln('Thank you for your order!');
    buffer.writeln('═══════════════════════════════════');

    return buffer.toString();
  }

  /// Save receipt to file
  Future<File> saveReceipt(ReceiptData data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final receiptsDir = Directory('${directory.path}/receipts');

      if (!await receiptsDir.exists()) {
        await receiptsDir.create(recursive: true);
      }

      final fileName = 'receipt_${data.orderNumber}_${DateTime.now().millisecondsSinceEpoch}.txt';
      final file = File('${receiptsDir.path}/$fileName');

      final receiptText = await generateReceiptText(data);
      await file.writeAsString(receiptText);

      return file;
    } catch (e) {
      throw ReceiptException('Failed to save receipt: $e');
    }
  }

  /// Generate HTML receipt
  Future<String> generateReceiptHTML(ReceiptData data) async {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Receipt - Order #${data.orderNumber}</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #f5f5f5;
    }
    .receipt {
      background-color: white;
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .header {
      text-align: center;
      border-bottom: 2px solid #333;
      padding-bottom: 20px;
      margin-bottom: 20px;
    }
    .section {
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }
    .section-title {
      font-weight: bold;
      margin-bottom: 10px;
      color: #333;
    }
    .item {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
    }
    .total {
      font-size: 1.2em;
      font-weight: bold;
      text-align: right;
      padding-top: 15px;
      border-top: 2px solid #333;
    }
  </style>
</head>
<body>
  <div class="receipt">
    <div class="header">
      <h1>FOOD DELIVERY RECEIPT</h1>
      <p>Order #${data.orderNumber}</p>
      <p>${_formatDateTime(data.orderDate)}</p>
    </div>

    <div class="section">
      <div class="section-title">Restaurant</div>
      <p>${data.restaurantName}</p>
      ${data.restaurantAddress != null ? '<p>${data.restaurantAddress}</p>' : ''}
    </div>

    <div class="section">
      <div class="section-title">Delivery Address</div>
      <p>${data.deliveryAddress}</p>
    </div>

    <div class="section">
      <div class="section-title">Items</div>
      ${data.items.map((item) => '''
        <div class="item">
          <span>${item.quantity}x ${item.name}</span>
          <span>${_formatCurrency(item.totalPrice)}</span>
        </div>
      ''').join('')}
    </div>

    <div class="section">
      <div class="item">
        <span>Subtotal</span>
        <span>${_formatCurrency(data.subtotal)}</span>
      </div>
      ${data.deliveryFee > 0 ? '''
        <div class="item">
          <span>Delivery Fee</span>
          <span>${_formatCurrency(data.deliveryFee)}</span>
        </div>
      ''' : ''}
      ${data.tax > 0 ? '''
        <div class="item">
          <span>Tax</span>
          <span>${_formatCurrency(data.tax)}</span>
        </div>
      ''' : ''}
      ${data.discount > 0 ? '''
        <div class="item">
          <span>Discount</span>
          <span>-${_formatCurrency(data.discount)}</span>
        </div>
      ''' : ''}
      <div class="total">
        Total: ${_formatCurrency(data.total)}
      </div>
    </div>

    <div class="section">
      <div class="section-title">Payment</div>
      <p>Method: ${data.paymentMethod}</p>
      ${data.paymentStatus != null ? '<p>Status: ${data.paymentStatus}</p>' : ''}
    </div>

    <div style="text-align: center; margin-top: 30px;">
      <p>Thank you for your order!</p>
    </div>
  </div>
</body>
</html>
    ''';
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Receipt Data
class ReceiptData {
  final String orderNumber;
  final DateTime orderDate;
  final String status;
  final String restaurantName;
  final String? restaurantAddress;
  final String deliveryAddress;
  final List<ReceiptItem> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double tax;
  final double discount;
  final String? promoCode;
  final double total;
  final String paymentMethod;
  final String? paymentStatus;

  const ReceiptData({
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.restaurantName,
    this.restaurantAddress,
    required this.deliveryAddress,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 0,
    this.serviceFee = 0,
    this.tax = 0,
    this.discount = 0,
    this.promoCode,
    required this.total,
    required this.paymentMethod,
    this.paymentStatus,
  });
}

/// Receipt Item
class ReceiptItem {
  final String name;
  final int quantity;
  final double price;
  final List<String> addons;

  const ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.addons = const [],
  });

  double get totalPrice => price * quantity;
}

/// Receipt Exception
class ReceiptException implements Exception {
  final String message;
  ReceiptException(this.message);

  @override
  String toString() => message;
}
