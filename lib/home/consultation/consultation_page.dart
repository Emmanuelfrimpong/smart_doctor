import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  alignment: Alignment.topCenter,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                      color: primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text('My Consultations'.toUpperCase(),
                        style: GoogleFonts.laila(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: CustomTextFields(
                        controller: _controller,
                        hintText: 'search consultation',
                        color: Colors.white,
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: consultations.when(
              data: (data) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                  )),
        ),
      ],
    );
  }
}
