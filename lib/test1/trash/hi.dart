import 'package:flutter/material.dart';

class HomeFrame extends StatelessWidget {
  const HomeFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 844),
            child: Container(
              width: 402,
              height: 874,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xFFF0E8DD),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 상단 바
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 왼쪽 아이콘 영역
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: const SizedBox.shrink(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 142),
                        // 타이틀
                        const Text(
                          '홈',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.w500,
                            height: 1.50,
                          ),
                        ),
                        const SizedBox(width: 142),
                        // 오른쪽 버튼 영역
                        SizedBox(
                          width: 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints:
                                const BoxConstraints(maxWidth: 480),
                                child: Container(
                                  height: 48,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                clipBehavior: Clip.antiAlias,
                                                decoration:
                                                const BoxDecoration(),
                                                child: const SizedBox.shrink(),
                                              ),
                                            ),
                                          ],
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

                  // 본문 영역
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 1),
                    child: Container(
                      width: 402,
                      height: 728,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 75,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      // 여기에 실제 페이지 내용 채우면 됨
                    ),
                  ),

                  // 하단 네비게이션 바
                  Container(
                    width: double.infinity,
                    height: 75,
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 16,
                      right: 16,
                      bottom: 12,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFF4F2EF),
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 홈
                        Expanded(
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 32,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 24,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(),
                                          child: const SizedBox.shrink(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '홈',
                                  style: TextStyle(
                                    color: Color(0xFF161411),
                                    fontSize: 12,
                                    fontFamily: 'Epilogue',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 게시판
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: const SizedBox.shrink(),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const SizedBox(
                                  width: 34,
                                  child: Text(
                                    '게시판',
                                    style: TextStyle(
                                      color: Color(0xFF897260),
                                      fontSize: 12,
                                      fontFamily: 'Epilogue',
                                      fontWeight: FontWeight.w500,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 가이드
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 32,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 24,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(),
                                        child: const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '가이드',
                                  style: TextStyle(
                                    color: Color(0xFF897260),
                                    fontSize: 12,
                                    fontFamily: 'Epilogue',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 콘텐츠
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 32,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 24,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(),
                                        child: const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: 34,
                                  child: Text(
                                    '콘텐츠',
                                    style: TextStyle(
                                      color: Color(0xFF897260),
                                      fontSize: 12,
                                      fontFamily: 'Epilogue',
                                      fontWeight: FontWeight.w500,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 마이페이지
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: SizedBox.shrink(),
                                  ),
                                  const SizedBox(height: 4),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 56,
                                      child: Text(
                                        '마이페이지',
                                        style: TextStyle(
                                          color: Color(0xFF897260),
                                          fontSize: 12,
                                          fontFamily: 'Epilogue',
                                          fontWeight: FontWeight.w500,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
