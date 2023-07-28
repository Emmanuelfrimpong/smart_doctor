import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/home/consultation/consultation_item.dart';
import 'package:smart_doctor/state/consultation_data_state.dart';
import 'package:smart_doctor/state/data_state.dart';
import '../../core/components/widgets/custom_input.dart';
import '../../state/doctor_data_state.dart';
import '../../state/user_data_state.dart';
import '../../styles/colors.dart';
import '../../styles/styles.dart';

class ConsultationPage extends ConsumerStatefulWidget {
  const ConsultationPage({super.key});

  @override
  ConsumerState<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends ConsumerState<ConsultationPage> {
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var consultations = ref.watch(consultationsStreamProvider);
    return SafeArea(
        child: Scaffold(
            body: consultations.when(
                data: (data) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: CustomTextFields(
                      controller: _controller,
                      hintText: 'search consultation',
                      focusNode: _focus,
                      suffixIcon: _focus.hasFocus
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                  ref
                                      .read(consultationSearchQuery.notifier)
                                      .state = '';
                                  _focus.unfocus();
                                });
                              },
                              icon: Icon(MdiIcons.close, color: primaryColor))
                          : Icon(MdiIcons.magnify, color: primaryColor),
                      onChanged: (value) {
                        ref.read(consultationSearchQuery.notifier).state =
                            value;
                      },
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: _focus.hasFocus
                          ? LayoutBuilder(builder: (context, constraint) {
                              //get user id
                              var use =
                                  ref.watch(userTypeProvider)!.toLowerCase() ==
                                          'user'
                                      ? ref.watch(userProvider).id
                                      : ref.watch(doctorProvider).id;

                              var list =
                                  ref.watch(searchConsultationProvider(use!));
                              if (list.isNotEmpty) {
                                return ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 150),
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return ConsultationItem(list[index]);
                                  },
                                );
                              } else {
                                return Center(
                                    child: Text('No Consultations Found',
                                        style: normalText()));
                              }
                            })
                          : data.isNotEmpty
                              ? ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    var consultation = data[index];
                                    return ConsultationItem(consultation);
                                  })
                              : Center(
                                  child: Text('No Consultation Found',
                                      style: normalText())),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Text(
                      'Something went wrong',
                      style: normalText(color: Colors.grey),
                    ),
                  );
                },
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ))));
  }
}
