import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_frame.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // 임시저장 키 값
  static const String _prefTitleKey = 'draft_inquiry_title';
  static const String _prefContentKey = 'draft_inquiry_content';

  @override
  void initState() {
    super.initState();
    _loadDraft(); // 페이지 열릴 때 임시저장 불러오기
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // [기능 1] 임시저장 불러오기
  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _titleController.text = prefs.getString(_prefTitleKey) ?? '';
      _contentController.text = prefs.getString(_prefContentKey) ?? '';
    });

    if (_titleController.text.isNotEmpty || _contentController.text.isNotEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('작성 중인 내용을 불러왔습니다.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  // [기능 2] 임시저장 하기
  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefTitleKey, _titleController.text);
    await prefs.setString(_prefContentKey, _contentController.text);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('임시저장 되었습니다.')),
    );
  }

  // [기능 3] 전송 완료 후 임시저장 삭제
  Future<void> _deleteDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefTitleKey);
    await prefs.remove(_prefContentKey);
  }

  @override
  Widget build(BuildContext context) {
    return CommonFrame(
      title: '서비스 문의',
      showBackButton: true,
      currentIndex: 4, // 마이페이지 탭 유지
      onTapNav: (_) {},
      body: _buildBody(), // 파라미터 전달 방식 제거 (원래대로)
    );
  }

  Widget _buildBody() {
    // 색상 정의를 내부로 복구
    const Color backgroundColor = Color(0xFFF0E8DD);
    const Color fieldFillColor = Colors.white;
    const Color accentColor = Color(0xFFED6D11);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor, // 전체 배경색 적용
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 제목 입력 ---
            const Text(
              '제목',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '제목을 입력하세요.',
                filled: true,
                fillColor: fieldFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: accentColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),

            // --- 내용 입력 ---
            const Text(
              '내용',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: '궁금한 점이나 불편한 점을 남겨주세요.',
                  filled: true,
                  fillColor: fieldFillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- 버튼 영역 (임시저장 + 문의하기) ---
            Row(
              children: [
                // 1. 임시저장 버튼
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: accentColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveDraft,
                      child: Text(
                        '임시저장',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. 문의하기 버튼
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        // 전송 성공 시 임시저장 삭제
                        await _deleteDraft();

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('문의가 접수되었습니다.')),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '문의하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}