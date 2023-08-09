import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/theme/salmon_colors.dart';

class SalmonImagePickerOptions extends StatelessWidget {
  const SalmonImagePickerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // gallery option
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            icon: FaIcon(
              FontAwesomeIcons.solidImage,
              color: SalmonColors.white,
              size: 16,
            ),
            label: Text(SL.of(context).gallery),
          ),
          const SizedBox(height: 5),

          //  camera option
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            icon: FaIcon(
              FontAwesomeIcons.camera,
              color: SalmonColors.white,
              size: 16,
            ),
            label: Text(SL.of(context).camera),
          ),

          // cancel
          const SizedBox(height: 15),
          OutlinedButton(
            style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (_) => SalmonColors.white,
                  ),
                  side: MaterialStateProperty.resolveWith<BorderSide?>(
                    (_) => BorderSide(color: SalmonColors.white),
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (_) => context.cs.primaryContainer,
                  ),
                ),
            onPressed: () => Navigator.of(context).pop(),

            child: Text(
              SL.of(context).cancel,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            // color: Colors.transparent,
            // borderless: false,
            // foregroundColor: BethColors.lightPrimary1,
          ),
        ],
      ),
    );
  }
}
