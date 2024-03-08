import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/article/article_view_controller.dart';
import '../../widgets/circuclar_indicator.dart';
import '../base_screen.dart';
import '../node/node_view_screen/widgets/node_view_body.dart';
import '../node/node_view_screen/widgets/node_view_images_carousel.dart';
import '../node/node_view_screen/widgets/node_view_meta.dart';
import '../node/node_view_screen/widgets/node_view_title.dart';

class ArticleViewScreen extends BaseScreen<ArticleViewController> {
  final String? title;

  ArticleViewScreen({
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget pageScaffold(BuildContext context) {
    var T = AppLocalizations.of(context)!;
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
                          NodeViewMeta(
                            userId: controller.node.author.id,
                            authorName: controller.node.author.displayName,
                            createdDate: controller.createdDate,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          NodeViewTitle(controller.node.title),
                          const SizedBox(
                            height: 20,
                          ),
                          NodeViewBody(controller.node.body),
                          const SizedBox(
                            height: 20,
                          ),
                          NodeViewImagesCarousel(controller.node.images),
                        ],
                      )));
        }));
  }
}
