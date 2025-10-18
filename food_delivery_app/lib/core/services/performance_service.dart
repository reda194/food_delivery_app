import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../services/logger_service.dart';

/// Performance Service - Monitors and optimizes app performance
class PerformanceService {
  static PerformanceService? _instance;
  static PerformanceService get instance => _instance ??= PerformanceService._();

  final LoggerService _logger = LoggerService.instance;
  final Map<String, List<int>> _performanceMetrics = {};
  final Map<String, DateTime> _startTimeTracker = {};
  final Queue<PerformanceEvent> _recentEvents = Queue<PerformanceEvent>();
  final Set<String> _slowOperations = {};

  // Performance thresholds
  static const Duration fastThreshold = Duration(milliseconds: 100);
  static const Duration normalThreshold = Duration(milliseconds: 500);
  static const Duration slowThreshold = Duration(milliseconds: 2000);

  PerformanceService._() {
    // Set up periodic performance reporting
    Timer.periodic(const Duration(minutes: 5), (_) => _reportPerformanceMetrics());
  }

  /// ==================== PERFOMANCE TRACKING ====================

  /// Start timing an operation
  void startTiming(String operationId) {
    _startTimeTracker[operationId] = DateTime.now();
  }

  /// End timing an operation and log performance
  T endTiming<T>(String operationId, [T? result]) {
    final startTime = _startTimeTracker.remove(operationId);
    if (startTime == null) {
      _logger.warning('No start time found for operation: $operationId');
      return result as T;
    }

    final duration = DateTime.now().difference(startTime);
    _recordPerformanceMetric(operationId, duration);
    
    // Log slow operations
    if (duration > slowThreshold) {
      _slowOperations.add(operationId);
      _logger.warning('Slow operation detected: $operationId took ${duration.inMilliseconds}ms');
    } else if (duration > normalThreshold) {
      _logger.info('Operation finished: $operationId took ${duration.inMilliseconds}ms');
    }

    return result as T;
  }

  /// Track an operation with proper cleanup using Dart patterns
  T track<T>(String operationId, T Function() operation) {
    startTiming(operationId);
    try {
      final result = operation();
      return endTiming(operationId, result);
    } catch (e) {
      _startTimeTracker.remove(operationId); // Cleanup on error
      rethrow;
    }
  }

  /// Track async operation with proper cleanup
  Future<T> trackAsync<T>(String operationId, Future<T> Function() operation) async {
    startTiming(operationId);
    try {
      final result = await operation();
      return endTiming(operationId, result);
    } catch (e) {
      _startTimeTracker.remove(operationId); // Cleanup on error
      rethrow;
    }
  }

  /// ==================== PERFORMANCE METRICS ====================

  /// Record performance metric
  void _recordPerformanceMetric(String operationId, Duration duration) {
    final durationMs = duration.inMilliseconds;
    
    if (!_performanceMetrics.containsKey(operationId)) {
      _performanceMetrics[operationId] = [];
    }
    
    _performanceMetrics[operationId]!.add(durationMs);
    
    // Keep only last 100 measurements per operation
    if (_performanceMetrics[operationId]!.length > 100) {
      _performanceMetrics[operationId]!.removeAt(0);
    }
    
    // Add to recent events for live monitoring
    _recentEvents.add(PerformanceEvent(
      operationId: operationId,
      duration: duration,
      timestamp: DateTime.now(),
    ));
    
    // Keep only last 1000 events
    if (_recentEvents.length > 1000) {
      _recentEvents.removeFirst();
    }
  }

  /// Get performance statistics for an operation
  PerformanceStats getStats(String operationId) {
    final metrics = _performanceMetrics[operationId] ?? [];
    if (metrics.isEmpty) {
      return PerformanceStats.zero();
    }

    metrics.sort();
    final count = metrics.length;
    final min = metrics.first;
    final max = metrics.last;
    final mean = metrics.reduce((a, b) => a + b) / count;
    final median = count % 2 == 0
        ? (metrics[count ~/ 2 - 1] + metrics[count ~/ 2]) / 2
        : metrics[count ~/ 2];
    final p90 = metrics[(count * 0.9).floor()].toDouble();
    final p95 = metrics[(count * 0.95).floor()].toDouble();
    final p99 = metrics[(count * 0.99).floor()].toDouble();

    return PerformanceStats(
      count: count,
      min: min.toInt(),
      max: max.toInt(),
      mean: mean,
      median: median,
      p90: p90,
      p95: p95,
      p99: p99,
    );
  }

  /// Get overall performance summary
  Map<String, dynamic> getPerformanceSummary() {
    final summary = <String, dynamic>{};
    
    for (final operationId in _performanceMetrics.keys) {
      final stats = getStats(operationId);
      summary[operationId] = stats.toMap();
    }
    
    return {
      'operations': summary,
      'slow_operations': _slowOperations.toList(),
      'total_operations': _performanceMetrics.keys.length,
      'total_events': _recentEvents.length,
      'generated_at': DateTime.now().toIso8601String(),
    };
  }

  /// ==================== MEMORY MANAGEMENT ====================

  /// Get memory usage info
  MemoryStats getMemoryUsage() {
    // In debug mode, we can get more detailed memory info
    if (!kReleaseMode) {
      return MemoryStats(
        totalMemory: 0, // Would need native platform code
        usedMemory: 0,
        freeMemory: 0,
        heapSize: 0,
        gcStats: {},
      );
    }
    
    return MemoryStats.zero();
  }

  /// Trigger garbage collection
  void triggerGC() {
    if (!kReleaseMode) {
      // In debug builds, we can suggest GC
      _logger.info('Triggering garbage collection');
    }
  }

  /// Monitor memory usage and alert if necessary
  void monitorMemoryUsage() {
    // In production, this would use platform channels to get memory info
    // For now, we'll just check performance metrics
    
    if (_recentEvents.length > 500) {
      _logger.warning('High number of events in memory: ${_recentEvents.length}');
      _cleanupOldEvents();
    }
  }

  /// Cleanup old events to free memory
  void _cleanupOldEvents() {
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 1));
    _recentEvents.removeWhere((event) => event.timestamp.isBefore(cutoffTime));
    _logger.info('Cleaned up old events, remaining: ${_recentEvents.length}');
  }

  /// ==================== DATABASE OPTIMIZATION ====================

  /// Get database performance recommendations
  List<String> getDatabaseRecommendations() {
    final recommendations = <String>[];
    final dbStats = getStats('database_query');
    
    if (dbStats.mean > 500) {
      recommendations.add('Database queries are slow (avg: ${dbStats.mean.toInt()}ms). Consider adding indexes.');
    }
    
    if (dbStats.p95 > 2000) {
      recommendations.add('Some database queries are very slow (p95: ${dbStats.p95.toInt()}ms). Optimize slow queries.');
    }
    
    return recommendations;
  }

  /// Get API performance recommendations
  List<String> getApiRecommendations() {
    final recommendations = <String>[];
    
    for (final operationId in _performanceMetrics.keys) {
      if (operationId.startsWith('api_')) {
        final stats = getStats(operationId);
        if (stats.mean > 1000) {
          recommendations.add('API endpoint $operationId is slow (avg: ${stats.mean.toInt()}ms)');
        }
      }
    }
    
    return recommendations;
  }

  /// ==================== UI PERFORMANCE ====================

  /// Track frame performance
  void trackFramePerformance(Duration frameDuration) {
    _recordPerformanceMetric('ui_frame', frameDuration);
    
    if (frameDuration.inMilliseconds > 16) {
      _logger.warning('Slow frame detected: ${frameDuration.inMilliseconds}ms');
    }
  }

  /// Get UI performance stats
  UIPerformanceStats getUIPerformanceStats() {
    final frameStats = getStats('ui_frame');
    final buildStats = getStats('ui_build');
    
    return UIPerformanceStats(
      frameStats: frameStats,
      buildStats: buildStats,
      droppedFrameRate: _calculateDroppedFrameRate(),
      averageFPS: _calculateAverageFPS(),
    );
  }

  /// Calculate dropped frame rate
  double _calculateDroppedFrameRate() {
    final metrics = _performanceMetrics['ui_frame'] ?? [];
    if (metrics.isEmpty) return 0.0;
    
    final droppedFrames = metrics.where((ms) => ms > 16).length;
    return droppedFrames / metrics.length;
  }

  /// Calculate average FPS
  double _calculateAverageFPS() {
    final stats = getStats('ui_frame');
    if (stats.mean == 0) return 0.0;
    
    return 1000 / stats.mean;
  }

  /// ==================== NETWORK PERFORMANCE ====================

  /// Track network request performance
  void trackNetworkRequest(String url, String method, Duration duration, int statusCode) {
    final operationId = 'network_${method}_${_getUrlKey(url)}';
    _recordPerformanceMetric(operationId, duration);
    
    if (duration > const Duration(seconds: 30)) {
      _logger.warning('Network request timeout: $url');
    }
    
    if (statusCode >= 500) {
      _logger.warning('Server error in network request: $url');
    }
  }

  /// Get network performance stats
  Map<String, dynamic> getNetworkPerformanceStats() {
    final networkStats = <String, dynamic>{};
    
    for (final operationId in _performanceMetrics.keys) {
      if (operationId.startsWith('network_')) {
        networkStats[operationId] = getStats(operationId).toMap();
      }
    }
    
    return networkStats;
  }

  /// Extract URL key for stats
  String _getUrlKey(String url) {
    // Return endpoint path without domain and parameters
    final uri = Uri.parse(url);
    return uri.path.replaceAll('/', '_').substring(1);
  }

  /// ==================== CACHE PERFORMANCE ====================

  /// Track cache hit/miss performance
  void trackCachePerformance(String cacheType, bool hit, Duration? lookupTime) {
    final operationId = 'cache_${cacheType}_${hit ? 'hit' : 'miss'}';
    if (lookupTime != null) {
      _recordPerformanceMetric(operationId, lookupTime);
    }
  }

  /// Get cache performance stats
  CachePerformanceStats getCachePerformanceStats() {
    final hitStats = getStats('cache_any_hit');
    final missStats = getStats('cache_any_miss');
    
    return CachePerformanceStats(
      hitStats: hitStats,
      missStats: missStats,
      hitRate: _calculateHitRate(hitStats.count, missStats.count),
    );
  }

  double _calculateHitRate(int hits, int misses) {
    final total = hits + misses;
    return total == 0 ? 0.0 : hits / total;
  }

  /// ==================== PERFORMANCE ALERTS ====================

  /// Get performance alerts
  List<PerformanceAlert> getPerformanceAlerts() {
    final alerts = <PerformanceAlert>[];
    
    // Check for consistently slow operations
    for (final operationId in _performanceMetrics.keys) {
      final stats = getStats(operationId);
      if (stats.p95 > slowThreshold.inMilliseconds) {
        alerts.add(PerformanceAlert(
          type: AlertType.slowOperation,
          severity: AlertSeverity.high,
          message: 'Operation $operationId is consistently slow (p95: ${stats.p95.toInt()}ms)',
          operationId: operationId,
        ));
      }
    }
    
    // Check for high variance in performance
    for (final operationId in _performanceMetrics.keys) {
      final stats = getStats(operationId);
      final variance = stats.max - stats.min;
      if (variance > normalThreshold.inMilliseconds * 2) {
        alerts.add(PerformanceAlert(
          type: AlertType.inconsistentPerformance,
          severity: AlertSeverity.medium,
          message: 'Operation $operationId has high performance variance (${variance.toInt()}ms)',
          operationId: operationId,
        ));
      }
    }
    
    return alerts;
  }

  /// ==================== BENCHMARKING ====================

  /// Run performance benchmark
  Future<BenchmarkResult> runBenchmark(String benchmarkId, Future<void> Function() operation, Duration warmupTime) async {
    _logger.info('Running benchmark: $benchmarkId');
    
    // Warmup
    if (warmupTime > Duration.zero) {
      final warmupEnd = DateTime.now().add(warmupTime);
      while (DateTime.now().isBefore(warmupEnd)) {
        await operation();
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }
    
    // Run benchmark
    final startTime = DateTime.now();
    final durations = <Duration>[];
    
    // Run for 1 second or 10 iterations, whichever is longer
    final endTime = startTime.add(const Duration(seconds: 1));
    int iterations = 0;
    int minIterations = 10;
    
    while (DateTime.now().isBefore(endTime) || iterations < minIterations) {
      final iterationStart = DateTime.now();
      await operation();
      final iterationDuration = DateTime.now().difference(iterationStart);
      durations.add(iterationDuration);
      iterations++;
    }
    
    return BenchmarkResult(
      benchmarkId: benchmarkId,
      iterations: iterations,
      totalTime: DateTime.now().difference(startTime),
      iterationsPerSecond: iterations / DateTime.now().difference(startTime).inSeconds,
      durations: durations,
    );
  }

  /// ==================== REPORTING ====================

  /// Periodic performance metrics reporting
  void _reportPerformanceMetrics() {
    monitorMemoryUsage();
    
    final alerts = getPerformanceAlerts();
    if (alerts.isNotEmpty) {
      for (final alert in alerts) {
        _logger.warning('Performance Alert: ${alert.message}');
      }
    }
  }

  /// Generate performance report
  String generatePerformanceReport() {
    final summary = getPerformanceSummary();
    final alerts = getPerformanceAlerts();
    final uiStats = getUIPerformanceStats();
    final cacheStats = getCachePerformanceStats();
    
    return '''
Performance Report - ${DateTime.now().toIso8601String()}
================================================================================

Summary:
- Total Operations: ${summary['total_operations']}
- Total Events: ${summary['total_events']}
- Slow Operations: ${summary['slow_operations'].length}
- Average FPS: ${uiStats.averageFPS.toStringAsFixed(1)}
- Dropped Frame Rate: ${(uiStats.droppedFrameRate * 100).toStringAsFixed(1)}%
- Cache Hit Rate: ${(cacheStats.hitRate * 100).toStringAsFixed(1)}%

Slow Operations:
${summary['slow_operations'].map((op) => '- $op').join('\n')}

Performance Alerts:
${alerts.map((alert) => '- [${alert.severity}] ${alert.message}').join('\n')}

Recommendations:
- ${_getTopRecommendation()}
''';
  }

  /// Get top performance recommendation
  String _getTopRecommendation() {
    if (_slowOperations.isNotEmpty) {
      return 'Optimize slow operations: ${_slowOperations.join(', ')}';
    }
    
    final uiStats = getUIPerformanceStats();
    if (uiStats.droppedFrameRate > 0.1) {
      return 'Improve UI performance - ${(uiStats.droppedFrameRate * 100).toStringAsFixed(1)}% frames dropped';
    }
    
    final cacheStats = getCachePerformanceStats();
    if (cacheStats.hitRate < 0.8) {
      return 'Improve cache hit rate - currently ${(cacheStats.hitRate * 100).toStringAsFixed(1)}%';
    }
    
    return 'Performance is within acceptable limits';
  }

  /// Clear performance metrics
  void clearMetrics() {
    _performanceMetrics.clear();
    _startTimeTracker.clear();
    _recentEvents.clear();
    _slowOperations.clear();
    _logger.info('Performance metrics cleared');
  }

  /// Dispose resources
  void dispose() {
    clearMetrics();
    _logger.info('Performance service disposed');
  }
}

/// Performance statistics
class PerformanceStats {
  final int count;
  final int min;
  final int max;
  final double mean;
  final double median;
  final double p90;
  final double p95;
  final double p99;

  PerformanceStats({
    required this.count,
    required this.min,
    required this.max,
    required this.mean,
    required this.median,
    required this.p90,
    required this.p95,
    required this.p99,
  });

  factory PerformanceStats.zero() {
    return PerformanceStats(
      count: 0,
      min: 0,
      max: 0,
      mean: 0,
      median: 0,
      p90: 0,
      p95: 0,
      p99: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'min': min,
      'max': max,
      'mean': mean,
      'median': median,
      'p90': p90,
      'p95': p95,
      'p99': p99,
    };
  }
}

/// Memory statistics
class MemoryStats {
  final int totalMemory;
  final int usedMemory;
  final int freeMemory;
  final int heapSize;
  final Map<String, dynamic> gcStats;

  MemoryStats({
    required this.totalMemory,
    required this.usedMemory,
    required this.freeMemory,
    required this.heapSize,
    required this.gcStats,
  });

  factory MemoryStats.zero() {
    return MemoryStats(
      totalMemory: 0,
      usedMemory: 0,
      freeMemory: 0,
      heapSize: 0,
      gcStats: {},
    );
  }
}

/// UI performance statistics
class UIPerformanceStats {
  final PerformanceStats frameStats;
  final PerformanceStats buildStats;
  final double droppedFrameRate;
  final double averageFPS;

  UIPerformanceStats({
    required this.frameStats,
    required this.buildStats,
    required this.droppedFrameRate,
    required this.averageFPS,
  });
}

/// Cache performance statistics
class CachePerformanceStats {
  final PerformanceStats hitStats;
  final PerformanceStats missStats;
  final double hitRate;

  CachePerformanceStats({
    required this.hitStats,
    required this.missStats,
    required this.hitRate,
  });
}

/// Performance event
class PerformanceEvent {
  final String operationId;
  final Duration duration;
  final DateTime timestamp;

  PerformanceEvent({
    required this.operationId,
    required this.duration,
    required this.timestamp,
  });
}

/// Performance alert
class PerformanceAlert {
  final AlertType type;
  final AlertSeverity severity;
  final String message;
  final String? operationId;
  final DateTime timestamp;

  PerformanceAlert({
    required this.type,
    required this.severity,
    required this.message,
    this.operationId,
  }) : timestamp = DateTime.now();
}

/// Alert types
enum AlertType {
  slowOperation,
  inconsistentPerformance,
  highMemoryUsage,
  highVariance,
}

/// Alert severity
enum AlertSeverity {
  low,
  medium,
  high,
  critical,
}

/// Benchmark result
class BenchmarkResult {
  final String benchmarkId;
  final int iterations;
  final Duration totalTime;
  final double iterationsPerSecond;
  final List<Duration> durations;

  BenchmarkResult({
    required this.benchmarkId,
    required this.iterations,
    required this.totalTime,
    required this.iterationsPerSecond,
    required this.durations,
  });
}
