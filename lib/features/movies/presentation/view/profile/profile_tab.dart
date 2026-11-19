import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/routes/app_routes.dart';
import 'package:movie_app/core/storage.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/auth/presentation/controller/auth_provider.dart';
import 'package:movie_app/features/movies/presentation/view/profile/cubit/profile_cubit.dart';
import 'package:movie_app/features/movies/presentation/view_model/add_favorite_cubit.dart';
import 'package:movie_app/features/movies/presentation/widgets/movie_poster_card.dart';
import 'package:movie_app/gen/assets.gen.dart';
import 'package:movie_app/model/get_all_favorite_model.dart';
import 'package:provider/provider.dart';

import 'package:movie_app/features/auth/domain/entities/user_entity.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileTabView();
  }
}

class _ProfileTabView extends StatefulWidget {
  const _ProfileTabView();

  @override
  State<_ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<_ProfileTabView> {
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

  void _onLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.greyColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await context.read<AuthProvider>().logout();
              } catch (_) {}
              await FirebaseAuth.instance.signOut();
              await TokenManager.delete();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginRoute,
                  (r) => false,
                );
              }
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.darkBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              final user = (profileState is GetUserSuccessState)
                  ? profileState.profile.data
                  : null;

              UserEntity? authUser;
              try {
                authUser = context.read<AuthProvider>().currentUser;
              } catch (_) {}
              final firebaseUser = FirebaseAuth.instance.currentUser;

              String resolvedName = '';
              if (user != null &&
                  user.name != null &&
                  user.name!.trim().isNotEmpty &&
                  user.name!.trim().toLowerCase() != 'user') {
                resolvedName = user.name!.trim();
              } else if (authUser != null &&
                  authUser.name.trim().isNotEmpty &&
                  authUser.name.trim().toLowerCase() != 'user') {
                resolvedName = authUser.name.trim();
              } else if (firebaseUser?.displayName != null &&
                  firebaseUser!.displayName!.trim().isNotEmpty &&
                  firebaseUser.displayName!.trim().toLowerCase() != 'user') {
                resolvedName = firebaseUser.displayName!.trim();
              } else if (firebaseUser?.email != null &&
                  firebaseUser!.email!.isNotEmpty) {
                resolvedName = firebaseUser.email!.split('@').first;
              } else {
                resolvedName = 'User';
              }

              final String userName = resolvedName;

              int rawAvatarId = user?.avaterId ?? 1;
              if (rawAvatarId == 1 && authUser?.avatar != null) {
                final match =
                    RegExp(r'avatar(\d+)').firstMatch(authUser!.avatar!);
                if (match != null) {
                  rawAvatarId = int.tryParse(match.group(1) ?? '1') ?? 1;
                }
              }

              final int avatarIndex =
                  (rawAvatarId >= 1 && rawAvatarId <= avatars.length)
                      ? rawAvatarId - 1
                      : 0;
              final String avatarPath = avatars[avatarIndex];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Avatar + Name | Wish List | History
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left: Avatar + Name
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 46,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(avatarPath),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    userName,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            // Middle: Wish List Count & Label
                            BlocBuilder<AddFavoriteCubit, AddFavoriteState>(
                              builder: (context, favState) {
                                final int count =
                                    (favState is GetAllFavoriteSuccess)
                                        ? favState.favoriteList.length
                                        : 0;
                                return Column(
                                  children: [
                                    Text(
                                      '$count',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Wish List',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            const Spacer(),

                            // Right: History Count & Label
                            const Column(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'History',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 8),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Action Buttons: Edit Profile (Yellow) & Exit (Red)
                        Row(
                          children: [
                            // Edit Profile Button
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      AppRoutes.editProfileScreen,
                                    );
                                    if (result == true && context.mounted) {
                                      context.read<ProfileCubit>().getUser();
                                      try {
                                        context
                                            .read<AuthProvider>()
                                            .loadCurrentUser();
                                      } catch (_) {}
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.yellowColor,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Exit Button
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _onLogout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.redColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Exit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.exit_to_app,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // TabBar: Watch List / History
                  const TabBar(
                    indicatorColor: AppColors.yellowColor,
                    indicatorWeight: 3.5,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    dividerColor: Colors.transparent,
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.format_list_bulleted,
                            color: AppColors.yellowColor, size: 28),
                        text: 'Watch List',
                      ),
                      Tab(
                        icon: Icon(Icons.folder,
                            color: AppColors.yellowColor, size: 28),
                        text: 'History',
                      ),
                    ],
                  ),

                  // TabBarView Content
                  Expanded(
                    child: BlocBuilder<AddFavoriteCubit, AddFavoriteState>(
                      builder: (context, favState) {
                        if (favState is GetAllFavoriteLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.yellowColor,
                            ),
                          );
                        }

                        final List<Data> favoriteList =
                            (favState is GetAllFavoriteSuccess)
                                ? favState.favoriteList
                                : <Data>[];

                        return TabBarView(
                          children: [
                            // 1. Watch List Tab
                            favoriteList.isEmpty
                                ? Center(
                                    child: Image.asset(
                                      Assets.images.pobcornImage.path,
                                      width: 140,
                                      height: 140,
                                    ),
                                  )
                                : GridView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 14,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.68,
                                    ),
                                    itemCount: favoriteList.length,
                                    itemBuilder: (context, index) {
                                      final movie = favoriteList[index];
                                      return MoviePosterCard(
                                        image: movie.imageURL ?? '',
                                        rating: movie.rating ?? 0.0,
                                        featured: favoriteList,
                                        index: index,
                                      );
                                    },
                                  ),

                            // 2. History Tab (Empty state)
                            Center(
                              child: Image.asset(
                                Assets.images.pobcornImage.path,
                                width: 140,
                                height: 140,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
