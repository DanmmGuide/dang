// lib/pages/mypage.dart

import 'dart:io'; // 👈 파일 처리를 위해 필요
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 👈 패키지 임포트

class MyPage extends StatefulWidget {
  final ValueChanged<bool>? onEditingChanged;
  const MyPage({super.key, this.onEditingChanged});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  // 1. 수정 모드 상태 변수 (false: 보기 모드, true: 수정 모드)
  bool _isEditing = false;

  // 2. 이미지 관련 변수
  File? _pickedImage; // 갤러리에서 가져온 이미지 파일

  // 3. 텍스트 필드 컨트롤러 (입력값을 관리하기 위함)
  late TextEditingController _guardianController;
  late TextEditingController _petNameController;
  late TextEditingController _speciesController;
  late TextEditingController _birthController;
  late TextEditingController _genderController;
  late TextEditingController _neuteredController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    // 초기 데이터 설정
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
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _guardianController.dispose();
    _petNameController.dispose();
    _speciesController.dispose();
    _birthController.dispose();
    _genderController.dispose();
    _neuteredController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // 📷 사진 가져오기 로직 (image_picker 사용)
  Future<void> _pickImage() async {
    // 수정 모드가 아닐 때는 사진 변경 불가
    if (!_isEditing) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path); // 선택한 파일 경로를 File 객체로 변환
      });
    }
  }

  // ✏️ 수정/저장 버튼 클릭 시 로직
  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // 완료(저장) 눌렀을 때 처리
        print("저장됨: ${_petNameController.text}");
      }
      _isEditing = !_isEditing;
    });

    // 상위(RootScreen)에게 현재 수정 상태 알려주기
    widget.onEditingChanged?.call(_isEditing);
  }

  // 🔙 뒤로가기(시스템/앱바) 막기 + 경고창
  Future<bool> _onWillPop() async {
    if (!_isEditing) return true; // 수정 중 아니면 그냥 나가기 허용

    final bool? shouldLeave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('작성 내용이 저장되지 않았어요'),
          content: const Text('계속 작성하시겠습니까, 아니면 작성 취소 후 나가시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 계속 작성
              },
              child: const Text('계속 작성'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
                // 상위에도 수정 종료 알리기 → 네비바 다시 표시용
                widget.onEditingChanged?.call(false);
                Navigator.of(context).pop(true); // 나가기 허용
              },
              child: const Text(
                '작성 취소',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF0E8DD);
    final Color activeColor = const Color(0xFFED6D11);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: backgroundColor,
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 상단 수정/완료 버튼
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

              // 💡 사진 영역
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
                          ? const Icon(Icons.pets,
                          size: 50, color: Colors.grey)
                          : null,
                    ),

                    // 수정 모드일 때만 카메라 아이콘
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

              // 이름
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

              // [사용자 정보]
              _buildInfoGroup(title: '[사용자 정보]', children: [
                _buildInfoBox('보호자 이름', _guardianController),
              ]),
              const SizedBox(height: 20),

              // [반려동물 정보]
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

  // 이미지 공급자 결정 함수 (파일 vs 에셋)
  DecorationImage? _getImageProvider() {
    if (_pickedImage != null) {
      return DecorationImage(
        image: FileImage(_pickedImage!), // 갤러리에서 선택한 사진
        fit: BoxFit.cover,
      );
    }
    // 기본 이미지가 있다면 아래 주석 해제하여 사용
    // return const DecorationImage(
    //   image: AssetImage('assets/cat_mypage.png'),
    //   fit: BoxFit.cover,
    // );
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

  // 📝 정보 박스 위젯 (TextEditingController를 받도록 수정됨)
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
            // 수정 모드일 때 테두리 색 변경으로 시각적 힌트 제공
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
                  border: InputBorder.none, // 밑줄 제거
                  isDense: true, // 여백 줄임
                  contentPadding: EdgeInsets.zero,
                ),
              )
                  : Text(
                controller.text,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis, // 글자 넘침 방지
              ),
            ),
          ],
        ),
      ),
    );
  }
}