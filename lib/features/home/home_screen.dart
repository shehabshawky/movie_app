import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_Assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../auth/presentation/controller/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () => Navigator.pop(ctx, false),
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
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          AppAssets.splashLogo,
          height: 36,
        ),
        actions: [
          IconButton(
            tooltip: 'Log Out',
            icon: const Icon(
              Icons.logout,
              color: AppColors.yellowColor,
            ),
            onPressed: () => _onLogout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // User Avatar
                if (user?.avatar != null && user!.avatar!.isNotEmpty)
                  CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(user.avatar!),
                  )
                else
                  const CircleAvatar(
                    radius: 54,
                    backgroundColor: AppColors.greyColor,
                    child: Icon(
                      Icons.person,
                      size: 54,
                      color: AppColors.yellowColor,
                    ),
                  ),
                const SizedBox(height: 18),

                // User Name
                Text(
                  user?.name.isNotEmpty == true ? user!.name : 'Welcome!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // User Email
                if (user?.email.isNotEmpty == true)
                  Text(
                    user!.email,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 36),

                // Log Out Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _onLogout(context),
                    icon: const Icon(Icons.logout, color: Colors.black),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
