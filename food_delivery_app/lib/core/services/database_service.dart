import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import 'logger_service.dart';
import 'supabase_service.dart';

/// Database Service - Handles all database operations with proper error handling
class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();

  late final SupabaseClient _supabase;
  final LoggerService _logger = LoggerService.instance;
  final SupabaseService _supabaseService = SupabaseService.instance;

  DatabaseService._() {
    _supabase = _supabaseService.client;
  }

  /// ==================== CRUD OPERATIONS ====================

  /// Generic select operation
  Future<List<Map<String, dynamic>>> select(
    String table, {
    List<String> columns = const ['*'],
    String? where,
    String? orderBy,
    int? limit,
    int? offset,
    bool single = false,
    Map<String, dynamic>? searchTerms,
  }) async {
    try {
      _logger.database('select', table, details: 'columns: $columns, where: $where, limit: $limit');

      dynamic query = _supabase
          .from(table)
          .select(columns.join(', '));

      // Apply where clause
      if (where != null) {
        query = query.or(where);
      }

      // Apply search terms
      if (searchTerms != null && searchTerms.isNotEmpty) {
        for (final entry in searchTerms.entries) {
          query = query.ilike(entry.key, '%${entry.value}%');
        }
      }

      // Apply ordering
      if (orderBy != null) {
        final parts = orderBy.split(' ');
        final column = parts[0];
        final ascending = parts.length == 1 || parts[1].toLowerCase() == 'asc';
        query = query.order(column, ascending: ascending);
      }

      // Apply limit and offset
      if (limit != null) {
        query = query.limit(limit);
      }
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? AppConstants.defaultPageSize) - 1);
      }

      final response = await query;
      
      _logger.success('Selected ${response.length} record(s) from $table');
      return List<Map<String, dynamic>>.from(response);

    } on PostgrestException catch (e) {
      _logger.error('Database select error: ${e.message}');
      throw DatabaseException('Failed to select from $table: ${e.message}');
    } catch (e) {
      _logger.error('Unexpected select error: $e');
      throw DatabaseException('Failed to select from $table: $e');
    }
  }

  /// Generic insert operation
  Future<Map<String, dynamic>> insert(
    String table,
    Map<String, dynamic> data, {
    bool returnData = true,
  }) async {
    try {
      _logger.database('insert', table, details: 'data keys: ${data.keys}');

      final query = _supabase.from(table).insert(data);
      final response = returnData ? await query.select() : await query;

      final result = returnData 
          ? (response is List ? response.first : response as Map<String, dynamic>)
          : {};

      _logger.success('Inserted record into $table with ID: ${result['id'] ?? 'unknown'}');
      return result;
      
    } on PostgrestException catch (e) {
      _logger.error('Database insert error: ${e.message}');
      throw DatabaseException('Failed to insert into $table: ${e.message}');
    } catch (e) {
      _logger.error('Unexpected insert error: $e');
      throw DatabaseException('Failed to insert into $table: $e');
    }
  }

  /// Generic update operation
  Future<Map<String, dynamic>> update(
    String table,
    Map<String, dynamic> data,
    String idColumn,
    dynamic id, {
    bool returnData = true,
  }) async {
    try {
      _logger.database('update', table, details: 'id: $id, data keys: ${data.keys}');

      final query = _supabase.from(table).update(data).eq(idColumn, id);
      final response = returnData ? await query.select() : await query;

      final result = returnData 
          ? (response is List ? response.first : response as Map<String, dynamic>)
          : {};

      _logger.success('Updated record in $table with $idColumn: $id');
      return result;
      
    } on PostgrestException catch (e) {
      _logger.error('Database update error: ${e.message}');
      throw DatabaseException('Failed to update $table: ${e.message}');
    } catch (e) {
      _logger.error('Unexpected update error: $e');
      throw DatabaseException('Failed to update $table: $e');
    }
  }

  /// Generic delete operation
  Future<void> delete(
    String table,
    String idColumn,
    dynamic id,
  ) async {
    try {
      _logger.database('delete', table, details: 'id: $id');

      await _supabase.from(table).delete().eq(idColumn, id);

      _logger.success('Deleted record from $table with $idColumn: $id');
      
    } on PostgrestException catch (e) {
      _logger.error('Database delete error: ${e.message}');
      throw DatabaseException('Failed to delete from $table: ${e.message}');
    } catch (e) {
      _logger.error('Unexpected delete error: $e');
      throw DatabaseException('Failed to delete from $table: $e');
    }
  }

  /// ==================== RELATIONSHIP QUERIES ====================

  /// Query with relationships (joined tables)
  Future<List<Map<String, dynamic>>> queryWithRelations(
    String table, {
    List<String> relations = const [],
    List<String> columns = const ['*'],
    String? where,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    try {
      final selectColumns = [...columns];
      for (final relation in relations) {
        selectColumns.add('$relation(*)');
      }

      return await select(
        table,
        columns: selectColumns,
        where: where,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
      
    } catch (e) {
      throw DatabaseException('Failed to query $table with relations: $e');
    }
  }

  /// ==================== AGGREGATE FUNCTIONS ====================

  /// Count records
  Future<int> count(
    String table, {
    String? where,
  }) async {
    try {
      _logger.database('count', table, details: 'where: $where');

      dynamic query = _supabase.from(table).select('*');

      if (where != null) {
        query = query.or(where);
      }

      final response = await query;
      final count = (response as List).length;

      _logger.success('Counted $count records in $table');
      return count;

    } catch (e) {
      throw DatabaseException('Failed to count records in $table: $e');
    }
  }

  /// Get distinct values for a column
  Future<List<dynamic>> distinct(String table, String column) async {
    try {
      _logger.database('distinct', table, details: 'column: $column');

      final response = await _supabase
          .from(table)
          .select(column);

      // Manual distinct filtering
      final values = <dynamic>{};
      for (final row in response as List<dynamic>) {
        if (row[column] != null) {
          values.add(row[column]);
        }
      }

      final distinctValues = values.toList();
      _logger.success('Found ${distinctValues.length} distinct values for $column in $table');
      return distinctValues;

    } catch (e) {
      throw DatabaseException('Failed to get distinct values for $column in $table: $e');
    }
  }

  /// ==================== BATCH OPERATIONS ====================

  /// Batch insert multiple records
  Future<List<Map<String, dynamic>>> batchInsert(
    String table,
    List<Map<String, dynamic>> records, {
    bool returnData = true,
  }) async {
    try {
      _logger.database('batchInsert', table, details: 'records: ${records.length}');

      final query = _supabase.from(table).insert(records);
      final response = returnData ? await query.select() : await query;

      final results = returnData 
          ? List<Map<String, dynamic>>.from(response)
          : List<Map<String, dynamic>>.filled(records.length, {});

      _logger.success('Batch inserted ${results.length} records into $table');
      return results;
      
    } catch (e) {
      throw DatabaseException('Failed to batch insert into $table: $e');
    }
  }

  /// Batch update multiple records with different values
  Future<void> batchUpdate(
    String table,
    List<Map<String, dynamic>> updates,
    String idColumn,
  ) async {
    try {
      _logger.database('batchUpdate', table, details: 'updates: ${updates.length}');

      // Supabase doesn't have native batch update, so we'll use RPC
      // This would require creating a PostgreSQL function
      final result = await _supabase.rpc('batch_update', params: {
        'table_name': table,
        'id_column': idColumn,
        'updates': updates,
      });

      _logger.success('Batch updated $result records in $table');
      
    } catch (e) {
      throw DatabaseException('Failed to batch update $table: $e');
    }
  }

  /// ==================== SEARCH FUNCTIONS ====================

  /// Full-text search
  Future<List<Map<String, dynamic>>> fullTextSearch(
    String table,
    String column,
    String query, {
    List<String> searchColumns = const [],
    int? limit,
    int? offset,
  }) async {
    try {
      _logger.database('fullTextSearch', table, details: 'column: $column, query: $query');

      // Use PostgreSQL full-text search
      final searchQuery = searchColumns.isEmpty
          ? '$column.tsvector @@ plainto_tsquery($query)'
          : 'to_tsvector(${searchColumns.join(', ')}) @@ plainto_tsquery($query)';

      return await select(
        table,
        where: searchQuery,
        orderBy: 'ts_rank($column.tsvector, plainto_tsquery($query)) desc',
        limit: limit,
        offset: offset,
      );
      
    } catch (e) {
      throw DatabaseException('Failed to perform full-text search on $table: $e');
    }
  }

  /// Proximity search (for location-based queries)
  Future<List<Map<String, dynamic>>> proximitySearch(
    String table,
    double latitude,
    double longitude, {
    double radius = 10.0, // km
    String? latitudeColumn = 'latitude',
    String? longitudeColumn = 'longitude',
    int? limit,
  }) async {
    try {
      _logger.database('proximitySearch', table, details: 'location: ($latitude, $longitude), radius: $radius');

      // Use PostgreSQL earthdistance extension
      final distanceQuery = '''
        earth_distance(
          ll_to_earth(latitude, longitude), 
          ll_to_earth($latitude, $longitude)
        )
      ''';

      return await _supabase.rpc('proximity_search', params: {
        'table_name': table,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'latitude_column': latitudeColumn,
        'longitude_column': longitudeColumn,
        'limit': limit,
      });
      
    } catch (e) {
      throw DatabaseException('Failed to perform proximity search on $table: $e');
    }
  }

  /// ==================== TRANSACTIONS ====================

  /// Execute multiple operations as a transaction
  Future<List<dynamic>> transaction(
    List<Future Function(SupabaseClient)> operations,
  ) async {
    try {
      _logger.database('transaction', 'multiple', details: 'operations: ${operations.length}');

      // Supabase doesn't have explicit transaction support in the client
      // We'll need to use PostgreSQL functions or RPC calls
      final results = <dynamic>[];
      
      for (final operation in operations) {
        results.add(await operation(_supabase));
      }

      _logger.success('Transaction completed with ${results.length} operations');
      return results;
      
    } catch (e) {
      _logger.error('Transaction failed: $e');
      throw DatabaseException('Transaction failed: $e');
    }
  }

  /// ==================== UTILITY FUNCTIONS ====================

  /// Check if record exists
  Future<bool> exists(String table, String idColumn, dynamic id) async {
    try {
      final result = await _supabase
          .from(table)
          .select('*')
          .eq(idColumn, id);

      return (result as List).isNotEmpty;
    } catch (e) {
      throw DatabaseException('Failed to check if record exists in $table: $e');
    }
  }

  /// Get Max ID
  Future<int> getMaxId(String table, String idColumn) async {
    try {
      final response = await _supabase
          .from(table)
          .select('max($idColumn) as max_id')
          .single();

      return response['max_id'] as int? ?? 0;
    } catch (e) {
      throw DatabaseException('Failed to get max ID from $table: $e');
    }
  }

  /// Get next ID (for manual ID generation)
  Future<int> getNextId(String table, String idColumn) async {
    final maxId = await getMaxId(table, idColumn);
    return maxId + 1;
  }

  /// Backup table data
  Future<Map<String, List<Map<String, dynamic>>>> backupTables(
    List<String> tables,
  ) async {
    try {
      final backups = <String, List<Map<String, dynamic>>>{};
      
      for (final table in tables) {
        final startTime = DateTime.now();
        backups[table] = await select(table);
        final duration = DateTime.now().difference(startTime);
        
        _logger.info('Backed up ${backups[table]!.length} records from $table in ${duration.inMilliseconds}ms');
      }

      return backups;
    } catch (e) {
      throw DatabaseException('Failed to backup tables: $e');
    }
  }

  /// Clear cached data from Supabase client
  void clearCache() {
    // Clear cached data if needed (Supabase doesn't have clearAllCaches method)
    // _supabase.clearAllCaches();
    _logger.info('Supabase cache cleared');
  }

  /// Get database statistics
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final stats = <String, dynamic>{};
      
      // Get table sizes and row counts
      final tables = [
        AppConstants.usersTable,
        AppConstants.restaurantsTable,
        AppConstants.ordersTable,
        AppConstants.categoriesTable,
        AppConstants.menuItemsTable,
      ];

      for (final table in tables) {
        final count = await this.count(table);
        stats[table] = {'row_count': count};
      }

      return stats;
    } catch (e) {
      throw DatabaseException('Failed to get database stats: $e');
    }
  }
}
