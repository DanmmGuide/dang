import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import '../../network/api_config.dart';

class MyPage extends StatefulWidget {

  final int userId;
  final ValueChanged<bool>? onEditingChanged;
  const MyPage({super.key, required this.userId, this.onEditingChanged});

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

  // 백업용 변수
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
    _guardianController = TextEditingController();
    _petNameController = TextEditingController();
    _speciesController = TextEditingController();
    _birthController = TextEditingController();
    _genderController = TextEditingController();
    _neuteredController = TextEditingController();
    _weightController = TextEditingController();

    _loadMypage();
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

  // 생년월일 선택기
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text('취소', style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                    const Text('생년월일', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _birthController.text =
                          "${tempPickedDate.year}.${tempPickedDate.month.toString().padLeft(2, '0')}.${tempPickedDate.day.toString().padLeft(2, '0')}.";
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('완료', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
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
    if (!_isEditing) return;

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
                      child: const Text('취소', style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                    const Text('성별', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        setState(() => _genderController.text = tempSelected);
                        Navigator.of(context).pop();
                      },
                      child: const Text('완료', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
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
                  children: genderOptions.map((e) => Center(child: Text(e))).toList(),
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
    if (!_isEditing) return;

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
                      child: const Text('취소', style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                    const Text('중성화 여부', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        setState(() => _neuteredController.text = tempSelected);
                        Navigator.of(context).pop();
                      },
                      child: const Text('완료', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
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
                  children: neuteredOptions.map((e) => Center(child: Text(e))).toList(),
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
        _saveProfile();
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
                // 1. 반려동물 이름
                _buildInfoBox('반려동물 이름', _petNameController),

                // 2. 생년월일
                _buildInfoBox(
                  '생년월일',
                  _birthController,
                  onTap: _selectDate,
                  icon: Icons.calendar_today_outlined,
                ),

                // 3. 종 | 성별
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox(
                        '종',
                        _speciesController,
                        isHalf: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoBox(
                        '성별',
                        _genderController,
                        isHalf: true,
                        onTap: _selectGender,
                        icon: Icons.keyboard_arrow_down,
                      ),
                    ),
                  ],
                ),

                // 4. 중성화 | 몸무게
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox(
                        '중성화',
                        _neuteredController,
                        isHalf: true,
                        onTap: _selectNeutered,
                        icon: Icons.keyboard_arrow_down,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoBox(
                        '몸무게',
                        _weightController,
                        isHalf: true,
                        keyboardType: TextInputType.number,
                      ),
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

  Widget _buildInfoBox(
      String label,
      TextEditingController controller, {
        bool isHalf = false,
        VoidCallback? onTap,
        IconData? icon,
        TextInputType keyboardType = TextInputType.text,
      }) {

    bool isWeight = label == "몸무게";

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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 10),

            Expanded(
              child: _isEditing
                  ? TextField(
                controller: controller,
                keyboardType: isWeight ? TextInputType.number : keyboardType,
                onChanged: (value) {
                  if (isWeight) {
                    // 숫자 + 소수점만 허용
                    String numeric = value.replaceAll(RegExp(r'[^0-9.]'), '');

                    controller.text = numeric;

                    // 커서 끝으로 유지
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  }
                },

                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 16),
              )
                  : Text(
                isWeight
                    ? "${controller.text} kg"
                    : controller.text,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (icon != null && _isEditing) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onTap,
                child: Icon(icon, color: Colors.grey.shade400, size: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }
  Future<void> _saveProfile() async {
    try {
      final dio = Dio(
        BaseOptions(baseUrl: ApiConfig.baseUrl),
      );

      final data = {
        "guardian_name": _guardianController.text,
        "pet_name": _petNameController.text,
        "species": _speciesController.text,
        "birth": _birthController.text,
        "gender": _genderController.text,
        "neutered": _neuteredController.text,
        "weight": _weightController.text,
      };

      await dio.put(
        "/my_page/${widget.userId}",
        data: data,
      );
    } catch (e) {
      print("프로필 저장 오류: $e");
    }
  }

  Future<void> _loadMypage() async {
    try {
      final dio = Dio(
        BaseOptions(baseUrl: ApiConfig.baseUrl),
      );

      final res = await dio.get(
        "/my_page/${widget.userId}",
      );

      final data = res.data;

      if (data != null) {
        setState(() {
          _guardianController.text = data["guardian_name"] ?? '';
          _petNameController.text = data["pet_name"] ?? '';
          _speciesController.text = data["species"] ?? '';
          _birthController.text = data["birth"] ?? '';
          _genderController.text = data["gender"] ?? '';
          _neuteredController.text = data["neutered"] ?? '';
          _weightController.text = data["weight"] ?? '';
        });
      }
    } catch (e) {
      print("마이페이지 불러오기 오류: $e");
    }
  }


}
