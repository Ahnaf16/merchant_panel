import 'package:fluent_ui/fluent_ui.dart';

class BaseBody extends StatelessWidget {
  const BaseBody({
    Key? key,
    required this.children,
    this.widthFactor = 1.2,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.elevation = 4.0,
    this.bottomPadding = 20,
    this.scrollController,
    this.height,
    this.physics,
  }) : super(key: key);

  final List<Widget> children;
  final num widthFactor;
  final double? height;

  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? elevation;
  final double? bottomPadding;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding!),
        child: Center(
          child: SizedBox(
            height: height,
            width: MediaQuery.of(context).size.width / widthFactor,
            child: Card(
              // elevation: elevation!,
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment:
                    mainAxisAlignment ?? MainAxisAlignment.center,
                crossAxisAlignment:
                    crossAxisAlignment ?? CrossAxisAlignment.center,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
