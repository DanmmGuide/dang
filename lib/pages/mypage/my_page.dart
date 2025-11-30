import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyPage extends StatefulWidget {
  final ValueChanged<bool>? onEditingChanged;
  const MyPage({super.key, this.onEditingChanged});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _isEditing = false;
  File? _pickedImage;

  late TextEditingController _guardianController;
  late TextEditingController _petNameController;
  late TextEditingController _speciesController;
  late TextEditingController _birthController;
  late TextEditingController _genderController;
  late TextEditingController _neuteredController;
  late TextEditingController _weightController;

  File? _tempPickedImage;
  String _tempGuardian = '';
  String _tempPetName = '';
  String _tempSpecies = '';
  String _tempBirth = '';
  String _tempGender = '';
  String _tempNeutered = '';
  String _tempWeight = '';

  @override
  void initState() {
    super.initState();
    _guardianController = TextEditingController(text: '혀누');
    _petNameController = TextEditingController(text: '코코');
    _speciesController = TextEditingController(text: '랙돌');
    _birthController = TextEditingController(text: '2024.02.15.');
    _genderController = TextEditingController(text: '남');
    _neuteredController = TextEditingController(text: 'O');
    _weightController = TextEditingController(text: '7.5 kg');
  }

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

  void _backupData() {
    _tempPickedImage = _pickedImage;
    _tempGuardian = _guardianController.text;
    _tempPetName = _petNameController.text;
    _tempSpecies = _speciesController.text;
    _tempBirth = _birthController.text;
    _tempGender = _genderController.text;
    _tempNeutered = _neuteredController.text;
    _tempWeight = _weightController.text;
  }

  void _restoreData() {
    setState(() {
      _pickedImage = _tempPickedImage;
      _guardianController.text = _tempGuardian;
      _petNameController.text = _tempPetName;
      _speciesController.text = _tempSpecies;
      _birthController.text = _tempBirth;
      _genderController.text = _tempGender;
      _neuteredController.text = _tempNeutered;
      _weightController.text = _tempWeight;
    });
  }

  Future<void> _pickImage() async {
    if (!_isEditing) return;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  // 아이폰 스타일 날짜 선택기
  void _selectDate() {
    if (!_isEditing) return;

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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _birthController.text =
                          "${tempPickedDate.year}.${tempPickedDate.month.toString().padLeft(2, '0')}.${tempPickedDate.day.toString().padLeft(2, '0')}.";
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Confirm', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        print("저장됨: ${_petNameController.text}");
      } else {
        _backupData();
      }
      _isEditing = !_isEditing;
    });

    widget.onEditingChanged?.call(_isEditing);
  }

  Future<void> _handleBackPress() async {
    final bool? shouldLeave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('작성 내용이 저장되지 않았어요'),
          content: const Text('작성을 취소하고 나가시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('계속 작성'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('작성 취소', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldLeave == true) {
      _restoreData();
      setState(() {
        _isEditing = false;
      });
      widget.onEditingChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF0E8DD);
    final Color activeColor = const Color(0xFFED6D11);

    return PopScope(
      canPop: !_isEditing,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Container(
        color: backgroundColor,
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _toggleEditMode,
                  icon: Icon(
                    _isEditing ? Icons.check : Icons.edit,
                    color: activeColor,
                    size: 20,
                  ),
                  label: Text(
                    _isEditing ? '완료' : '수정',
                    style: TextStyle(
                      color: activeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                        color: Colors.white,
                        image: _getImageProvider(),
                      ),
                      child: (_pickedImage == null)
                          ? const Icon(Icons.pets, size: 50, color: Colors.grey)
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: activeColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 20, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _isEditing
                  ? SizedBox(
                width: 150,
                child: TextField(
                  controller: _petNameController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              )
                  : Text(
                '<${_petNameController.text}>',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildInfoGroup(title: '[사용자 정보]', children: [
                _buildInfoBox('보호자 이름', _guardianController),
              ]),
              const SizedBox(height: 20),
              _buildInfoGroup(title: '[반려동물 정보]', children: [
                _buildInfoBox('반려동물 이름', _petNameController),
                _buildInfoBox('종', _speciesController),

                // 달력 아이콘 연결
                _buildInfoBox(
                  '생년월일',
                  _birthController,
                  onTap: _selectDate,
                  icon: Icons.calendar_today_outlined,
                ),

                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox('성별', _genderController, isHalf: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoBox('중성화', _neuteredController,
                          isHalf: true),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox('몸무게', _weightController, isHalf: true),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: SizedBox(height: 55),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  DecorationImage? _getImageProvider() {
    if (_pickedImage != null) {
      return DecorationImage(
        image: FileImage(_pickedImage!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  Widget _buildInfoGroup(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
          child: Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...children,
      ],
    );
  }

  // 🔥 [수정] 아이콘 클릭 기능 추가
  Widget _buildInfoBox(String label, TextEditingController controller,
      {bool isHalf = false, VoidCallback? onTap, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _isEditing ? const Color(0xFFED6D11) : Colors.grey.shade300,
            width: _isEditing ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text('$label |',
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: _isEditing
                  ? TextField(
                controller: controller,
                readOnly: onTap != null,
                onTap: onTap,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              )
                  : Text(
                controller.text,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              // 🔥 아이콘을 GestureDetector로 감싸서 클릭 가능하게 변경
              GestureDetector(
                onTap: onTap, // 텍스트 필드와 같은 동작 실행
                child: Icon(icon, color: Colors.grey.shade400, size: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }
}