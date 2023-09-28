// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:salmon/controllers/notifs/notifs_controller.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';
import 'package:salmon/models/enums/notif_type.dart';
import 'package:salmon/models/salmon_silent_exception.dart';

import '../../../helpers/salmon_anims.dart';
import '../../../theme/salmon_colors.dart';

class SalmonLocationPicker extends StatefulHookConsumerWidget {
  const SalmonLocationPicker({super.key});

  @override
  ConsumerState<SalmonLocationPicker> createState() =>
      _SalmonLocationPickerState();
}

class _SalmonLocationPickerState extends ConsumerState<SalmonLocationPicker> {
  late GoogleMapController mapController;
  final _log = SalmonHelpers.getLogger('SalmonLocationPicker');

  static const ammanLoc = LatLng(31.9454, 35.9284);

  Future<LatLng> _getCurrentLocation() async {
    try {
      await Geolocator.requestPermission().then((perm) {
        _log.v('location permission: $perm');
        if (perm == LocationPermission.deniedForever ||
            perm == LocationPermission.denied) {
          NotifsController.showPopup(
            context: context,
            title: context.sl.permissionRequired,
            message: context.sl.needLocationPermission,
            type: NotifType.tip,
          );

          throw SalmonSilentException(
              'permission is required to fetch the current location (permission: $perm)');
        } else if (perm == LocationPermission.unableToDetermine) {
          throw Exception(
              'cannot determine location permission (permission: $perm)');
        }
      });

      final pos = await Geolocator.getCurrentPosition();
      _log.v('position: ${pos.toString()}');
      return LatLng(pos.latitude, pos.longitude);
    } on SalmonSilentException catch (e) {
      _log.e(e.message);
      return ammanLoc;
    } catch (e) {
      NotifsController.showPopup(
        context: context,
        message: context.sl.couldNotFetchLocation,
        type: NotifType.oops,
      );
      SalmonHelpers.handleException(e: e, logger: _log);
      return ammanLoc;
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = useState<Set<Marker>>({});
    final selectedLocation = useState<LatLng?>(null);
    final isLoaded = useState(false);
    final isCurrentLocLoading = useState(false);

    return Scaffold(
      backgroundColor: SalmonColors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(color: SalmonColors.white),
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
      floatingActionButton: Platform.isAndroid
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton(
                onPressed: () async {
                  isCurrentLocLoading.value = true;
                  final pos = await _getCurrentLocation();
                  isCurrentLocLoading.value = false;

                  mapController.moveCamera(CameraUpdate.newLatLng(pos));
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 380),
                  child: isCurrentLocLoading.value
                      ? const Padding(
                          padding: EdgeInsets.all(18.0),
                          child: CircularProgressIndicator(
                            color: SalmonColors.black,
                            strokeWidth: 6,
                          ),
                        )
                      : const Icon(
                          FontAwesomeIcons.locationCrosshairs,
                        ),
                ),
              ),
            )
          : null,
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
              target: ammanLoc,
              zoom: 11.0,
            ),
          ),
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
                    : SafeArea(
                        child: OutlinedButton(
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
                                  (_) => const BorderSide(
                                      color: SalmonColors.white),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (_) => context.cs.primary,
                                ),
                              ),
                          onPressed: () => Navigator.of(context)
                              .maybePop(selectedLocation.value),
                          child: Text(context.sl.save),
                        ),
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
