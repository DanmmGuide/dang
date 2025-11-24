import 'package:flutter/material.dart';
import 'breed_item.dart';
import 'breed_detail_page.dart';
import '../../models/dog_breed.dart';

class BreedSelectPage extends StatefulWidget {
  const BreedSelectPage({super.key});

  @override
  State<BreedSelectPage> createState() => _BreedSelectPageState();
}

class _BreedSelectPageState extends State<BreedSelectPage> {
  final TextEditingController _searchController = TextEditingController();

  // 전체 품종 리스트 (샘플)
  // TODO: 나중에 TheDogAPI + DB에서 불러오도록 교체
  final List<BreedItem> _allBreeds = const [
    BreedItem(
      breed: DogBreed(
        id: 1,
        name: '포메라니안',
        weightMetric: '2 - 3',
        lifeSpan: '12 - 16 years',
        temperament: 'Playful, Friendly',
        // TheDogAPI 실제 이미지 URL을 나중에 채워넣으 됨
        imageUrl: null,
      ),
      isBeginnerFriendly: true,
      isApartmentFriendly: true,
      activityLevel: '보통',
    ),
    BreedItem(
      breed: DogBreed(
        id: 2,
        name: '토이 푸들',
        weightMetric: '3 - 4',
        lifeSpan: '12 - 15 years',
        temperament: 'Intelligent, Active',
        imageUrl: null,
      ),
      isBeginnerFriendly: true,
      isApartmentFriendly: true,
      activityLevel: '높음',
    ),
    BreedItem(
      breed: DogBreed(
        id: 3,
        name: '시츄',
        weightMetric: '4 - 7',
        lifeSpan: '10 - 16 years',
        temperament: 'Affectionate, Playful',
        imageUrl: null,
      ),
      isBeginnerFriendly: true,
      isApartmentFriendly: true,
      activityLevel: '낮음',
    ),
    BreedItem(
      breed: DogBreed(
        id: 4,
        name: '비숑',
        weightMetric: '5 - 8',
        lifeSpan: '12 - 15 years',
        temperament: 'Cheerful, Playful',
        imageUrl: null,
      ),
      isBeginnerFriendly: false,
      isApartmentFriendly: true,
      activityLevel: '높음',
    ),
  ];

  String _selectedFilter = '전체';
  String _searchText = '';

  List<BreedItem> get _filteredBreeds {
    // 1) 검색으로 1차 필터
    List<BreedItem> list = _allBreeds.where((b) {
      if (_searchText.isEmpty) return true;
      // 영문/한글 상관없이 검색할 수 있게 소문자 비교
      return b.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    // 2) 필터 선택값으로 2차 필터
    switch (_selectedFilter) {
      case '초보자 추천':
        list = list.where((b) => b.isBeginnerFriendly).toList();
        break;
      case '아파트 적합':
        list = list.where((b) => b.isApartmentFriendly).toList();
        break;
      case '활동량 낮음':
        list = list.where((b) => b.activityLevel == '낮음').toList();
        break;
      case '활동량 높음':
        list = list.where((b) => b.activityLevel == '높음').toList();
        break;
    // '전체'는 필터 없음
    }

    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF7EADA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final filters = ['전체', '초보자 추천', '아파트 적합', '활동량 낮음', '활동량 높음'];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '필터 선택',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...filters.map((f) {
                return RadioListTile<String>(
                  dense: true,
                  title: Text(f),
                  value: f,
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedFilter = value;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _onTapBreed(BreedItem breed) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BreedDetailPage(breed: breed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breeds = _filteredBreeds;

    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DD),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색 + 필터 아이콘
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchText = val.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: '품종 이름을 검색하세요',
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFF7EADA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _openFilterSheet,
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 현재 필터 표시
            Text(
              '필터: $_selectedFilter · 총 ${breeds.length}종',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // 종 카드 그리드
            Expanded(
              child: GridView.builder(
                itemCount: breeds.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 한 줄에 2개
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final breed = breeds[index];
                  return GestureDetector(
                    onTap: () => _onTapBreed(breed),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7EADA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: breed.imageUrl != null
                                  ? Image.network(
                                breed.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    color: Colors.brown.withOpacity(0.2),
                                    child: const Icon(Icons.pets),
                                  );
                                },
                              )
                                  : Container(
                                color: Colors.brown.withOpacity(0.2),
                                child: const Icon(Icons.pets),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  breed.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${breed.size} · 활동량 ${breed.activityLevel}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
