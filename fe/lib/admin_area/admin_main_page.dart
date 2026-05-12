import 'package:flutter/material.dart';
import 'package:user_management/accounts/login.dart';
import 'package:user_management/admin_area/add_role.dart';
import 'package:user_management/admin_area/add_user.dart';
import 'package:user_management/admin_area/change_admin_password.dart';
import 'package:user_management/admin_area/edit_profile.dart';
import 'package:user_management/admin_area/get_roles.dart';
import 'package:user_management/admin_area/get_users.dart';
import 'package:user_management/admin_area/select_user.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/services/fetch_email.dart';
import 'package:user_management/services/role_check.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  late String email;

  final Color primaryColor = const Color(0xFF2563EB);
  final Color darkColor = const Color(0xFF0F172A);
  final Color backgroundColor = const Color(0xFFF8FAFC);
  final Color cardColor = Colors.white;

  List<Map<String, dynamic>> buttons = [];

  @override
  void initState() {
    super.initState();
    RoleCheck().checkAdminRole(context);
    email = fetchEmailFromToken(context: context);
    addButtonData(context);
  }

  void addButtonData(BuildContext context) {
    buttons = [
      {
        'title': 'Show Users',
        'subtitle': 'View all registered accounts',
        'icon': Icons.people_alt_rounded,
        'color': const Color(0xFF2563EB),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GetUsers()),
          );
        }
      },
      {
        'title': 'Add New Users',
        'subtitle': 'Create a new user account',
        'icon': Icons.person_add_alt_1_rounded,
        'color': const Color(0xFF16A34A),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUser()),
          );
        },
      },
      {
        'title': 'Show Roles',
        'subtitle': 'View available user roles',
        'icon': Icons.admin_panel_settings_rounded,
        'color': const Color(0xFF7C3AED),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GetRoles()),
          );
        },
      },
      {
        'title': 'Add New Roles',
        'subtitle': 'Create role permissions',
        'icon': Icons.add_moderator_rounded,
        'color': const Color(0xFF0891B2),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRole()),
          );
        },
      },
      {
        'title': 'Change User Roles',
        'subtitle': 'Assign role to selected user',
        'icon': Icons.manage_accounts_rounded,
        'color': const Color(0xFFF59E0B),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SelectUser()),
          );
        },
      },
      {
        'title': 'Edit Profile',
        'subtitle': 'Update admin information',
        'icon': Icons.edit_note_rounded,
        'color': const Color(0xFF0F766E),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(email: email),
            ),
          );
        },
      },
      {
        'title': 'Change Password',
        'subtitle': 'Update account password',
        'icon': Icons.lock_reset_rounded,
        'color': const Color(0xFF9333EA),
        'onPressed': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeAdminPassword(email: email),
            ),
          );
        },
      },
      {
        'title': 'Logout',
        'subtitle': 'Sign out of admin account',
        'icon': Icons.logout_rounded,
        'color': const Color(0xFFDC2626),
        'onPressed': () {
          TokenHandler().clearToken();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1000 ? 4 : width >= 650 ? 2 : 1;

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
                    _buildWelcomeCard(),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Admin Methods',
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
                            '${buttons.length} tools',
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
                        childAspectRatio: crossAxisCount == 1 ? 4.5 : 2.7,
                      ),
                      itemBuilder: (context, index) {
                        final item = buttons[index];
                        return _AdminActionCard(
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
            const Color(0xFF1E40AF),
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
              Icons.dashboard_customize_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Section',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Role Based User Management Dashboard',
                  style: TextStyle(
                    color: Color(0xFFE0F2FE),
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

  Widget _buildWelcomeCard() {
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
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: primaryColor,
              size: 30,
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
                  'Manage users, roles, permissions and account settings from one place.',
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

class _AdminActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminActionCard({
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