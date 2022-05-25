import 'package:app_cre/src/models/models.dart';
import 'package:app_cre/src/services/attention_payment_points_service.dart';
import 'package:app_cre/src/ui/components/components.dart';
import 'package:app_cre/src/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentPopUp extends StatefulWidget {
  AttentionPaymentPoint point;

  ContentPopUp({Key? key, required this.point}) : super(key: key);

  @override
  State<ContentPopUp> createState() => _ContentPopUpState();
}

class _ContentPopUpState extends State<ContentPopUp> {
  List<Schedule> schedules = List.empty(growable: true);
  List<String> phones = List.empty(growable: true);
  bool loadData = true;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  initializeData() async {
    schedules =
        await AttentionPaymentPointsService().getSchedules(widget.point.id);
    phones = await AttentionPaymentPointsService().getPhones(widget.point.id);
    setState(() {
      loadData = false;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    print(launchUri.toString());
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: customBoxDecoration(15),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ImageIcon(
                      AssetImage('assets/icons/vuesax-bold-location.png'),
                      color: widget.point.typeId == 1
                          ? SecondaryColor
                          : DarkColor,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.point.name,
                      style: const TextStyle(
                          color: DarkColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                rowData("Dirección: ", widget.point.address),
                rowData("Servicio: ", widget.point.type),
                !loadData
                    ? Column(
                        children: [
                          rowData("Horario de Atención:", " "),
                          ...schedules.map((schedule) => rowDataCustom(
                              schedule, schedules.indexOf(schedule)))
                        ],
                      )
                    : SizedBox()
              ],
            ),
          ),
          !loadData
              ? Column(
                  children: [
                    ...phones.map((phone) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Align(
                              alignment: Alignment.center,
                              child: MaterialButton(
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  disabledColor: Colors.black87,
                                  elevation: 0,
                                  child: Container(
                                      constraints: BoxConstraints(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          maxHeight: 50),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: DarkColor),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const ImageIcon(
                                            AssetImage(
                                                'assets/icons/vuesax-linear-call-calling.png'),
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            phone,
                                            style: const TextStyle(
                                                fontFamily: 'Mulish',
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ],
                                      )),
                                  onPressed: () => _makePhoneCall(phone))),
                        ))
                  ],
                )
              : circularProgress()
        ],
      ),
    );
  }

  Widget rowData(String key, String value) {
    return Column(
      children: [
        const CustomDivider(),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          Text(
                            key,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF3A3D5F),
                                fontSize: 14),
                          ),
                          Text(
                            value,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                color: Color(0XFF999999),
                                fontSize: 14),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  Widget rowDataCustom(Schedule schedule, int index) {
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 65,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0 ? "Dias Laborales: " : "Fin de Semana: ",
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF3A3D5F),
                                fontSize: 14),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            schedule.description,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                color: Color(0XFF999999),
                                fontSize: 14),
                          ),
                          Text(
                            schedule.fromAM + " a " + schedule.untilAM,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                color: Color(0XFF999999),
                                fontSize: 14),
                          ),
                          schedule.fromPM != "none"
                              ? Text(
                                  schedule.fromPM + " a " + schedule.untilPM,
                                  style: const TextStyle(
                                      fontFamily: 'Mulish',
                                      color: Color(0XFF999999),
                                      fontSize: 14),
                                )
                              : SizedBox()
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
        index != 0 ? const CustomDivider() : SizedBox()
      ],
    );
  }
}
