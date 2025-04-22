import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reto_app/controllers/shared_preference_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized!');
});
final sharedPreferenceControllerProvider = Provider<SharedPreferenceController>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferenceController(prefs);
});
