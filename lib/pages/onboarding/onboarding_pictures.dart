import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tiki/widgets/custombtn.dart';
import 'package:tiki/widgets/header.dart';
import 'package:tiki/widgets/image_container.dart';

class Pictures extends StatelessWidget {
  final TabController tabController;

  const Pictures({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('STEP 3 OF 6',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 7),
                ],
              ),
              const CustomTextHeader(
                  text: 'Add 2 or More Pictures Of Yourself'),
              const SizedBox(height: 20),
              Row(
                children: const [
                  CustomImageContainer(),
                  SizedBox(width: 5,),
                  CustomImageContainer(),
                  SizedBox(width: 5,),
                  CustomImageContainer(),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: const [
                  CustomImageContainer(),
                  SizedBox(width: 5,),
                  CustomImageContainer(),
                  SizedBox(width: 5,),
                  CustomImageContainer(),
                ],
              ),
            ],
          ),
          Column(
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: 4,
                selectedColor: Theme.of(context).primaryColor,
                unselectedColor: Theme.of(context).colorScheme.surface,
              ),
              SizedBox(height: 10),
              CustomButton(tabController: tabController, text: 'NEXT STEP'),
            ],
          ),
        ],
      ),
    );
  }
}
