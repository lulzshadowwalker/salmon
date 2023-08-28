part of './settings_comps.dart';

class NotifsDetails extends StatefulHookConsumerWidget {
  const NotifsDetails({super.key});

  @override
  ConsumerState<NotifsDetails> createState() => _NotifsDetailsState();
}

class _NotifsDetailsState extends ConsumerState<NotifsDetails> {
  List? _initialState;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    useEffect(() {
      ref.read(currentUserProvider).whenData(
            (u) => _initialState = u.topics,
          );

      return null;
    }, const []);

    return WillPopScope(
      onWillPop: () async {
        if (user.value != null && user.value!.topics != _initialState) {
          NotifsController.showPopup(
            context: context,
            message:
                'your notificaions preferences have been updated', // TODO tr
            type: NotifType.success,
          );
        }

        return true;
      },
      child: SalmonUnfocusableWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'), // TODO tr
            bottom: const AppBarDivider(),
          ),
          body: Consumer(
            builder: (context, ref, child) {
              final agencies = ref.watch(agenciesProvider);

              return agencies.when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final a = data[index];

                      return a.enName != null
                          ? _NotifSwitch(agency: a)
                          : const SizedBox.shrink();
                    },
                  );
                },
                error: (error, stackTrace) => const Center(
                  child: Text(
                    'unknown error has occurred',
                  ), // TODO tr
                ),
                loading: () => ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: SalmonColors.mutedLight,
                    highlightColor: SalmonColors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        color: SalmonColors.mutedLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: double.infinity,
                      height: 32,
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: 6,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
