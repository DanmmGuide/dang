import 'package:flutter/material.dart';

class StartPage extends StatelessWidget
{
  const StartPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 402,
            height: 874,
            child: _StartPageContent(),
          ),
        ),
      ),
    );
  }
}

class _StartPageContent extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: 402,
      height: 874,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 844),
            child: Container(
              width: double.infinity,
              height: 874,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: const Color(0xFFFCF9F7)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    height: 844,
                    child: Column(
                      children: [
                        Container(
                          width: 402,
                          height: 598,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(minHeight: 320),
                                      child: Container(
                                        width: double.infinity,
                                        height: 598,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          // 이미지 넣을 곳
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 121,
                                              top: 506,
                                              child: SizedBox(
                                                width: 160,
                                                height: 23,
                                                child: Text(
                                                  '댕가이드\n',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black.withOpacity(0.28),
                                                    fontSize: 16,
                                                    fontFamily: 'NanumGothic',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.50,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 87,
                                              top: 550,
                                              child: SizedBox(
                                                width: 227,
                                                height: 48,
                                                child: Text(
                                                  '여러분들의 소중한 아이들\n똑똑하게 배워요 ',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontFamily: 'NanumGothic',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.33,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // 🔥🔥🔥 로그인 + 회원가입 버튼 전체 Row (여기만 수정됨)
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 480),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                // 🔶 로그인 버튼 → RootScreen 이동
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, '/root');
                                  },
                                  child: Container(
                                    width: 175,
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 12),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFED6D11),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: Colors.black.withOpacity(0.20),
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '로그인',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: const Color(0xFFFCF9F7),
                                          fontSize: 16,
                                          fontFamily: 'Be Vietnam Pro',
                                          fontWeight: FontWeight.w700,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 20),

                                // 🔹 회원가입 버튼 (아직 동작 없음)
                                Container(
                                  width: 175,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF2EDE8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '회원가입',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF1C110C),
                                        fontSize: 16,
                                        fontFamily: 'Be Vietnam Pro',
                                        fontWeight: FontWeight.w700,
                                        height: 1.50,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        // 🔥🔥🔥 버튼 부분 끝
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
