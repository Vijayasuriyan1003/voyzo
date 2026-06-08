import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/voyzo_app_bar.dart';

/// Settings entry from the Profile menu. The Figma only references "Setting" as
/// a menu row (no detailed layout), so this provides the common driver toggles.
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _push = true;
  bool _location = true;
  bool _sound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      appBar: const VoyzoAppBar(title: 'Setting', showProfile: false),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        children: [
          _card([
            _toggle('Push Notifications', _push, (v) => setState(() => _push = v)),
            _toggle('Location Access', _location,
                (v) => setState(() => _location = v)),
            _toggle('Trip Sound Alerts', _sound, (v) => setState(() => _sound = v)),
          ]),
          SizedBox(height: 16.h),
          _card([
            _link('Change Password'),
            _link('Privacy Policy'),
            _link('Terms & Condition'),
            _link('About Voyzo'),
          ]),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 14,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(children: children),
      );

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      title: Text(
        label,
        style: TextStyle(fontSize: 15.sp, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _link(String label) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontSize: 15.sp, color: AppColors.textSecondary),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: AppColors.textSecondary, size: 22.sp),
      onTap: () {},
    );
  }
}
