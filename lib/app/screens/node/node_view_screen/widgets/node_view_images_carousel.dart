import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../models/file_model.dart';

class NodeViewImagesCarousel extends StatefulWidget {
  List<FileModel>? images;
  CarouselOptions? options;
  Widget? label;
  NodeViewImagesCarousel(this.images, {label, options, super.key}) {
    images = images ?? [];
  }

  @override
  State<NodeViewImagesCarousel> createState() => _NodeViewImagesCarouselState();
}

class _NodeViewImagesCarouselState extends State<NodeViewImagesCarousel> {
  List<Widget> imageSliders = [];
  Widget label = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Text('Images :',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));

  @override
  void initState() {
    super.initState();
    label = widget.label ?? label;
    imageSliders = widget.images!
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item.uri.toString(),
                            fit: BoxFit.cover,
                            width: 1000, frameBuilder: ((context, child, frame,
                                wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) return child;
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: frame != null
                                ? child
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          );
                        })),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              item.alt!.isNotEmpty
                                  ? item.alt!
                                  : 'No. ${widget.images!.indexWhere((element) => element.id == item.id)} image',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label,
        (widget.images!.isEmpty)
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CarouselSlider(
                      items: imageSliders,
                      options: widget.options ??
                          CarouselOptions(
                              aspectRatio: 2.0,
                              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                              enlargeFactor: 0.4,
                              enlargeCenterPage: true,
                              height: 200,
                              enableInfiniteScroll: false),
                      carouselController: _controller,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () => _controller.previousPage(),
                            child: Text('←'),
                          ),
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () => _controller.nextPage(),
                            child: Text('→'),
                          ),
                        ),
                        ...Iterable<int>.generate(widget.images!.length).map(
                          (int pageIndex) => Flexible(
                            child: ElevatedButton(
                              onPressed: () =>
                                  _controller.animateToPage(pageIndex),
                              child: Text("$pageIndex"),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ],
    );
  }
}
