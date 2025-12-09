import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

import '../../main.dart';
import '../../network/api_config.dart';
import '../../common_frame.dart';

class InfoInputPage extends StatefulWidget {
  final int userId;

  const InfoInputPage({
    super.key,
    required this.userId,
  });

  @override
  State<InfoInputPage> createState() => _InfoInputPageState();
}

class _InfoInputPageState extends State<InfoInputPage> {
  // ------------------ 입력 필드 (초기값 제거됨) ------------------
  final TextEditingController _guardianController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _neuteredController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _guardianController.dispose();
    _petNameController.dispose();
    _speciesController.dispose();
    _birthController.dispose();
    _genderController.dispose();
    _neuteredController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // ------------------ 날짜 선택기 ------------------
  void _selectDate() {
    DateTime initialDate = DateTime.now();

    try {
      String clean = _birthController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.length >= 8) {
        initialDate = DateTime.parse(
          "${clean.substring(0, 4)}-${clean.substring(4, 6)}-${clean.substring(6, 8)}",
        );
      }
    } catch (_) {}

    DateTime tempDate = initialDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              _buildPickerHeader(
                title: '생년월일',
                onConfirm: () {
                  setState(() {
                    _birthController.text =
                    "${tempDate.year}.${tempDate.month.toString().padLeft(2, '0')}.${tempDate.day.toString().padLeft(2, '0')}.";
                  });
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (newDate) => tempDate = newDate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------ 성별 선택기 ------------------
  void _selectGender() {
    final options = ['수컷', '암컷'];
    int index = options.indexOf(_genderController.text);
    if (index == -1) index = 0;
    String temp = options[index];

    _showPicker(
      title: '성별',
      options: options,
      initialIndex: index,
      onConfirmed: () => setState(() => _genderController.text = temp),
      onChanged: (i) => temp = options[i],
    );
  }

  // ------------------ 중성화 여부 선택기 ------------------
  void _selectNeutered() {
    final options = ['O', 'X'];
    int index = options.indexOf(_neuteredController.text);
    if (index == -1) index = 0;
    String temp = options[index];

    _showPicker(
      title: '중성화 여부',
      options: options,
      initialIndex: index,
      onConfirmed: () => setState(() => _neuteredController.text = temp),
      onChanged: (i) => temp = options[i],
    );
  }

  // ------------------ Picker 공통 UI ------------------
  void _showPicker({
    required String title,
    required List<String> options,
    required int initialIndex,
    required VoidCallback onConfirmed,
    required ValueChanged<int> onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              _buildPickerHeader(title: title, onConfirm: onConfirmed),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: initialIndex),
                  itemExtent: 32,
                  onSelectedItemChanged: onChanged,
                  children: options.map((e) => Center(child: Text(e))).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerHeader({
    required String title,
    required VoidCallback onConfirm,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: onConfirm,
            child: const Text(
              '완료',
              style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ 프로필 서버 저장 ------------------
  Future<void> _saveProfile() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

      final data = {
        "guardian_name": _guardianController.text,
        "pet_name": _petNameController.text,
        "species": _speciesController.text,
        "birth": _birthController.text,
        "gender": _genderController.text,
        "neutered": _neuteredController.text,
        "weight": _weightController.text,
      };

      await dio.put("/my_page/${widget.userId}", data: data);

      print("프로필 저장 성공");
    } catch (e) {
      print("프로필 저장 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF0E8DD),

        appBar: AppBar(
          backgroundColor: const Color(0xFFF0E8DD),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            "정보 입력",
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

            body: Container(
              color: const Color(0xFFF0E8DD),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '[사용자 정보]',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            _buildInputBox("보호자 이름", _guardianController),
            const SizedBox(height: 40),

            // ------------------ 반려동물 정보 ------------------
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '[반려동물 정보]',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            _buildInputBox("반려동물 이름", _petNameController),
            const SizedBox(height: 12),

            _buildInputBox("종", _speciesController),
            const SizedBox(height: 12),

            _buildInputBox(
              "생년월일",
              _birthController,
              onTap: _selectDate,
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInputBox(
                    "성별",
                    _genderController,
                    onTap: _selectGender,
                    icon: Icons.keyboard_arrow_down,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputBox(
                    "중성화",
                    _neuteredController,
                    onTap: _selectNeutered,
                    icon: Icons.keyboard_arrow_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildInputBox("몸무게", _weightController),
            const SizedBox(height: 50),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFED6D11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () async {
                          // 👉 여기서 먼저 입력값 체크
                          final guardian = _guardianController.text.trim();
                          final petName = _petNameController.text.trim();
                          final species = _speciesController.text.trim();
                          final birth = _birthController.text.trim();
                          final gender = _genderController.text.trim();
                          final neutered = _neuteredController.text.trim();
                          final weight = _weightController.text.trim();

                          // 전부 필수로 체크 (원하면 여기서 일부만 골라서 필수로 바꿔도 됨)
                          final fields = [guardian, petName, species, birth, gender, neutered, weight];

                          if (fields.any((v) => v.isEmpty)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('모든 항목을 입력해 주세요.'),
                              ),
                            );
                            return; // 👉 저장 및 페이지 이동 막기
                          }

                          // 🔥 여기까지 통과하면 서버 저장
                          await _saveProfile();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RootScreen(userId: widget.userId),
                            ),
                                (route) => false,
                          );
                        },
                        child: const Text(
                          '확인',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),

                  ],
        ),
      ),
      )
    );
  }

  // ------------------ 입력 박스 공통 컴포넌트 ------------------
  Widget _buildInputBox(
      String label,
      TextEditingController controller, {
        VoidCallback? onTap,
        IconData? icon,
      }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EDE8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(width: 15),
          const Text('|', style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 15),

          Expanded(
            child: TextField(
              controller: controller,
              readOnly: onTap != null,
              onTap: onTap,
              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
            ),
          ),

          if (icon != null)
            GestureDetector(
              onTap: onTap,
              child: Icon(icon, color: Colors.grey.shade400, size: 20),
            ),
        ],
      ),
    );
  }
}
