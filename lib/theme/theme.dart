import 'package:fluent_ui/fluent_ui.dart';

Color boxColor = Colors.grey[10];
Color boxColorDark = Colors.grey[10];

AccentColor primaryColor = Colors.orange;
Color primaryContainer = Colors.orange.lightest;
Color fixLight = Colors.white;
Color fixDark = Colors.black;

//light colors
Color surface = Colors.grey[10];
Color secondaryContainer = Colors.grey[50];
Color surfaceVariant = const Color.fromARGB(255, 167, 196, 228);
Color background = Colors.grey[30];
Color onColor = Colors.grey[200];

//dark colors
Color surfaceD = Colors.grey[160];
Color secondaryContainerD = Colors.grey[220];
Color surfaceVariantD = const Color.fromARGB(255, 76, 89, 104);
Color backgroundD = Colors.grey[190]; //190,card 160
Color onColorD = Colors.grey;

BoxDecoration boxDecoration = BoxDecoration(
  color: boxColorDark,
  borderRadius: BorderRadius.circular(5),
  border: Border.all(
    color: Colors.grey[100],
    width: 1,
  ),
);

ButtonStyle hoveringButtonsStyle(Color color) {
  return ButtonStyle(
      shape: ButtonState.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      backgroundColor: ButtonState.resolveWith(
        (states) => states.isHovering ? color : null,
      ),
      foregroundColor: ButtonState.resolveWith(
        (states) => states.isHovering ? Colors.white : color,
      ),
      padding: ButtonState.all(
        const EdgeInsets.all(10),
      ));
}

ButtonStyle outlineButtonsStyle({
  Color bgColor = Colors.white,
  Color fgColor = Colors.black,
  double radius = 10,
  final bool showBorder = true,
}) {
  return ButtonStyle(
    elevation: ButtonState.resolveWith((states) => states.isHovering ? 2 : 0),
    shape: ButtonState.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    ),
    backgroundColor: ButtonState.resolveWith(
      (states) => states.isHovering ? bgColor.withOpacity(.8) : bgColor,
    ),
    foregroundColor: ButtonState.all(
      fgColor,
    ),
    border: showBorder
        ? ButtonState.all(
            BorderSide(
              color: fgColor,
              width: 1,
            ),
          )
        : null,
  );
}

class Themes {
  static ThemeData light = theme(true);
  static ThemeData dark = theme(false);

  static ThemeData theme(bool isLight) {
    return ThemeData(
      brightness: isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: isLight ? background : backgroundD,
      accentColor: primaryColor,
      activeColor: isLight ? background : backgroundD,
      borderInputColor: Colors.blue,
      dividerTheme: const DividerThemeData(
          decoration: BoxDecoration(
        color: Colors.grey,
      )),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      focusTheme: FocusThemeData(
        borderRadius: BorderRadius.circular(10),
        primaryBorder: BorderSide(color: surfaceD, width: 1),
        renderOutside: true,
      ),
      buttonTheme: ButtonThemeData(
        outlinedButtonStyle: ButtonStyle(
          shape: ButtonState.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          border: ButtonState.all(
            BorderSide(
              color: surfaceD,
              width: 2,
            ),
          ),
        ),
        filledButtonStyle: ButtonStyle(
          padding: ButtonState.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          ),
          shape: ButtonState.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      pillButtonBarTheme: PillButtonBarThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: ButtonState.resolveWith(
          (states) => states.isHovering ? primaryColor.light : primaryColor,
        ),
        selectedTextStyle: TextStyle(color: fixLight),
        unselectedColor: ButtonState.resolveWith(
          (states) {
            if (states.isHovering) {
              if (isLight) {
                return secondaryContainer.withOpacity(.7);
              } else {
                return secondaryContainerD.withOpacity(.5);
              }
            } else {
              if (isLight) {
                return secondaryContainer;
              } else {
                return secondaryContainerD;
              }
            }
          },
        ),
        unselectedTextStyle: TextStyle(color: isLight ? fixDark : fixLight),
      ),
      chipTheme: ChipThemeData(
        textStyle: ButtonState.all(
          TextStyle(color: Colors.grey[130]),
        ),
        decoration: ButtonState.resolveWith((state) {
          if (state.isHovering) {
            return BoxDecoration(
              color: Colors.grey[40],
              borderRadius: BorderRadius.circular(8),
            );
          }
          if (state.isNone) {
            return BoxDecoration(
              color: Colors.grey[30],
              borderRadius: BorderRadius.circular(8),
            );
          }
          if (state.isDisabled) {
            return BoxDecoration(
              color: Colors.grey[60],
              borderRadius: BorderRadius.circular(8),
            );
          }

          return const BoxDecoration();
        }),
      ),
      radioButtonTheme: RadioButtonThemeData(
        uncheckedDecoration: ButtonState.resolveWith(
          (states) {
            if (states.isHovering) {
              return BoxDecoration(
                color: primaryColor.withOpacity(.1),
                border: Border.all(color: primaryColor, width: 1),
                shape: BoxShape.circle,
              );
            }
            return BoxDecoration(
              border: Border.all(color: primaryColor, width: 1),
              shape: BoxShape.circle,
            );
          },
        ),
      ),
      toggleSwitchTheme: ToggleSwitchThemeData(
        uncheckedDecoration: ButtonState.resolveWith(
          (states) {
            if (states.isHovering) {
              return BoxDecoration(
                color: primaryColor.withOpacity(.1),
                border: Border.all(color: primaryColor, width: 1),
                borderRadius: BorderRadius.circular(30),
              );
            }
            return BoxDecoration(
              border: Border.all(color: primaryColor, width: 1),
              borderRadius: BorderRadius.circular(30),
            );
          },
        ),
      ),

      splitButtonTheme: SplitButtonThemeData(
        primaryButtonStyle: ButtonStyle(
          border: ButtonState.all(
            const BorderSide(),
          ),
          shape: ButtonState.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(5),
              ),
            ),
          ),
        ),
        actionButtonStyle: ButtonStyle(
          padding: ButtonState.all(
            const EdgeInsets.all(8),
          ),
          border: ButtonState.all(
            const BorderSide(),
          ),
          shape: ButtonState.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(5),
              ),
            ),
          ),
        ),
        interval: 0,
      ),
      // bottomSheetTheme: BottomSheetThemeData(
      //   backgroundColor: surface,
      //   elevation: 5,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       top: Radius.circular(10),
      //     ),
      //   ),
      // ),
    );
  }
}
