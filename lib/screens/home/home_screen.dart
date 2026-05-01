import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/bloc/auth/auth_bloc.dart';
import '../../routes/app_routes.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/fonts.dart';
import '../../utils/theme/text_styles.dart';
import '../../utils/app_sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state is AuthAuthenticated ? state.name : 'Guest';
        final isGuest = state is AuthAuthenticated && state.isGuest;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // App bar
                SliverToBoxAdapter(
                  child: _HomeAppBar(
                    userName: userName,
                    isGuest: isGuest,
                    onLogout: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
                    },
                  ),
                ),

                // Featured projects carousel
                SliverToBoxAdapter(
                  child: _FeaturedCarousel(),
                ),

                // AI Companion
                // SliverToBoxAdapter(
                //   child: _AICompanionCard(),
                // ),

                // Top Locations
                SliverToBoxAdapter(
                  child: _TopLocations(),
                ),

                // Property types
                SliverToBoxAdapter(
                  child: _PropertyTypes(),
                ),

                // Ongoing projects section
                SliverToBoxAdapter(
                  child: _OngoingProjectsSection(),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.xl),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _BottomNav(
            selectedIndex: _selectedIndex,
            onTap: (i) => setState(() => _selectedIndex = i),
          ),
        );
      },
    );
  }
}

// ─── App Bar ───────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget {
  final String userName;
  final bool isGuest;
  final VoidCallback onLogout;

  const _HomeAppBar({
    required this.userName,
    required this.isGuest,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.md,
        AppSizes.lg,
        AppSizes.sm,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryAccent,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                isGuest ? '👤' : userName.substring(0, 1).toUpperCase(),
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HELLO',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  userName.toUpperCase(),
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Notification bell
          IconButton(
            onPressed: () {},
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: AppSizes.iconMd,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Logout
          IconButton(
            onPressed: onLogout,
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}

// ─── Featured Carousel ──────────────────────────────────────────────────────

class _FeaturedCarousel extends StatefulWidget {
  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.88);

  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Lotus Residencies',
      'location': 'Colombo 7',
      'price': 'From LKR 55M',
      'type': 'Apartment',
      'gradient': [Color(0xFF1B4332), Color(0xFF2D6A4F)],
      'progress': 0.72,
    },
    {
      'title': 'Highland Villas',
      'location': 'Kandy Hills',
      'price': 'From LKR 28M',
      'type': 'Villa',
      'gradient': [Color(0xFF0D3B6E), Color(0xFF1565C0)],
      'progress': 0.45,
    },
    {
      'title': 'Green Valley Homes',
      'location': 'Gampaha',
      'price': 'From LKR 18M',
      'type': 'House',
      'gradient': [Color(0xFF4A1942), Color(0xFF8E3A59)],
      'progress': 0.88,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.lg,
            AppSizes.sm,
            AppSizes.lg,
            AppSizes.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Featured Projects', style: AppTextStyles.sectionTitle),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _projects.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final p = _projects[index];
              return _FeaturedCard(project: p);
            },
          ),
        ),
        const SizedBox(height: AppSizes.md),
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _projects.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? AppColors.primary
                    : AppColors.grey300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Map<String, dynamic> project;

  const _FeaturedCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: project['gradient'] as List<Color>,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: (project['gradient'] as List<Color>).first.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: CustomPaint(
                painter: _CardPatternPainter(),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    project['type'] as String,
                    style: const TextStyle(
                      fontFamily: AppFonts.raleway,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  project['title'] as String,
                  style: const TextStyle(
                    fontFamily: AppFonts.playfair,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      project['location'] as String,
                      style: const TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      project['price'] as String,
                      style: const TextStyle(
                        fontFamily: AppFonts.raleway,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Completion',
                          style: TextStyle(
                            fontFamily: AppFonts.inter,
                            fontSize: 10,
                            color: Colors.white60,
                          ),
                        ),
                        Text(
                          '${((project['progress'] as double) * 100).toInt()}%',
                          style: const TextStyle(
                            fontFamily: AppFonts.raleway,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: project['progress'] as double,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.gold,
                        ),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width + 20, -20), 100, paint);
    canvas.drawCircle(Offset(-20, size.height + 20), 80, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── AI Companion ──────────────────────────────────────────────────────────

// class _AICompanionCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(
//         AppSizes.lg,
//         AppSizes.lg,
//         AppSizes.lg,
//         AppSizes.sm,
//       ),
//       padding: const EdgeInsets.all(AppSizes.md),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(AppSizes.radiusLg),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.06),
//             blurRadius: 20,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [AppColors.primary, AppColors.primarySoft],
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.smart_toy_outlined,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//               ),
//               const SizedBox(width: AppSizes.sm),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'AI Companion',
//                     style: AppTextStyles.headlineSmall.copyWith(
//                       color: AppColors.primary,
//                       fontSize: 15,
//                     ),
//                   ),
//                   Text(
//                     'Ask PrimeAssist anything',
//                     style: AppTextStyles.caption,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: AppSizes.md),
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppSizes.md,
//               vertical: AppSizes.md,
//             ),
//             decoration: BoxDecoration(
//               color: AppColors.grey100,
//               borderRadius: BorderRadius.circular(AppSizes.radiusMd),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.chat_bubble_outline_rounded,
//                   color: AppColors.grey400,
//                   size: 18,
//                 ),
//                 const SizedBox(width: AppSizes.sm),
//                 Text(
//                   'Ask about properties, locations...',
//                   style: AppTextStyles.bodyMedium.copyWith(
//                     color: AppColors.textHint,
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: AppColors.primary,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_upward_rounded,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ─── Top Locations ──────────────────────────────────────────────────────────

class _TopLocations extends StatelessWidget {
  final List<Map<String, dynamic>> _locations = const [
    {'name': 'Colombo', 'count': '128 listings', 'icon': '🏙️'},
    {'name': 'Gampaha', 'count': '64 listings', 'icon': '🌿'},
    {'name': 'Kandy', 'count': '47 listings', 'icon': '⛰️'},
    {'name': 'Galle', 'count': '35 listings', 'icon': '🌊'},
    {'name': 'Negombo', 'count': '29 listings', 'icon': '🏖️'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.lg,
            AppSizes.lg,
            AppSizes.lg,
            AppSizes.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top Locations', style: AppTextStyles.sectionTitle),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            itemCount: _locations.length,
            itemBuilder: (context, index) {
              final loc = _locations[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          loc['icon'] as String,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc['name'] as String,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          loc['count'] as String,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Property Types ─────────────────────────────────────────────────────────

class _PropertyTypes extends StatefulWidget {
  @override
  State<_PropertyTypes> createState() => _PropertyTypesState();
}

class _PropertyTypesState extends State<_PropertyTypes> {
  int _selected = 0;

  final List<Map<String, dynamic>> _types = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Apartment', 'icon': Icons.apartment_rounded},
    {'label': 'House', 'icon': Icons.house_rounded},
    {'label': 'Land', 'icon': Icons.landscape_rounded},
    {'label': 'Villa', 'icon': Icons.villa_rounded},
    {'label': 'Commercial', 'icon': Icons.store_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.lg,
            AppSizes.lg,
            AppSizes.lg,
            AppSizes.md,
          ),
          child: Text(
            'Explore By Type',
            style: AppTextStyles.sectionTitle,
          ),
        ),
        SizedBox(
          height: 88,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            itemCount: _types.length,
            itemBuilder: (context, index) {
              final isSelected = _selected == index;
              final type = _types[index];
              return GestureDetector(
                onTap: () => setState(() => _selected = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 78,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type['icon'] as IconData,
                        color: isSelected ? Colors.white : AppColors.grey500,
                        size: 26,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        type['label'] as String,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Ongoing Projects ────────────────────────────────────────────────────────

class _OngoingProjectsSection extends StatelessWidget {
  final List<Map<String, dynamic>> _ongoingProjects = const [
    {
      'name': 'Lotus Residencies',
      'location': 'Colombo 7',
      'progress': 0.72,
      'phase': 'Phase 2 - Structure',
      'dueDate': 'Dec 2025',
      'units': 48,
      'sold': 31,
    },
    {
      'name': 'Highland Villas',
      'location': 'Kandy Hills',
      'progress': 0.45,
      'phase': 'Phase 1 - Foundation',
      'dueDate': 'Jun 2026',
      'units': 24,
      'sold': 12,
    },
    {
      'name': 'Green Valley Homes',
      'location': 'Gampaha',
      'progress': 0.88,
      'phase': 'Phase 3 - Finishing',
      'dueDate': 'Mar 2025',
      'units': 36,
      'sold': 33,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.lg,
            AppSizes.xl,
            AppSizes.lg,
            AppSizes.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ongoing Projects', style: AppTextStyles.sectionTitle),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          itemCount: _ongoingProjects.length,
          itemBuilder: (context, index) {
            return _OngoingProjectCard(project: _ongoingProjects[index]);
          },
        ),
      ],
    );
  }
}

class _OngoingProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;

  const _OngoingProjectCard({required this.project});

  Color _progressColor(double progress) {
    if (progress >= 0.8) return AppColors.success;
    if (progress >= 0.5) return AppColors.primaryLight;
    return AppColors.warning;
  }

  @override
  Widget build(BuildContext context) {
    final progress = project['progress'] as double;
    final sold = project['sold'] as int;
    final total = project['units'] as int;
    final available = total - sold;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['name'] as String,
                      style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.grey400,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          project['location'] as String,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _progressColor(progress).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}% Done',
                  style: TextStyle(
                    fontFamily: AppFonts.raleway,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _progressColor(progress),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.md),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(_progressColor(progress)),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          // Phase & date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project['phase'] as String,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'ETA: ${project['dueDate']}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.md),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSizes.sm),

          // Units stats
          Row(
            children: [
              _StatChip(
                label: 'Total Units',
                value: total.toString(),
                color: AppColors.grey500,
              ),
              const SizedBox(width: AppSizes.md),
              _StatChip(
                label: 'Sold',
                value: sold.toString(),
                color: AppColors.error,
              ),
              const SizedBox(width: AppSizes.md),
              _StatChip(
                label: 'Available',
                value: available.toString(),
                color: AppColors.success,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Details →',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.raleway,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}

// ─── Bottom Nav ──────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.search_rounded,
                label: 'Search',
                isSelected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.bookmark_outline_rounded,
                label: 'Saved',
                isSelected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isSelected: selectedIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.grey400,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.inter,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.grey400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}