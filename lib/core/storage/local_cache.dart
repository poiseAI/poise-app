import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_cache.g.dart';

abstract final class CacheBoxNames {
  static const positions = 'positions_cache';
  static const orders = 'orders_cache';
  static const notifications = 'notifications_cache';
  static const misc = 'misc_cache';
}

@Riverpod(keepAlive: true)
LocalCache localCache(Ref ref) => LocalCache();

class LocalCache {
  Future<void> init() async {
    await Hive.openBox<String>(CacheBoxNames.positions);
    await Hive.openBox<String>(CacheBoxNames.orders);
    await Hive.openBox<String>(CacheBoxNames.notifications);
    await Hive.openBox<String>(CacheBoxNames.misc);
  }

  // Generic helpers — store as JSON strings to avoid Hive adapter registration
  Future<void> put(String boxName, String key, dynamic value) async {
    final box = Hive.box<String>(boxName);
    await box.put(key, jsonEncode(value));
  }

  T? get<T>(String boxName, String key, T Function(dynamic) fromJson) {
    final box = Hive.box<String>(boxName);
    final raw = box.get(key);
    if (raw == null) return null;
    try {
      return fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  List<T> getList<T>(
    String boxName,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final box = Hive.box<String>(boxName);
    final raw = box.get(key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> putList<T>(
    String boxName,
    String key,
    List<T> items,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final box = Hive.box<String>(boxName);
    await box.put(key, jsonEncode(items.map(toJson).toList()));
  }

  Future<void> delete(String boxName, String key) async {
    final box = Hive.box<String>(boxName);
    await box.delete(key);
  }

  Future<void> clearBox(String boxName) async {
    final box = Hive.box<String>(boxName);
    await box.clear();
  }
}
