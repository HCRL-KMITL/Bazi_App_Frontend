import 'package:bazi_app_frontend/models/user_model.dart';
import 'package:bazi_app_frontend/repositories/misc_repository.dart';
import 'package:bazi_app_frontend/screens/guesthora_screen.dart';
import 'package:bazi_app_frontend/widgets/my_element_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets.dart';
import 'edit_info_widget.dart';

class ProfileWidget extends StatefulWidget {
  final UserModel userData;

  const ProfileWidget({required this.userData, super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        currentUser!.photoURL!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 195,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditInfoWidget(oldData: widget.userData),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit, color: Colors.black, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "แก้ไขข้อมูล",
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "ข้อมูลส่วนตัว",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.userData.name,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    widget.userData.gender == 0 ? Icons.male : Icons.female,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.userData.email,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                color: const Color(0x12000000),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 400,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cake),
                      const SizedBox(width: 10),
                      Text(
                        MiscRepository().displayThaiDate(
                          widget.userData.birthDate.split(" ")[0],
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.schedule),
                      const SizedBox(width: 10),
                      Text(
                        "${widget.userData.birthDate.split(" ")[1].substring(0, 5)} น.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "การทำนายด้วยศาสตร์ บาจื้อ",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).primaryColor,
                      decorationColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  TopCircleOnly(chart: widget.userData.baziChart),
                  Center(
                    child: personalElementText(
                      context,
                      widget.userData.baziChart.dayPillar.heavenlyStem.name,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuestHoraScreen(
                            name: widget.userData.name,
                            birthDate: widget.userData.birthDate.split(" ")[0],
                            birthTime: widget.userData.birthDate.split(" ")[1],
                            gender: widget.userData.gender,
                          ),
                          settings: RouteSettings(
                            arguments: {'from': 'member'},
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      "อ่านผลการทำนายเต็มๆ",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall!.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
