// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:voyzo/core/constants/app_constants.dart';

// class HomePage extends ConsumerWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(title: const Text(AppConstants.appName)),
//       body: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.rocket_launch, size: 64),
//             SizedBox(height: 16),
//             Text(
//               'Welcome to Voyzo',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text('Clean Architecture • Riverpod • GoRouter'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLocal = true;

  String? bookingFor;
  String? vehicleType;
  String? passengers;
  String? typeOfUse;

  final guestNameController = TextEditingController();
  final mobileController = TextEditingController();
  final dateTimeController = TextEditingController();
  final pickupController = TextEditingController();
  final dropController = TextEditingController();

  String? errorText;

  Future<void> pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    dateTimeController.text =
        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}  ${pickedTime.format(context)}';
  }

  void submitBooking() {
    setState(() {
      errorText = null;
    });

    if (bookingFor == null ||
        guestNameController.text.trim().isEmpty ||
        mobileController.text.trim().isEmpty ||
        vehicleType == null ||
        passengers == null ||
        dateTimeController.text.trim().isEmpty ||
        pickupController.text.trim().isEmpty ||
        dropController.text.trim().isEmpty ||
        typeOfUse == null) {
      setState(() {
        errorText = 'Please fill all fields';
      });
      return;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobileController.text.trim())) {
      setState(() {
        errorText = 'Please enter valid 10 digit mobile number';
      });
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Booking submitted')));
  }

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  @override
  void dispose() {
    guestNameController.dispose();
    mobileController.dispose();
    dateTimeController.dispose();
    pickupController.dispose();
    dropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),

              Text(
                'Welcome {User Name},\nBook your Trip.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 18.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  choiceButton('Local', isLocal, () {
                    setState(() => isLocal = true);
                  }),
                  SizedBox(width: 15.w),
                  choiceButton('Outstation', !isLocal, () {
                    setState(() => isLocal = false);
                  }),
                ],
              ),

              SizedBox(height: 20.h),

              DropdownButtonFormField2<String>(
                valueListenable: ValueNotifier(bookingFor),
                isExpanded: true,

                decoration: const InputDecoration(
                  hintText: 'Book for Yourself',
                ),

                dropdownStyleData: DropdownStyleData(
                  width: 355.w,
                  offset: const Offset(0, -4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                menuItemStyleData: MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),

                items: const [
                  DropdownItem(value: 'self', child: Text('Book for Yourself')),
                  DropdownItem(
                    value: 'someone',
                    child: Text('Book for Someone Else'),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    bookingFor = value;
                  });
                },
              ),

              SizedBox(height: 10.h),

              TextField(
                controller: guestNameController,
                decoration: fieldDecoration('Guest Name'),
              ),

              SizedBox(height: 10.h),

              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: fieldDecoration('Mobile No.'),
              ),

              SizedBox(height: 10.h),

              DropdownButtonFormField2<String>(
                valueListenable: ValueNotifier(vehicleType),
                decoration: const InputDecoration(hintText: 'Vehicle Type'),
                dropdownStyleData: DropdownStyleData(
                  width: 355.w,
                  offset: const Offset(0, -4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                menuItemStyleData: MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                items: const [
                  DropdownItem(value: 'sedan', child: Text('Sedan')),
                  DropdownItem(value: 'suv', child: Text('SUV')),
                  DropdownItem(value: 'hatchback', child: Text('Hatchback')),
                ],
                onChanged: (value) {
                  setState(() => vehicleType = value);
                },
              ),

              SizedBox(height: 10.h),

              DropdownButtonFormField2<String>(
                valueListenable: ValueNotifier(passengers),
                decoration: const InputDecoration(
                  hintText: 'No. of Passengers',
                ),
                dropdownStyleData: DropdownStyleData(
                  width: 355.w,
                  offset: const Offset(0, -4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                menuItemStyleData: MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                items: const [
                  DropdownItem(value: '1', child: Text('1 Passenger')),
                  DropdownItem(value: '2', child: Text('2 Passengers')),
                  DropdownItem(value: '3', child: Text('3 Passengers')),
                  DropdownItem(value: '4', child: Text('4 Passengers')),
                ],
                onChanged: (value) {
                  setState(() => passengers = value);
                },
              ),

              SizedBox(height: 10.h),

              TextField(
                controller: dateTimeController,
                readOnly: true,
                onTap: pickDateTime,
                decoration: fieldDecoration(
                  'Date & Time',
                ).copyWith(suffixIcon: const Icon(Icons.calendar_month)),
              ),

              SizedBox(height: 10.h),

              TextField(
                controller: pickupController,
                decoration: fieldDecoration('Pickup Location'),
              ),

              SizedBox(height: 10.h),

              TextField(
                controller: dropController,
                decoration: fieldDecoration(
                  isLocal ? 'Drop Location' : 'Destination',
                ),
              ),

              SizedBox(height: 10.h),

              DropdownButtonFormField2<String>(
                valueListenable: ValueNotifier(typeOfUse),
                isExpanded: true,
                decoration: const InputDecoration(hintText: 'Type of use'),
                dropdownStyleData: DropdownStyleData(
                  width: 355.w,
                  offset: const Offset(0, -4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),

                menuItemStyleData: MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                items: const [
                  DropdownItem(value: 'transfer', child: Text('Transfer')),
                  DropdownItem(value: '8hr', child: Text('8 hrs/km')),
                  DropdownItem(value: '12hr', child: Text('12 hrs/km')),
                ],
                onChanged: (value) {
                  setState(() {
                    typeOfUse = value;
                  });
                },
              ),

              if (errorText != null) ...[
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorText!,
                    style: TextStyle(color: AppColors.error, fontSize: 13.sp),
                  ),
                ),
              ],

              SizedBox(height: 20.h),

              AppButton(label: 'Submit', onTap: submitBooking),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            context.push('/booking-history');
          } else if (index == 2) {
            context.push('/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget choiceButton(String text, bool selected, VoidCallback onTap) {
    return SizedBox(
      width: 125.w,
      height: 38.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? AppColors.primary : Colors.grey.shade300,
          foregroundColor: selected ? Colors.white : Colors.grey,
        ),
        child: Text(text),
      ),
    );
  }
}
