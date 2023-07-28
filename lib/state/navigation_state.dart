import 'package:flutter_riverpod/flutter_riverpod.dart';

final authIndexProvider = StateProvider<int>((ref) => 0);

final userSignUpPageIndexProvider = StateProvider<int>((ref) => 0);
final doctorSignUpPageIndexProvider = StateProvider<int>((ref) => 0);

final userProfileIndexProvider = StateProvider<int>((ref) => 0);
