import 'package:flutter/material.dart';

import '../../models/dog_breed.dart';
import '../../network/dog_breed_api_client.dart';
import 'breed_item.dart';
import 'breed_detail_page.dart';

class BreedSelectPage extends StatefulWidget {
  const BreedSelectPage({super.key});

  @override
  State<BreedSelectPage> createState() => _BreedSelectPageState();
}

class _BreedSelectPageState extends State<BreedSelectPage> {
  final TextEditingController _searchController = TextEditingController();

  // 🔥 이제는 Repository 대신, 서버 API 클라이언트만 사용
  final DogBreedApiClient _apiClient = const DogBreedApiClient();

  /// 실제 전체 품종 리스트 (서버에서 가져온 것)
  List<BreedItem> _allBreeds = [];

  bool _isLoading = true;
  String? _errorMessage;

  String _selectedFilter = '전체';
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 서버에서 품종 리스트 로딩
  Future<void> _loadBreeds({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1) Flask 서버에서 견종 리스트 가져오기
      final List<DogBreed> dogBreeds = await _apiClient.fetchBreeds();
      debugPrint('🐶 dogBreeds length = ${dogBreeds.length}');

      if (dogBreeds.isEmpty) {
        throw Exception('서버에서 견종 정보를 받지 못했어요.');
      }

      // 2) 서버에서 이미 한국어(name_ko 등)를 내려주므로 번역 API는 필요 없음
      final breeds = dogBreeds.map((dog) {
        // BreedItem.fromDogBreed 안에서 nameKo를 우선 쓰도록 만들어놨다고 가정
        return BreedItem.fromDogBreed(
          dog,
          nameKo: dog.nameKo, // 없으면 모델에서 nameEn으로 fallback
        );
      }).toList();

      setState(() {
        _allBreeds = breeds;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ _loadBreeds error: $e');
      setState(() {
        _errorMessage = '견종 정보를 불러오는 중 오류가 발생했어요.\n$e';
        _isLoading = false;
      });
    }
  }

  /// 검색 + 필터 적용된 리스트
  List<BreedItem> get _filteredBreeds {
    // 1) 검색으로 1차 필터
    List<BreedItem> list = _allBreeds.where((b) {
      if (_searchText.isEmpty) return true;
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
      body: SafeArea(
        child: Padding(
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

              if (_isLoading) ...[
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ] else if (_errorMessage != null) ...[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _loadBreeds(forceRefresh: true),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  '필터: $_selectedFilter · 총 ${breeds.length}종',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _loadBreeds(forceRefresh: true),
                    child: GridView.builder(
                      itemCount: breeds.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
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
                                    borderRadius:
                                    const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: breed.imageUrl != null
                                        ? Image.network(
                                      breed.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) {
                                        return Container(
                                          color: Colors.brown
                                              .withOpacity(0.2),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
