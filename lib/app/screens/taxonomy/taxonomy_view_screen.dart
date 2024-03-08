import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/taxonomy/taxonomy_view_controller.dart';
import '../../widgets/circuclar_indicator.dart';
import '../base_screen.dart';

class TaxonomyViewScreen extends BaseScreen<TaxonomyViewController> {
  final String? title;

  TaxonomyViewScreen({
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget pageScaffold(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? controller.title!),
        ),
        body: Obx(() {
          return (controller.loading.value!)
              ? const CircularPageIndicator()
              : SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Row(children: [
                              const Text('Name :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(controller.taxonomy!.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16)),
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Description :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                        controller.taxonomy!.description!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16)),
                                  ),
                                ]),
                          )
                        ],
                      )));
        }));
  }
}
