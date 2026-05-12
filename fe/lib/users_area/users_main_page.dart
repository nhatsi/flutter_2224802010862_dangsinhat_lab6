import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_management/accounts/login.dart';
import 'package:user_management/constants/api_endpoints.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/models/user_model.dart';
import 'package:user_management/services/fetch_email.dart';
import 'package:user_management/services/role_check.dart';
import 'package:user_management/shared/confirmation_dialog.dart';
import 'package:user_management/shared/error_dialog.dart';
import 'package:user_management/shared/user_details.dart';
import 'package:user_management/users_area/change_user_password.dart';
import 'package:user_management/users_area/edit_user_profile.dart';
import 'package:http/http.dart' as http;

class UsersMainPage extends StatefulWidget {
  const UsersMainPage({super.key});

  @override
  State<UsersMainPage> createState() => _UsersMainPageState();
}

class _UsersMainPageState extends State<UsersMainPage> {
  late String email;

  final Color primaryColor = const Color(0xFF0F766E);
  final Color darkColor = const Color(0xFF0F172A);
  final Color backgroundColor = const Color(0xFFF8FAFC);
  final Color cardColor = Colors.white;

  List<Map<String, dynamic>> buttons = [];

  @override
  void initState() {
    super.initState();
    RoleCheck().checkUserRole(context);
    email = fetchEmailFromToken(context: context);
    addButtonData(context);
  }

  Future<void> getUserInfo({required String email}) async {
    if (email.isEmpty) {
      return;
    }

    final result = await http.post(
      Uri.parse(ApiEndpoints.userInfoReadUpdate),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${TokenHandler().getToken()}',
      },
      body: jsonEncode(email),
    );

    if (result.statusCode >= 200 && result.statusCode <= 299) {
      final jsonData = json.decode(result.body);
      final user = UserModel.fromJson(jsonData);

      if (!mounted) return;
      userDetails(
        context: context,
        user: user,
        color: primaryColor,
      );
    } else {
      var errorBody = jsonDecode(result.body);
      final error = errorBody['message'] ?? "An error occurred.";

      if (!mounted) return;

      errorDialog(
        context: context,
        statusCode: result.statusCode,
        description: error,
        color: primaryColor,
      );
    }
  }

  Future<void> deleteUserAccount({required String email}) async {
    if (email.isEmpty) {
      return;
    }

    final result = await http.delete(
      Uri.parse(ApiEndpoints.userDeleteProfile),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${TokenHandler().getToken()}',
      },
      body: jsonEncode(email),
    );

    if (result.statusCode >= 200 && result.statusCode <= 299) {
      TokenHandler().clearToken();
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      var errorBody = jsonDecode(result.body);
      final error = errorBody['message'] ?? "An error occurred.";

      if (!mounted) return;

      errorDialog(
        context: context,
        statusCode: result.statusCode,
        description: error,
        color: primaryColor,
      );
    }
  }

  void addButtonData(BuildContext context) {
    buttons = [
      {
        'title': 'User Info',
        'subtitle': 'View your account information',
        'icon': Icons.badge_rounded,
        'color': const Color(0xFF0F766E),
        'onPressed': () {
          getUserInfo(email: email);
        },
      },
      {
        'title': 'Edit Profile',
        'subtitle': 'Update your email and phone',
        'icon': Icons.edit_note_rounded,
        'color': const Color(0xFF2563EB),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditUserProfile(email: email),
            ),
          );
        }
      },
      {
        'title': 'Change Password',
        'subtitle': 'Create a new secure password',
        'icon': Icons.lock_reset_rounded,
        'color': const Color(0xFF7C3AED),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeUserPassword(email: email),
            ),
          );
        }
      },
      {
        'title': 'Delete Account',
        'subtitle': 'Remove your account permanently',
        'icon': Icons.delete_forever_rounded,
        'color': const Color(0xFFDC2626),
        'onPressed': () async {
          bool? confirmed = await showConfirmationDialog(
            context: context,
            title: "Confirm",
            content: "Are you sure that you want to delete this user?",
            color: const Color(0xFFDC2626),
          );

          if (confirmed) {
            deleteUserAccount(email: email);
          }
        },
      },
      {
        'title': 'Logout',
        'subtitle': 'Sign out from this device',
        'icon': Icons.logout_rounded,
        'color': const Color(0xFFF59E0B),
        'onPressed': () {
          TokenHandler().clearToken();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (Route<dynamic> route) => false,
          );
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1000 ? 3 : width >= 650 ? 2 : 1;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'User Methods',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: darkColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${buttons.length} actions',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      itemCount: buttons.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: crossAxisCount == 1 ? 4.7 : 2.8,
                      ),
                      itemBuilder: (context, index) {
                        final item = buttons[index];
                        return _UserActionCard(
                          title: item['title'],
                          subtitle: item['subtitle'],
                          icon: item['icon'],
                          color: item['color'],
                          onTap: item['onPressed'],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            const Color(0xFF115E59),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Section',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Personal account management area',
                  style: TextStyle(
                    color: Color(0xFFCCFBF1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.account_circle_rounded,
              color: primaryColor,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: darkColor,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                const Text(
                  'You can view profile, edit information, update password or manage your account.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _UserActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}