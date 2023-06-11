import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/components/widgets/custom_button.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../state/navigation_state.dart';

class UserAuthOptions extends ConsumerWidget {
  const UserAuthOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        elevation: 10,
          margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Which one are you?', style: normalText(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 20,),
              CustomButton(text: 'I am User'.toUpperCase(), onPressed: (){

                ref.read(authIndexProvider.notifier).state=1;
                print(ref.watch(authIndexProvider));
              },),
              const SizedBox(height: 20,),
              CustomButton(text: 'I am Doctor'.toUpperCase(), onPressed: (){
                ref.read(authIndexProvider.notifier).state=2;
              },),
            ],),
        )
      ),
    );
  }
}
