import 'dart:developer';

import 'package:flutter/material.dart';
import '../../controllers/article/article_form_controller.dart';
import '../../mixins/helper_mixin.dart';
import '../../models/file_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_field/image_field.dart';
import 'package:image_field/linear_progress_indicator_if.dart';

import '../../models/enum/entity_action.dart';
import '../../widgets/circuclar_indicator.dart';
import '../../values/app_values.dart';
import '../../widgets/taxonomy_reference_field.dart';
import '../base_screen.dart';
import '../node/node_form_screen/widgets/node_action_buttons.dart';
import '../node/node_form_screen/widgets/node_alias_field.dart';
import '../node/node_form_screen/widgets/node_body_field.dart';
import '../node/node_form_screen/widgets/node_status_field.dart';
import '../node/node_form_screen/widgets/node_title_field.dart';

class ArticleFormScreen extends BaseScreen<ArticleFormController> {
  final EntityAction action;
  final String? title;
  final InputDecoration? fieldTitleDecoration;
  final InputDecoration? fieldBodyDecoration;
  final InputDecoration? fieldAliasDecoration;
  final Widget? fieldStatus;

  ArticleFormScreen(
    this.action, {
    this.title,
    this.fieldTitleDecoration,
    this.fieldBodyDecoration,
    this.fieldAliasDecoration,
    this.fieldStatus,
    Key? key,
  }) : super(key: key);

  Widget spacer() {
    return const SizedBox(
      height: AppValues.formFieldsSpacer,
    );
  }

  @override
  Widget pageScaffold(BuildContext context) {
    var T = AppLocalizations.of(context)!;
    var appBar = AppBar(
      title: Text(title ?? controller.title ?? T.node),
    );
    log('node form screen: ${controller.images.value!.length}');
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: Obx(() {
        return (controller.initializing.value!)
            ? const CircularPageIndicator()
            : SingleChildScrollView(
                child: Form(
                    key: controller.nodeFormKey,
                    child: Container(
                      padding: AppValues.pagePadding,
                      height: HelperMixin.getBodyHeight(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NodeTitleField(controller,
                              decoration: fieldTitleDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          NodeBodyField(controller,
                              decoration: fieldBodyDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          ImageField(
                            key: UniqueKey(),
                            texts: {
                              'title': 'Upload Image',
                              'addCaptionText': T.addCaption,
                              'doneText': T.done,
                              'titleText': 'Manage images',
                              'fieldFormText': T.upload,
                              'emptyDataText': T.emptyData,
                            },
                            // cardinality: 1,
                            files: controller.images.value != null
                                ? controller.images.value!.map((image) {
                                    log('ImageField:....${image.alt}, ${image.alt.toString()}');
                                    return ImageAndCaptionModel(
                                        file: image,
                                        caption: image.alt.toString());
                                  }).toList()
                                : [],
                            remoteImage: true,
                            onUpload: (dynamic pickedFile,
                                ControllerLinearProgressIndicatorIF?
                                    controllerLinearProgressIndicator) async {
                              log('Upload progress************************');

                              dynamic fileUploaded =
                                  await controller.uploadFile(
                                controller.nodeType,
                                'field_image',
                                pickedFile,
                                uploadProgress: (percent) {
                                  var uploadProgressPercentage = percent / 100;
                                  controllerLinearProgressIndicator!
                                      .updateProgress(uploadProgressPercentage);
                                  print('Progress bar: ${percent.toInt()}');
                                },
                              );
                              log('fileUploaded......:${fileUploaded.id}');
                              return fileUploaded;
                            },
                            onSave: (List<ImageAndCaptionModel>?
                                imageAndCaptionList) {
                              log('**************enter on save: ');
                              controller.images.value = [];
                              for (ImageAndCaptionModel imageAndCaption
                                  in imageAndCaptionList!) {
                                //if remote image  controller.images.value!.add(imageAndCaption);
                                controller.images.value!.add(FileModel(
                                    id: imageAndCaption.file.id,
                                    alt: imageAndCaption.caption,
                                    uri: imageAndCaption.file.uri));
                                controller.images(controller.images.value);
                                log('**************imageAndCaption: ');
                              }
                            },
                          ),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          TaxonomyReferenceField(
                            defaultValues: controller.tags.value ?? [],
                            vocabulary: 'tags', hintText: 'Tags',
                            onChanged: (data) {
                              controller.tags.value = data;
                            },
                            // title: 'Tags',
                          ),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          NodeAliasField(controller,
                              decoration: fieldAliasDecoration),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          Obx(() => controller.status.value != null
                              ? NodeStatusField(controller)
                              : SizedBox.shrink()),
                          const Expanded(
                            child: SizedBox.shrink(),
                          ),
                          NodeActionButtons(controller)
                        ],
                      ),
                    )));
      }),
    );
  }
}
