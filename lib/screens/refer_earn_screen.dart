import 'package:cash_monkey/utils/color_theme.dart';
import 'package:cash_monkey/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({super.key});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen>
    with SingleTickerProviderStateMixin {
  String? referCode = "ABC123";
  String? totalReferrers = "0";
  late TabController _tabController;

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      referCode = prefs.getString("referCode");
      totalReferrers = prefs.getString("totalReferrers") ?? "0";
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.8;

    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorTheme.appBarColor,
        title: const Text(
          'Refer & Earn',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              child: Text(
                "Invite",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Rewards",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInviteTab(buttonWidth, size, referCode),
          _buildRewardsTab(totalReferrers),
        ],
      ),
    );
  }

  Widget _buildInviteTab(double buttonWidth, Size size, String? referCode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Invite your friends and earn coins!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade900,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "$referCode",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.blue,
                        ],
                      ),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        try {
                          await Share.share(
                            'Join CashMonkey and start earning rewards with me! \n Refer Code: $referCode',
                          );
                        } catch (e) {
                          print('Error sharing: $e');
                        }
                      },
                      child: const Text(
                        "Invite Now!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "How it works?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildStep(
              icon: Icons.person_add_alt_1,
              title: "What will my friends get?",
              description:
                  "Your friend will get a signup bonus upon joining the app.",
            ),
            const SizedBox(height: 20),
            _buildStep(
              icon: Icons.attach_money,
              title: "What will I get?",
              description:
                  "You will get 50% lifetime commission on your friend's earnings.",
            ),
            const SizedBox(height: 20),
            _buildStep(
              icon: Icons.rule,
              title: "What are terms of invites?",
              description:
                  "Your friend needs to join the app using your referral link and earn coins. It is that simple.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsTab(totalReferrers) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 29, 29, 29),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                      Icons.monetization_on, "Referral Earning", "0"),
                  _buildStatItem(
                      Icons.person, "Total Referrals", "$totalReferrers"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Reward Timeline",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Check the rewards timeline for the latest updates on your earned benefits",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            _buildRewardItem(10, "Win 500 coins"),
            _buildRewardItem(50, "Win 3000 coins"),
            _buildRewardItem(100, "Win 7500 coins"),
            _buildRewardItemWithImage(
                500,
                "Sandisk 128GB Pen Drive",
                "assets/images/pendrive.png",
                "High speed USB 2.0 pen drive with 128GB storage capacity."),
            _buildRewardItemWithImage(
                1000,
                "Mi 10000mAh Power Bank",
                "assets/images/powerbank.png",
                "Portable power bank with 18W fast charging support."),
            _buildRewardItemWithImage(
                2500,
                "Sony Wireless Headphones",
                "assets/images/headphones.png",
                "Bluetooth on-ear headphones with up to 35 hours playtime."),
            _buildRewardItemWithImage(
                5000,
                "Amazfit GTS 4 Mini Smart Watch",
                "assets/images/watch.png",
                "Fitness tracker with heart rate monitor, GPS, and 120+ sports modes."),
            _buildRewardItemWithImage(
                10000,
                "Apple Airpods (2nd Gen)",
                "assets/images/airpods.png",
                "High-quality wireless earbuds with active noise cancellation."),
            _buildRewardItemWithImage(
                25000,
                "Apple 10.9-inch iPad (Wi-Fi,64GB)",
                "assets/images/ipad.png",
                "9th generation iPad with 10.9-inch display and 64GB storage."),
            _buildRewardItemWithImage(
              50000,
              "Apple iPhone 15 (128GB)",
              "assets/images/iphone.png",
              "Apple iPhone 15 with 6.1-inch display, 128GB storage and 5G support.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardItem(int invites, String reward) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.radio_button_unchecked,
            color: Colors.greenAccent,
            size: 24,
          ),
          const SizedBox(width: 16),
          // Reward description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Unlock at $invites invites",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.greenAccent, width: 1),
                ),
                child: Text(
                  reward,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItemWithImage(
      int invites, String reward, String image, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.radio_button_unchecked,
            color: Colors.greenAccent,
            size: 24,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Unlock at $invites invites",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.greenAccent, width: 1),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image(
                        image: AssetImage(image),
                        height: 60,
                        width: 60,
                      ),
                    ),
                    Sizes.horizontalSpacing(15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Sizes.verticalSpacing(5),
                          Text(
                            desc,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 92, 204, 150),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.pink, Colors.red],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
