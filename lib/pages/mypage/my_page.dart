import 'dart:io';
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

  // 컨트롤러들
  late TextEditingController _guardianController;
  late TextEditingController _petNameController;
  late TextEditingController _speciesController;
  late TextEditingController _birthController;
  late TextEditingController _genderController;
  late TextEditingController _neuteredController;
  late TextEditingController _weightController;

  // 👇 [추가됨 1] 데이터 복구를 위한 임시 저장 변수들
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

  // 👇 [추가됨 2] 수정 시작할 때 현재 상태 백업
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

  // 👇 [추가됨 3] 취소했을 때 백업한 데이터로 복구
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

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // [완료 버튼 누름] -> 저장 로직 수행 (여기서는 그냥 콘솔 출력)
        print("저장됨: ${_petNameController.text}");
      } else {
        // [수정 버튼 누름] -> 백업 실행!
        _backupData(); // 👈 여기서 백업
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
              onPressed: () {
                Navigator.of(context).pop(false); // 계속 작성
              },
              child: const Text('계속 작성'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 나가기(취소) 확정
              },
              child: const Text('작성 취소', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldLeave == true) {
      // 👇 [수정됨] 여기서 데이터 복구 실행!
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
                _buildInfoBox('생년월일', _birthController),
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

  Widget _buildInfoBox(String label, TextEditingController controller,
      {bool isHalf = false}) {
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
          ],
        ),
      ),
    );
  }
}