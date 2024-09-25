import 'package:cash_monkey/utils/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:cash_monkey/utils/utils.dart';

class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({super.key});

  Future<List<Map<String, String>>> fetchSocialMediaLinks() async {
    final dio = Dio();
    try {
      Map<String, String> allInfo = await Utils.collectAllInfo();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? securityToken = prefs.getString('token');
      String versionName = allInfo['versionName'] ?? "";
      String versionCode = allInfo['versionCode'] ?? "";

      final response = await dio.post(
        "${allInfo["baseUrl"]}socialLinks",
        data: {
          "userId": userId,
          "securityToken": securityToken,
          "versionName": versionName,
          "versionCode": versionCode,
        },
      );

      if (response.statusCode == 201 && response.data["status"] == 200) {
        List<dynamic> data = response.data["socialLinks"];
        print(data);
        return data.map((item) {
          return {
            'name': item['title']?.toString() ?? 'No Name',
            'url': item['url']?.toString() ?? '',
          };
        }).toList();
      } else {
        throw Exception(
            'Failed to load social media links: ${response.data["message"]}');
      }
    } catch (e) {
      throw Exception('Failed to load social media links: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundColor,
      appBar: AppBar(
        title:
            const Text('Social Links', style: TextStyle(color: Colors.white)),
        backgroundColor: ColorTheme.appBarColor,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchSocialMediaLinks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No social media links available.',
                    style: TextStyle(color: Colors.white)));
          }

          final links = snapshot.data!;

          return ListView.builder(
            itemCount: links.length,
            itemBuilder: (context, index) {
              final link = links[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Card(
                  color: ColorTheme.appBarColor, // Background color of the tile
                  child: ListTile(
                    leading: Icon(Icons.link, color: Colors.teal),
                    title: Text(
                      link['name'] ?? 'No Name',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      final url = link['url'];
                      if (url!.isNotEmpty && await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
