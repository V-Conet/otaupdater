import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // top 返回 和 三点 更多
                    Row(
                      children: [
                        //back icon
                        BackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: Text(
                            "System Update",
                            style: GoogleFonts.dmSans(fontSize: 24),
                          ),
                        ),
                        PopupMenuButton<int>(
                          borderRadius: BorderRadius.circular(8),
                          onSelected: (int result) {
                            if (result == 0) {
                              Navigator.pushNamed(context, '/settings');
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text('设置'),
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text('选项二'),
                                ),
                                const PopupMenuItem<int>(
                                  value: 2,
                                  child: Text('选项三'),
                                ),
                              ],
                        ),
                      ],
                    ),

                    // 中间大框, backgound img 和标题
                    Container(
                      margin: const EdgeInsets.all(20),
                      height: 400,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      // padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Stack(
                        // background image and title are warpped, have space on left and right
                        // to keep the longest line was verticail to topbar
                        children: [
                          // 背景图
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'lib/images/thumb.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // 标题
                          Positioned(
                            left: 16,
                            bottom: 16,
                            child: Text(
                              'ColorOS 16.0.5',
                              style: GoogleFonts.dmSans(
                                fontSize: 30,
                                color: Colors.yellow[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 版本文本
                    Container(
                      // width: double.infinity,
                      padding: const EdgeInsets.only(left: 32, right: 32, top:16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Release Notes',
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '1. Improved system stability and performance.\n'
                            '2. Fixed some known bugs and issues.\n'
                            '3. Updated security patches to enhance device security.\n'
                            '4. Added new features and optimizations for a better user experience.\n'
                            '5. Improved battery life and power management.\n'
                            '6. Enhanced compatibility with third-party apps and services.\n'
                            '7. Updated user interface for a more modern and intuitive design.\n'
                            '8. Improved camera performance and added new shooting modes.\n'
                            '9. Enhanced privacy features and controls for better user data protection.\n',
                          ),
                        ],
                      ),
                    ),

                    // 小字注释
                    Text(
                      "For more details about this Rom port, go XXXX",
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),

            // 底部按钮
            // fix button to bottom
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  print('点击了更新按钮');
                },
                style: ElevatedButton.styleFrom(
                  // use system MD3 `dynamic` color: the one used in buttons
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(50), // 设置按钮高度
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 设置圆角
                  ),
                ),
                child: const Text(
                  'Check for Update',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
