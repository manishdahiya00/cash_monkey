import 'package:cash_monkey/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:cash_monkey/utils/color_theme.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  String? image;

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      email = prefs.getString("email");
      image = prefs.getString("image");
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildUserInfoCard(context),
            _buildActionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: image != null
                ? NetworkImage(image!) as ImageProvider
                : const AssetImage('assets/images/profile.png')
                    as ImageProvider,
            radius: 50,
          ),
          Sizes.verticalSpacing(10),
          Text(
            name ?? "USER",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: ColorTheme.appBarColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem('Email', email ?? "****"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItemWithCopy(
      String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, color: Colors.greenAccent, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Copied to Clipboard!'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.transparent,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Actions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildActionItem(Icons.privacy_tip, 'Privacy Policy', () async {
          const url =
              'https://cash-monkey-d4b1d5748d36.herokuapp.com/privacy.html';
          if (!await launchUrl(Uri.parse(url))) {
            throw 'Could not launch $url';
          }
        }),
        _buildActionItem(Icons.help, 'Terms and Conditions', () async {
          const url =
              'https://cash-monkey-d4b1d5748d36.herokuapp.com/terms.html';
          if (!await launchUrl(Uri.parse(url))) {
            throw 'Could not launch $url';
          }
        }),
        _buildActionItem(Icons.contact_mail, 'Contact Us', () async {
          const url =
              'https://cash-monkey-d4b1d5748d36.herokuapp.com/contact.html';
          if (!await launchUrl(Uri.parse(url))) {
            throw 'Could not launch $url';
          }
        }),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title, onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorTheme.appBarColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: onTap,
    );
  }
}
