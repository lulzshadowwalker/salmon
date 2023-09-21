// ignore_for_file: use_build_context_synchronously

part of './settings_comps.dart';

class AccountDetails extends StatefulHookConsumerWidget {
  const AccountDetails({super.key});

  @override
  ConsumerState<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends ConsumerState<AccountDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = ref.read(currentUserProvider).value;
    final userOverride = useState(const SalmonUserCredentials());
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final isEmailModified = useState(false);
    final isAnyModified = useState(false);
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    useEffect(() {
      void listener() {
        isAnyModified.value =
            nameController.text.isNotEmpty || emailController.text.isNotEmpty;
      }

      nameController.addListener(listener);
      emailController.addListener(() {
        isEmailModified.value = emailController.text.isNotEmpty;
        listener();
      });

      return () {
        nameController.removeListener(listener);
        emailController.removeListener(listener);
      };
    }, const []);

    return SalmonUnfocusableWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(SL.of(context).accountDetails),
          bottom: const AppBarDivider(),
        ),
        body: Center(
          child: SalmonConstrainedBox(
            child: SalmonSingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 48,
                    horizontal: 24,
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'avatar',
                        child: ImagePickerCircleAvatar(
                          initialImage: user?.pfp.asCachedNetImg,
                          onSelected: (image) {
                            userOverride.value = userOverride.value.copyWith(
                              pfpRaw: image,
                            );

                            isAnyModified.value = image != null;
                          },
                        ),
                      ),
                      SalmonFormField(
                        validator: (val) =>
                            (!val.isEmpty && val!.trim().length < 3)
                                ? SL.of(context).nameHasToBeAtLeastThreeChars
                                : null,
                        prefixIcon: const Icon(FontAwesomeIcons.solidUser),
                        controller: nameController,
                        hintText: user?.displayName ?? SL.of(context).name,
                        onSaved: (name) {
                          userOverride.value = userOverride.value.copyWith(
                            displayName: name!.trim(),
                          );
                        },
                      ),
                      SalmonEmailField(
                          onSaved: (email) {
                            userOverride.value = userOverride.value.copyWith(
                              email: email,
                            );
                          },
                          controller: emailController,
                          hintText: user?.email,
                          validator: (value) {
                            if (!isEmailModified.value) return null;

                            return isEmail('$value')
                                ? null
                                : SL.of(context).enterValidEmail;
                          }),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: isEmailModified.value
                            ? SalmonPasswordField(
                                hintText: SL.of(context).confirmPassword,
                                onSaved: (password) {
                                  userOverride.value =
                                      userOverride.value.copyWith(
                                    password: password,
                                  );
                                },
                                validator: (value) {
                                  if (!isEmailModified.value) return null;

                                  return value.length >= 8
                                      ? null
                                      : SL.of(context).pickStrongPassword;
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                      const Spacer(),
                      Bounceable(
                        onTap: () => ref
                            .read(a12nProvider)
                            .sendPasswordResetEmail(context, user!.email!),
                        child: _SettingsOption(
                          margin: const EdgeInsets.only(bottom: 16),
                          title: Text(
                            SL.of(context).resetPassword.toLowerCase(),
                            style: const TextStyle(
                              color: SalmonColors.black,
                            ),
                          ),
                          trailing: const FaIcon(
                            FontAwesomeIcons.solidCircleQuestion,
                          ),
                          isWrapped: true,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: isAnyModified.value
                            ? isLoading.value
                                ? const SalmonLoadingIndicator()
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState == null ||
                                          !_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      _formKey.currentState!.save();

                                      isLoading.value = true;
                                      if (isEmailModified.value) {
                                        ref
                                            .read(salmonUserCredentialsProvider
                                                .notifier)
                                            .set(
                                              userOverride.value.copyWith(
                                                email: user!.email,
                                              ),
                                            );

                                        try {
                                          await ref
                                              .read(a12nProvider)
                                              .emailSignIn(context);
                                        } catch (_) {
                                          if (isMounted()) {
                                            isLoading.value = false;
                                          }
                                          return;
                                        }
                                      }

                                      await ref
                                          .read(usersControllerProvider)
                                          .updateUser(
                                            context,
                                            userOverride.value
                                                .toMap()
                                                .map((key, value) {
                                              if (value.runtimeType != String) {
                                                return MapEntry(key, value);
                                              }

                                              return MapEntry(
                                                key,
                                                (value as String?).isEmpty
                                                    ? null
                                                    : value,
                                              );
                                            }).compact,
                                          );

                                      if (isMounted()) {
                                        isLoading.value = false;
                                        context.pop();
                                      }
                                    },
                                    child: Text(SL.of(context).update),
                                  )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
