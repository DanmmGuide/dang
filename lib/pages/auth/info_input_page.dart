import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../main.dart';

class InfoInputPage extends StatefulWidget {
  const InfoInputPage({super.key});

  @override
  State<InfoInputPage> createState() => _InfoInputPageState();
}

class _InfoInputPageState extends State<InfoInputPage> {
  final TextEditingController _idController = TextEditingController(text: '혀누');
  final TextEditingController _petNameController = TextEditingController(text: '코코');
  final TextEditingController _speciesController = TextEditingController(text: '랙돌');
  final TextEditingController _birthController = TextEditingController(text: '2024.02.15.');
  final TextEditingController _genderController = TextEditingController(text: '수컷');
  final TextEditingController _neuteredController = TextEditingController(text: 'O');
  final TextEditingController _weightController = TextEditingController(text: '7.5 kg');
  final TextEditingController _etcController = TextEditingController(text: '-');

  @override
  void dispose() {
    _idController.dispose();
    _petNameController.dispose();
    _speciesController.dispose();
    _birthController.dispose();
    _genderController.dispose();
    _neuteredController.dispose();
    _weightController.dispose();
    _etcController.dispose();
    super.dispose();
  }

  // 생년월일 선택기
  void _selectDate() {
    DateTime initialDate = DateTime.now();
    try {
      String cleanText = _birthController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanText.length >= 8) {
        initialDate = DateTime.parse(
            "${cleanText.substring(0, 4)}-${cleanText.substring(4, 6)}-${cleanText.substring(6, 8)}");
      }
    } catch (e) {}

    DateTime tempPickedDate = initialDate;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text('취소', style: TextStyle(fontFamily: 'Epilogue', color: Colors.blue, fontSize: 16)), // 👈 Epilogue
                    ),
                    const Text('생년월일', style: TextStyle(fontFamily: 'Epilogue', fontSize: 16, fontWeight: FontWeight.bold)), // 👈 Epilogue
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _birthController.text =
                          "${tempPickedDate.year}.${tempPickedDate.month.toString().padLeft(2, '0')}.${tempPickedDate.day.toString().padLeft(2, '0')}.";
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('완료', style: TextStyle(fontFamily: 'Epilogue', color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)), // 👈 Epilogue
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    tempPickedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 성별 선택기
  void _selectGender() {
    final List<String> genderOptions = ['수컷', '암컷'];
    int initialIndex = genderOptions.indexOf(_genderController.text);
    if (initialIndex == -1) initialIndex = 0;
    String tempSelected = genderOptions[initialIndex];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text('취소', style: TextStyle(fontFamily: 'Epilogue', color: Colors.blue, fontSize: 16)), // 👈 Epilogue
                    ),
                    const Text('성별', style: TextStyle(fontFamily: 'Epilogue', fontSize: 16, fontWeight: FontWeight.bold)), // 👈 Epilogue
                    GestureDetector(
                      onTap: () {
                        setState(() => _genderController.text = tempSelected);
                        Navigator.of(context).pop();
                      },
                      child: const Text('완료', style: TextStyle(fontFamily: 'Epilogue', color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)), // 👈 Epilogue
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: initialIndex),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    tempSelected = genderOptions[index];
                  },
                  children: genderOptions.map((e) => Center(child: Text(e, style: const TextStyle(fontFamily: 'Epilogue')))).toList(), // 👈 Epilogue
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 중성화 선택기
  void _selectNeutered() {
    final List<String> neuteredOptions = ['O', 'X'];
    int initialIndex = neuteredOptions.indexOf(_neuteredController.text);
    if (initialIndex == -1) initialIndex = 0;
    String tempSelected = neuteredOptions[initialIndex];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text('취소', style: TextStyle(fontFamily: 'Epilogue', color: Colors.blue, fontSize: 16)), // 👈 Epilogue
                    ),
                    const Text('중성화 여부', style: TextStyle(fontFamily: 'Epilogue', fontSize: 16, fontWeight: FontWeight.bold)), // 👈 Epilogue
                    GestureDetector(
                      onTap: () {
                        setState(() => _neuteredController.text = tempSelected);
                        Navigator.of(context).pop();
                      },
                      child: const Text('완료', style: TextStyle(fontFamily: 'Epilogue', color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)), // 👈 Epilogue
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: initialIndex),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    tempSelected = neuteredOptions[index];
                  },
                  children: neuteredOptions.map((e) => Center(child: Text(e, style: const TextStyle(fontFamily: 'Epilogue')))).toList(), // 👈 Epilogue
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF0E8DD);
    const Color buttonColor = Color(0xFFED6D11);
    const Color textColor = Color(0xFF1C110C);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '정보 입력',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Epilogue',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '[사용자 정보]',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Epilogue',
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildInputBox('아이디', _idController),

            const SizedBox(height: 40),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '[반려동물 정보]',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Epilogue',
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildInputBox('반려동물 이름', _petNameController),
            const SizedBox(height: 12),
            _buildInputBox('종', _speciesController),
            const SizedBox(height: 12),

            _buildInputBox(
              '생년월일',
              _birthController,
              onTap: _selectDate,
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInputBox(
                    '성별',
                    _genderController,
                    onTap: _selectGender,
                    icon: Icons.keyboard_arrow_down,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputBox(
                    '중성화',
                    _neuteredController,
                    onTap: _selectNeutered,
                    icon: Icons.keyboard_arrow_down,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _buildInputBox('몸무게', _weightController)),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RootScreen(),
                    ),
                        (route) => false,
                  );
                },
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Epilogue',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBox(String label, TextEditingController controller,
      {VoidCallback? onTap, IconData? icon}) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EDE8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Epilogue',
            ),
          ),
          const SizedBox(width: 15),
          const Text(
            '|',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontFamily: 'Epilogue',
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: onTap != null,
              onTap: onTap,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontFamily: 'Epilogue',
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onTap,
              child: Icon(icon, color: Colors.grey.shade400, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}