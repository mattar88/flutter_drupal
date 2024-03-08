import 'dart:async';
import 'dart:developer';

import 'package:chips_input/chips_input.dart';
import 'package:flutter/material.dart';
import '../bindings/taxonomy/taxonomy_binding.dart';
import '../models/taxonomy/taxonomy_model.dart';
import 'package:get/get.dart';

import '../controllers/taxonomy/taxonomy_controller.dart';

class TaxonomyReferenceField extends StatefulWidget {
  final String vocabulary;
  final String hintText;
  final Icon fieldIcon;
  Transform? progressIndicator;
  final Icon addIcon;
  List<TaxonomyModel> defaultValues;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted]:
  ///    which are more specialized input change notifications.
  final ValueChanged<List<TaxonomyModel>>? onChanged;
  TaxonomyReferenceField({
    required this.vocabulary,
    required this.hintText,
    this.fieldIcon = const Icon(Icons.tag_sharp),
    this.progressIndicator,
    this.addIcon = const Icon(
      Icons.add_circle,
    ),
    this.defaultValues = const [],
    this.onChanged,
    key,
  }) : super(key: key);

  @override
  State<TaxonomyReferenceField> createState() => _TaxonomyReferenceFieldState();
}

class _TaxonomyReferenceFieldState extends State<TaxonomyReferenceField> {
  // final _chipsKey = GlobalKey<ChipsInputState<TaxonomyModel>>();
  GlobalKey<ChipsInputState> _chipKey = GlobalKey();
  late ValueKey _key;
  bool isLoading = false;

  late TaxonomyController txC;
  var mockResults = <TaxonomyModel>[];
  var results = <TaxonomyModel>[];

  List<TaxonomyModel> defaultValues = [];
  Map<String, List<TaxonomyModel>> queryCache = {};
  int trySearch = 3;

  String lastSearch = '';
  late FocusNode txFocusNode;

  @override
  void dispose() {
    txFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    log('Taxonomy reference .......................');
    defaultValues = widget.defaultValues;
    //Inject Taxonomy Controller
    TaxonomyBinding().dependencies();
    txFocusNode = FocusNode();
    _key = ValueKey('_chipInputTaxonomy_');
    txC = Get.find<TaxonomyController>();
    // defaultValues.add(TaxonomyModel(id: 'asasasas', name: 'new one'));
    widget.progressIndicator = widget.progressIndicator ??
        Transform.scale(
          scale: 0.5,
          child: const CircularProgressIndicator(
            strokeWidth: 3,
          ),
        );
    super.initState();
  }

  late TextEditingController _textEditingController =
      new TextEditingController();
  TextSelectionControls? _selectionControls;

  @override
  Widget build(BuildContext context) {
    log('moooooooooooooooo------${defaultValues}----${_key}');
    return ChipsInput(
      key: _key,
      focusNode: txFocusNode,
      controller: _textEditingController,
      selectionControls: _selectionControls,

      decoration: InputDecoration(
        icon: widget.fieldIcon,
        hintText: widget.hintText,
        suffixIcon: (isLoading)
            ? Transform.scale(
                scale: 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              )
            : IconButton(
                icon: widget.addIcon,
                onPressed: () async {
                  // txC.create(taxonomy);
                  // _textEditingController.selection = TaxonomyModel(id: 'asa1111111sasas', name: 'new one111', vocabulary: widget.vocabulary) as TextSelection;
                  var name = _textEditingController.value.text;

                  var term = await txC.create(TaxonomyModel(
                      name: name, vocabulary: widget.vocabulary, status: true));

                  // _textEditingController.text = null;
                  var def = defaultValues;
                  _textEditingController.clear();
                  defaultValues = def;
                  defaultValues.add(term);

                  _key = ValueKey(
                      '_chipInputTaxonomy_${DateTime.now().millisecondsSinceEpoch}');

                  trySearch = 3;
                  widget.onChanged!(defaultValues);

                  // _chipKey.currentState?.setState(() {});

                  // setState(() {});
                  // txFocusNode.requestFocus();

                  // _textEditingController.selection.
                  log('-------${_textEditingController.value.text}');
                  // });
                  // log('touch ${_textEditingController.value}');
                },
              ),
      ),
      // maxChips: 3, // remove, if you like infinity number of chips
      initialValue: defaultValues,

      findSuggestions: (String query) async {
        lastSearch = query;

        //waiting to get last search
        await Future<void>.delayed(const Duration(milliseconds: 500));

        //Current search different to last one skip it
        if (query != lastSearch) {
          return <TaxonomyModel>[];
        }

        //if equal apply a remote request search and
        if (queryCache.keys.where((record) => lastSearch == record).length ==
            0) {
          //put the cache null to skip the repeated
          //queries meanwhile the remote one done
          queryCache[query] = <TaxonomyModel>[];

          // Do something
          if (query.isNotEmpty) {
            //
            var lowercaseQuery = query.toLowerCase();

            if (trySearch > 0) {
              --trySearch;
              if (queryCache[query]!.isEmpty) trySearch = 3;
              setState(() {
                isLoading = true;
              });
              results = (await txC.getTaxonomies(widget.vocabulary,
                  name: lowercaseQuery))!;
              queryCache[query] = results;

              log('Done from server request');
              setState(() {
                isLoading = false;
              });
            }
          }
        }

        results = queryCache[lastSearch] ?? <TaxonomyModel>[];
        results = results.where((profile) {
          return !defaultValues
              .any((selectedValue) => selectedValue.name == profile.name);
        }).toList(growable: false);

        log('end request Results--${defaultValues.length}-${lastSearch}--${query}--${queryCache[lastSearch]}----${results.length}');
        return results;
      },
      onChanged: (data) {
        defaultValues = data.toList(growable: true);
        trySearch = 3;
        widget.onChanged!(data);
      },
      chipBuilder: (context, state, TaxonomyModel profile) {
        log('state-----------');

        return InputChip(
          // key: ObjectKey(profile),
          key: ValueKey("chipBuilder_${profile.name}_${profile.id}"),
          label: Text(profile.name),
          // avatar: CircleAvatar(
          //   backgroundImage: NetworkImage(profile.imageUrl),
          // ),
          onDeleted: () {
            queryCache.removeWhere((key, listSuggestions) =>
                listSuggestions.any((element) => element.name == profile.name));
            return state.deleteChip(profile);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
      suggestionBuilder: (context, TaxonomyModel profile) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: ListTile(
            key: ValueKey("suggestionBuilder_${profile.name}_${profile.id}"),
            // leading: CircleAvatar(
            //   backgroundImage: NetworkImage(profile.imageUrl),
            // ),
            title: Text(profile.name),
            // subtitle: Text(profile.email),
          ),
        );
      },
    );
  }
}

// class TLBAutocompleteField extends StatelessWidget {
//   TaxonomyController txC =
//       Get.put(TaxonomyController(Get.put(TaxonomyApiService())));
//   @override
//   Widget build(BuildContext context) {
//     var mockResults = <TaxonomyModel>[];

//     return Stack(
//       children: [
//         // CircularProgressIndicator(),
//         ChipsInput(
//           decoration: const InputDecoration(
//             icon: Icon(Icons.tag_sharp),
//             hintText: 'Tags',
//           ),
//           maxChips: 3, // remove, if you like infinity number of chips
//           initialValue: mockResults.isNotEmpty ? [mockResults[1]] : mockResults,
//           buildCounter: (context,
//               {currentLength = 0, isFocused = false, maxLength}) {
//             return Center(child: Text('hhhh'));
//           },
//           findSuggestions: (String query) async {
//             log('List --- ${query}');

//             if (query.isNotEmpty) {
//               var lowercaseQuery = query.toLowerCase();
//               mockResults = (await txC.getTermList('tags',
//                   filterByname: {'name': lowercaseQuery}))!;
//               // mockResults = <TaxonomyModel>[TaxonomyModel(listTx!.first.name)];
//               // log('List --- ${listTx.length}');
//               if (mockResults != null) {
//                 log('*********************************------${lowercaseQuery}');
//                 final results = mockResults!.where((profile) {
//                   return profile.name
//                       .toLowerCase()
//                       .contains(query.toLowerCase());
//                 }).toList(growable: false)
//                   ..sort((a, b) => a.name
//                       .toLowerCase()
//                       .indexOf(lowercaseQuery)
//                       .compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
//                 return results;
//               }
//             }
//             return mockResults;
//           },
//           onChanged: (data) {
//             print(data);
//           },
//           chipBuilder: (context, state, TaxonomyModel profile) {
//             log('state-----------');
//             return InputChip(
//               key: ObjectKey(profile),
//               label: Text(profile.name),
//               // avatar: CircleAvatar(
//               //   backgroundImage: NetworkImage(profile.imageUrl),
//               // ),
//               onDeleted: () => state.deleteChip(profile),
//               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             );
//           },
//           suggestionBuilder: (context, TaxonomyModel profile) {
//             return ListTile(
//               key: ObjectKey(profile),
//               // leading: CircleAvatar(
//               //   backgroundImage: NetworkImage(profile.imageUrl),
//               // ),
//               title: Text(profile.name),
//               // subtitle: Text(profile.email),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
