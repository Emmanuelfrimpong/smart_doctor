import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final userImageProvider = StateProvider<File?>((ref) => null);
final doctorImageProvider = StateProvider<File?>((ref) => null);
final idImageProvider = StateProvider<File?>((ref) => null);
final certificateProvider = StateProvider<File?>((ref) => null);
final userTypeProvider = StateProvider<String?>((ref) => null);
