import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:voyzo/features/auth/widgets/customer_bottom_navbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyzo/features/auth/data/auth_api.dart';
import 'package:voyzo/features/auth/presentation/provider/user_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool isLocal = true;
  bool isAnimating = false;

  late final PageController pageController;

  String? bookingFor;
  String? vehicleType;
  String? passengers;
  String? typeOfUse;

  DateTime? pickupDateTimeValue;
  DateTime? dropDateTimeValue;

  final guestNameController = TextEditingController();
  final mobileController = TextEditingController();
  final dateTimeController = TextEditingController();
  final dropDateTimeController = TextEditingController();
  final pickupController = TextEditingController();
  final dropController = TextEditingController();

  String? errorText;
  String? mobileNoError;

  final authApi = AuthApi();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

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

    setState(() {
      pickupDateTimeValue = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      dateTimeController.text = formatForFrappe(pickupDateTimeValue!);

      errorText = null;
    });
  }

  Future<void> dropDateTime() async {
    setState(() {
      errorText = null;
    });

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: pickupDateTimeValue ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final selectedDropDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (pickupDateTimeValue != null &&
        selectedDropDateTime.isBefore(pickupDateTimeValue!)) {
      print('Pickup: $pickupDateTimeValue');
      print('Drop: $selectedDropDateTime');
      setState(() {
        dropDateTimeValue = null;
        dropDateTimeController.clear();
        errorText = 'Drop date time must be after pickup date time';
      });
      return;
    }

    setState(() {
      dropDateTimeValue = selectedDropDateTime;
      dropDateTimeController.text = formatForFrappe(dropDateTimeValue!);
      errorText = null;
    });
  }

  String formatForFrappe(DateTime dateTime) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');

    return '${dateTime.year}-'
        '${twoDigit(dateTime.month)}-'
        '${twoDigit(dateTime.day)} '
        '${twoDigit(dateTime.hour)}:'
        '${twoDigit(dateTime.minute)}:00';
  }

  Future<void> submitBooking() async {
    setState(() {
      errorText = null;
      mobileNoError = null;
    });

    if (bookingFor == null ||
        guestNameController.text.trim().isEmpty ||
        mobileController.text.trim().isEmpty ||
        vehicleType == null ||
        passengers == null ||
        dateTimeController.text.trim().isEmpty ||
        dropDateTimeController.text.trim().isEmpty ||
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
        mobileNoError = 'Please enter valid 10 digit mobile number';
      });
      return;
    }

    final user = ref.read(userProvider);

    if (user == null || user.customerId.isEmpty) {
      setState(() {
        errorText = 'Customer data not found. Please login again.';
      });
      return;
    }

    final success = await authApi.createBookingRequest(
      customerId: user.customerId,
      guestName: guestNameController.text.trim(),
      guestPhoneNumber: '+91${mobileController.text.trim()}',
      isLocal: isLocal,
      subTripType: typeOfUse!,
      fromDateTime: dateTimeController.text.trim(),
      toDateTime: dropDateTimeController.text.trim(),
      vehicleType: vehicleType!,
      pickupLocation: pickupController.text.trim(),
      dropOffLocation: dropController.text.trim(),
      passengers: passengers!,
    );

    if (!mounted) return;

    if (success) {
      context.push(
        '/booking_success',
        extra: {'dateTime': dateTimeController.text.trim()},
      );
    } else {
      setState(() {
        errorText = 'Booking failed. Please try again.';
      });
    }
  }

  InputDecoration fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  Future<void> changeTripType(bool local) async {
    if (isAnimating) return;
    if (isLocal == local) return;

    setState(() {
      isAnimating = true;
    });

    await pageController.animateToPage(
      local ? 0 : 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );

    setState(() {
      isLocal = local;
      isAnimating = false;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    guestNameController.dispose();
    mobileController.dispose();
    dateTimeController.dispose();
    dropDateTimeController.dispose();
    pickupController.dispose();
    dropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Booking'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              context.go('/customer_profile');
            },
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider);
                final fullName = user?.fullName ?? '';
                final nameParts = fullName.trim().split(' ');

                String initials = '';

                if (nameParts.length >= 2) {
                  initials = '${nameParts[0][0]}${nameParts[1][0]}'
                      .toUpperCase();
                } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
                  initials = nameParts[0][0].toUpperCase();
                }

                return CircleAvatar(
                  radius: 14.r,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            children: [
              SizedBox(height: 5.h),

              Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(userProvider);

                  return Text(
                    'Welcome ${user?.fullName ?? ''}\nBook your Trip.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  );
                },
              ),

              SizedBox(height: 18.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  choiceButton('Local', isLocal, () {
                    changeTripType(true);
                  }),
                  SizedBox(width: 15.w),
                  choiceButton('Outstation', !isLocal, () {
                    changeTripType(false);
                  }),
                ],
              ),

              SizedBox(height: 20.h),

              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(child: _bookingForm(local: true)),
                    SingleChildScrollView(child: _bookingForm(local: false)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomerBottomNavBar(currentIndex: 0),
    );
  }

  Widget _bookingForm({required bool local}) {
    return Column(
      children: [
        DropdownButtonFormField2<String>(
          valueListenable: ValueNotifier(bookingFor),
          isExpanded: true,
          decoration: const InputDecoration(hintText: 'Book for Yourself'),
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
          items: [
            DropdownItem(
              value: 'self',
              child: Text(
                'Book for Yourself',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            DropdownItem(
              value: 'someone',
              child: Text(
                'Book for Someone Else',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
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
          decoration: fieldDecoration('Enter Name'),
        ),

        SizedBox(height: 10.h),

        TextField(
          controller: mobileController,
          keyboardType: TextInputType.phone,
          decoration: fieldDecoration('Mobile No.'),
        ),

        if (mobileNoError != null) ...[
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              mobileNoError!,
              style: TextStyle(color: AppColors.error, fontSize: 13.sp),
            ),
          ),
        ],

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
          decoration: const InputDecoration(hintText: 'No. of Passengers'),
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
            'From Date & Time',
          ).copyWith(suffixIcon: const Icon(Icons.calendar_month)),
        ),

        SizedBox(height: 10.h),

        TextField(
          controller: dropDateTimeController,
          readOnly: true,
          onTap: dropDateTime,
          decoration: fieldDecoration(
            'To Date & Time',
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
          decoration: fieldDecoration(local ? 'Drop Location' : 'Destination'),
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
            DropdownItem(value: 'One way', child: Text('One way')),
            DropdownItem(value: 'Round Trip', child: Text('Round Trip')),
            DropdownItem(value: 'Multi City', child: Text('Multi City')),
            DropdownItem(value: '8Hr/80Km', child: Text('8Hr/80Km')),
            DropdownItem(value: '12Hr/120Km', child: Text('12Hr/120Km')),
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

        SizedBox(height: 20.h),
      ],
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
