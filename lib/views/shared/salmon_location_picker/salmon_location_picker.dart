import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:salmon/helpers/salmon_extensions.dart';

import '../../../helpers/salmon_anims.dart';
import '../../../theme/salmon_colors.dart';

class SalmonLocationPicker extends StatefulHookWidget {
  const SalmonLocationPicker({super.key});

  @override
  State<SalmonLocationPicker> createState() => _SalmonLocationPickerState();
}

class _SalmonLocationPickerState extends State<SalmonLocationPicker> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final markers = useState<Set<Marker>>({});
    final selectedLocation = useState<LatLng?>(null);
    final isLoaded = useState(false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          context.sl.tapToSelectLocation,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: SalmonColors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(172, 47, 47, 47),
                Color.fromARGB(0, 47, 47, 47),
              ],
              stops: [0, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              )
            },
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              isLoaded.value = true;
            },
            zoomControlsEnabled: false,
            markers: markers.value,
            onTap: (loc) {
              selectedLocation.value = loc;

              markers.value = {
                Marker(
                  markerId: const MarkerId('selected-location'),
                  position: loc,
                ),
              };
            },
            myLocationEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(31.9454, 35.9284),
              zoom: 11.0,
            ),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     width: double.infinity,
          //     height: context.mq.padding.top + 36,
          //     alignment: Alignment.center,

          //     decoration: const BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [
          //           Color.fromARGB(172, 47, 47, 47),
          //           Color.fromARGB(0, 47, 47, 47),
          //         ],
          //         stops: [0, 1],
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 8,
                bottom: 14,
                left: 8,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: selectedLocation.value == null
                    ? const SizedBox.shrink()
                    : OutlinedButton(
                        style: Theme.of(context)
                            .outlinedButtonTheme
                            .style
                            ?.copyWith(
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (_) => SalmonColors.white,
                              ),
                              side: MaterialStateProperty.resolveWith<
                                  BorderSide?>(
                                (_) => BorderSide(color: SalmonColors.white),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (_) => context.cs.primaryContainer,
                              ),
                            ),
                        onPressed: () => Navigator.of(context)
                            .maybePop(selectedLocation.value),
                        child: Text(context.sl.save),
                      ),
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 380),
              opacity: isLoaded.value ? 0 : 1,
              child: Container(
                color: context.theme.scaffoldBackgroundColor,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Transform.scale(
                    scale: 8,
                    child: lottie.Lottie.asset(
                      SalmonAnims.googleLoading,
                      reverse: true,
                      filterQuality: FilterQuality.medium,
                      height: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
