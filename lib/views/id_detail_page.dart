import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_page_controller.dart';

class IdDetailPage extends StatelessWidget {
  IdDetailPage({super.key});
  HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          color: Colors.blue[700],
          width: MediaQuery.of(context).size.width * 0.72,
          height: 400,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    text: 'Seri Numarası : ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[300]),
                    children: <InlineSpan>[
                      TextSpan(
                        text: homePageController.idSerialNumber.value,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[300]),
                      )
                    ])),
                Text.rich(TextSpan(
                    text: 'Doğum Tarihi : ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[300]),
                    children: <InlineSpan>[
                      TextSpan(
                        text: homePageController.idBirthdate.value,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[300]),
                      )
                    ])),
                Text.rich(TextSpan(
                    text: 'Son Geçerlilik Tarihi : ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[300]),
                    children: <InlineSpan>[
                      TextSpan(
                        text: homePageController.idValidUntil.value,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[300]),
                      )
                    ])),
              ]),
        ),
      ),
    );
  }
}
