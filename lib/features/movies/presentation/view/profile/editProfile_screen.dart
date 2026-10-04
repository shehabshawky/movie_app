import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/storage.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/movies/presentation/view/profile/cubit/profile_cubit.dart';
import 'package:movie_app/gen/assets.gen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<String> avatars = [
    Assets.avatar.avatar1.path,
    Assets.avatar.avatar2.path,
    Assets.avatar.avatar3.path,
    Assets.avatar.avatar4.path,
    Assets.avatar.avatar5.path,
    Assets.avatar.avatar6.path,
    Assets.avatar.avatar7.path,
    Assets.avatar.avatar8.path,
    Assets.avatar.avatar9.path,
  ];

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  int selectedAvatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF212322),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: avatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final bool isSelected = selectedAvatarIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAvatarIndex = index;
                      });
                      Navigator.pop(sheetContext);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.yellowColor.withValues(alpha: 0.25)
                            : const Color(0xFF282A28),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.yellowColor
                              : const Color(0xFF4A4C4A),
                          width: isSelected ? 2.5 : 1.2,
                        ),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(avatars[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteAccount(BuildContext context, ProfileCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.greyColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this account? You cannot undo this action.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteUser();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getUser(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is GetUserSuccessState) {
            _nameController.text = state.profile.data?.name ?? '';
            _phoneController.text = state.profile.data?.phone ?? '';
            final int rawAvatarId = state.profile.data?.avaterId ?? 1;
            if (rawAvatarId >= 1 && rawAvatarId <= avatars.length) {
              setState(() {
                selectedAvatarIndex = rawAvatarId - 1;
              });
            }
          }
          if (state is UserUpdateSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Profile updated successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
          if (state is UserUpdateErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
          if (state is DeleteUserSuccessState) {
            TokenManager.delete();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginRoute,
              (r) => false,
            );
          }
        },
        builder: (context, state) {
          final bool isLoading =
              state is GetUserLoadingState ||
              state is UserUpdateLoadingState ||
              state is DeleteUserLoadingState;

          return Scaffold(
            backgroundColor: AppColors.darkBackgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.darkBackgroundColor,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.yellowColor,
                  size: 26,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Pick Avatar',
                style: TextStyle(
                  color: AppColors.yellowColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 24,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),

                            // Top Avatar
                            Center(
                              child: GestureDetector(
                                onTap: _showAvatarPicker,
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(
                                    avatars[selectedAvatarIndex],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Name Field
                            Container(
                              height: 58,
                              decoration: BoxDecoration(
                                color: AppColors.greyColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _nameController,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Name',
                                        hintStyle: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 16,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Phone Field
                            Container(
                              height: 58,
                              decoration: BoxDecoration(
                                color: AppColors.greyColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Phone',
                                        hintStyle: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 16,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Reset Password Text Link
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.forgetPasswordRoute,
                                  );
                                },
                                child: const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(),
                            const SizedBox(height: 32),

                            // Delete Account Button (Red)
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _confirmDeleteAccount(
                                        context,
                                        context.read<ProfileCubit>(),
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.redColor,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Update Data Button (Yellow)
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context.read<ProfileCubit>().updateUser(
                                          name: _nameController.text.trim(),
                                          phone: _phoneController.text.trim(),
                                          avatarId: selectedAvatarIndex + 1,
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.yellowColor,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Text(
                                        'Update Data',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
