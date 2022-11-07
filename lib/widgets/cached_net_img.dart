import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CachedNetImg extends StatelessWidget {
  const CachedNetImg({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: url,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return SizedBox(
          height: height,
          width: width,
          child: Card(
            // elevation: 0,
            backgroundColor: Colors.grey[30],
            child: Center(
              child: Shimmer(
                duration: const Duration(milliseconds: 1500),
                direction: const ShimmerDirection.fromLeftToRight(),
                color: Colors.grey,
                child: SizedBox(
                  height: height,
                  width: width,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
