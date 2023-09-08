import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/theme/salmon_colors.dart';
import 'package:salmon/views/shared/salmon_circle_image_avatar/salmon_circle_image_avatar.dart';

import '../../../helpers/salmon_anims.dart';

/// interactable circle avatar
/// ..
/// user can tap to select an image
class ImagePickerCircleAvatar extends HookWidget {
  const ImagePickerCircleAvatar({
    this.onSelected,
    this.initialImage,
    Key? key,
  }) : super(key: key);

  final void Function(XFile? image)? onSelected;
  final ImageProvider? initialImage;
  static const double _radius = 128;

  @override
  Widget build(BuildContext context) {
    final image = useState<XFile?>(null);
    final imageData = useState<Uint8List?>(null);
    final plusIconAnimCon = useAnimationController(duration: const Duration());
    final isMounted = useIsMounted();

    useEffect(() {
      /// if no callback is provided, don't add listeners :D
      if (onSelected == null) return null;

      void listener() async {
        onSelected!(image.value);

        if (image.value != null) {
          imageData.value = await image.value?.readAsBytes();
        }
      }

      image.addListener(() => listener());

      return () => image.removeListener(() => listener());
    }, [image.value]);

    return GestureDetector(
      onTap: () async {
        final i = await SalmonHelpers.pickImageFromSource(context);

        /// if the user aborts the process of selecting another image,
        ///  don't assign [null] instead of the previously selected image
        if (i == null) return;

        image.value = i;
      },
      child: Stack(
        children: [
          SalmonCircleImageAvatar(
            radius: _radius,
            image: imageData.value.asMemImg ?? initialImage,
          ),
          Positioned(
            bottom: 2,
            right: 12,
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  SalmonColors.white,
                  BlendMode.srcATop,
                ),
                child: Lottie.asset(
                  SalmonAnims.plus,
                  frameRate: FrameRate.max,
                  repeat: false,
                  controller: plusIconAnimCon,
                  onLoaded: (comp) {
                    plusIconAnimCon.duration = comp.duration;

                    Future.delayed(
                      const Duration(milliseconds: 150),
                      () {
                        if (isMounted()) {
                          return plusIconAnimCon.forward();
                        }
                      },
                    );
                  },
                  addRepaintBoundary: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
