import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/services/firebase_auth.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/doctor_model.dart';
import '../models/user_model.dart';
import '../services/firebase_storage.dart';
import 'navigation_state.dart';

final userImageProvider = StateProvider<File?>((ref) => null);
final doctorImageProvider = StateProvider<File?>((ref) => null);
final idImageProvider = StateProvider<File?>((ref) => null);
final certificateProvider = StateProvider<File?>((ref) => null);
final userTypeProvider = StateProvider<String?>((ref) => null);
