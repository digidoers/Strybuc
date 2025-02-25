import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = MediaQuery.of(context).size.width >= 600;
    final crossAxisCount = isTabletOrLarger ? 3 : 2;

    return Scaffold(
      backgroundColor: AppTheme.cardTextColor,
      body: SafeArea(
        child: Padding(
          padding: AppTheme.screenPadding,
          child: Column(
            children: [
              const SizedBox(height: 15),

              Logo(),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio:
                        1.4, // Maintain consistent card proportions
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final cards = [
                      {
                        'title': 'Photograph Parts',
                        'icon': 'photo_parts.svg',
                        'color': AppTheme.secondaryBackgroundColor,
                        'route': '/photograph_parts/instructions',
                      },
                      {
                        'title': 'Live Chat',
                        'icon': 'live_chat.svg',
                        'color': AppTheme.redCardColor,
                        'route': '/live_chat',
                      },
                      {
                        'title': 'Contact Sales Rep',
                        'icon': 'contact_sales_rep.svg',
                        'color': AppTheme.secondaryBackgroundColor,
                        'route': '/contact_sales_rep',
                      },
                      {
                        'title': 'Shop',
                        'icon': 'shop.svg',
                        'color': AppTheme.secondaryBackgroundColor,
                        'route': '/shop',
                      },
                      {
                        'title': 'Exclusive Offers',
                        'icon': 'exclusive_offers.svg',
                        'color': AppTheme.secondaryBackgroundColor,
                        'route': '/exclusive_offers',
                      },
                    ];

                    final card = cards[index];

                    return _buildCard(
                      card['title'] as String,
                      card['icon'] as String,
                      card['color'] as Color,
                      card['route'] as String,
                      context,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16), // White space below the grid
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    String icon,
    Color color,
    String route,
    BuildContext context,
  ) {
    // print('Title: $title, Icon: $icon, Color: $color, Route: $route, Height: $height, Context: $context');
    return GestureDetector(
      onTap: () {
        context.push(route); // Navigate to the specified route
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/$icon',
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.cardTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
