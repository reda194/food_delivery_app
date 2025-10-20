import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';

/// Order Remote Data Source
/// Handles all API calls related to orders using Supabase
abstract class OrderRemoteDataSource {
  /// Get order by ID
  Future<OrderModel> getOrderById(String orderId);

  /// Get user's order history
  Future<List<OrderModel>> getUserOrders(String userId);

  /// Create a new order
  Future<OrderModel> createOrder(Map<String, dynamic> orderData);

  /// Update order status
  Future<OrderModel> updateOrderStatus(String orderId, String status);

  /// Get order items for an order
  Future<List<OrderItemModel>> getOrderItems(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final LoggerService _logger = LoggerService.instance;

  static const String _ordersTable = 'orders';
  static const String _orderItemsTable = 'order_items';

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      _logger.info('Fetching order by ID: $orderId');

      final response = await _supabaseService.client
          .from(_ordersTable)
          .select('''
            *,
            items:order_items(*)
          ''')
          .eq('id', orderId)
          .single();

      _logger.info('Successfully fetched order: $orderId');

      return OrderModel.fromJson(response);
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch order $orderId: $e', stackTrace);
      throw ServerException('Failed to fetch order: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      _logger.info('Fetching orders for user: $userId');

      final response = await _supabaseService.client
          .from(_ordersTable)
          .select('''
            *,
            items:order_items(*)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _logger.info('Fetched ${response.length} orders for user $userId');

      return (response as List)
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch user orders: $e', stackTrace);
      throw ServerException('Failed to fetch user orders: ${e.toString()}');
    }
  }

  @override
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    try {
      _logger.info('Creating new order...');

      // Extract items from orderData
      final items = orderData.remove('items') as List?;

      // Insert order
      final orderResponse = await _supabaseService.client
          .from(_ordersTable)
          .insert(orderData)
          .select()
          .single();

      final orderId = orderResponse['id'] as String;

      // Insert order items if provided
      if (items != null && items.isNotEmpty) {
        final itemsData = items.map((item) {
          return {
            ...item as Map<String, dynamic>,
            'order_id': orderId,
          };
        }).toList();

        await _supabaseService.client
            .from(_orderItemsTable)
            .insert(itemsData);
      }

      _logger.info('Successfully created order: $orderId');

      // Fetch complete order with items
      return await getOrderById(orderId);
    } catch (e, stackTrace) {
      _logger.error('Failed to create order: $e', stackTrace);
      throw ServerException('Failed to create order: ${e.toString()}');
    }
  }

  @override
  Future<OrderModel> updateOrderStatus(String orderId, String status) async {
    try {
      _logger.info('Updating order $orderId status to $status');

      await _supabaseService.client
          .from(_ordersTable)
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);

      _logger.info('Successfully updated order status');

      // Return updated order
      return await getOrderById(orderId);
    } catch (e, stackTrace) {
      _logger.error('Failed to update order status: $e', stackTrace);
      throw ServerException('Failed to update order status: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderItemModel>> getOrderItems(String orderId) async {
    try {
      _logger.info('Fetching items for order: $orderId');

      final response = await _supabaseService.client
          .from(_orderItemsTable)
          .select()
          .eq('order_id', orderId);

      _logger.info('Fetched ${response.length} items for order $orderId');

      return (response as List)
          .map((json) => OrderItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch order items: $e', stackTrace);
      throw ServerException('Failed to fetch order items: ${e.toString()}');
    }
  }
}
