import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/widgets/widget_export.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ImgView extends StatelessWidget {
  const ImgView({
    super.key,
    required this.tag,
    required this.url,
    this.isSmall = false,
    this.isLocalPath = true,
  });
  final String tag;
  final String url;
  final bool isSmall;
  final bool isLocalPath;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth:
            isSmall ? double.infinity : MediaQuery.of(context).size.width * 0.8,
      ),
      content: Center(
        child: GestureDetector(
          onTap: () => context.pop,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Hero(
              tag: tag,
              child: isLocalPath && !kIsWeb
                  ? Image.file(
                      File(url),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : CachedNetImg(
                      url: url,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
