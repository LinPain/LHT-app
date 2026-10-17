import 'package:flutter/material.dart';

import '../app/theme/app_colors.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.onNotificationTap,
    this.onHistoryTap,
    this.onProfileTap,
  });

  final VoidCallback? onNotificationTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'LG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HỒNG TRÀ LÊ GIÁ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'PREMIUM TEA & BOBA',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(Icons.notifications_none,color: AppColors.textPrimary,),
            ),
            IconButton(
              onPressed: onHistoryTap,
              icon: const Icon(Icons.history_rounded,color: AppColors.textPrimary,),
            ),
            IconButton(
              onPressed: onProfileTap,
              icon: const Icon(Icons.person_outline_rounded,color: AppColors.textPrimary,),
            ),
          ],
        ),
      ),
    );
  }
}