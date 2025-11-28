import 'package:flutter/material.dart';
import '../../network/translation_client.dart';
import 'breed_item.dart';
import 'breed_detail_page.dart';
import '../../network/the_dog_api_client.dart';
import '../../database/dog_breed_dao.dart';
import 'package:Dang_Guide/repositories/dog_repositories.dart';


class BreedSelectPage extends StatefulWidget {
  const BreedSelectPage({super.key});

  @override
  State<BreedSelectPage> createState() => _BreedSelectPageState();
}

class _BreedSelectPageState extends State<BreedSelectPage> {
  final TextEditingController _searchController = TextEditingController();

  late final DogRepository _repository;

  /// 실제 전체 품종 리스트 (API + DB에서 가져온 것)
  List<BreedItem> _allBreeds = [];

  bool _isLoading = true;
  String? _errorMessage;

  String _selectedFilter = '전체';
  String _searchText = '';

  @override
  void initState() {
    super.initState();

    final apiClient = const TheDogApiClient();
    final dao = DogBreedDao();

    _repository = DogRepository(apiClient: apiClient, dao: dao);

    _loadBreeds();
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Repository 통해 로컬 + API에서 품종 리스트 로딩
  Future<void> _loadBreeds({bool forceRefresh = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1) 우선 견종 리스트부터 가져오기 (Flask 200 확인된 부분)
      final dogBreeds = await _repository.getBreeds(forceRefresh: forceRefresh);
      debugPrint('🐶 dogBreeds length = ${dogBreeds.length}');

      // dogBreeds가 비어 있으면 바로 에러 처리
      if (dogBreeds.isEmpty) {
        throw Exception('서버에서 견종 정보를 받지 못했어요.');
      }

      // 2) 한글 이름 번역은 "옵션"으로 처리 (실패해도 리스트는 나와야 함)
      Map<String, String> koMap = {};
      try {
        final uniqueNames = dogBreeds.map((b) => b.name).toSet().toList();

        debugPrint('🌏 translate uniqueNames length = ${uniqueNames.length}');

        final translationClient = const TranslationClient(
          // 🔥 여기 꼭 실제 주소로! (에뮬레이터 ⇒ PC 플라스크)
          baseUrl: 'http://10.0.2.2:5000/api',
        );

        koMap = await translationClient.translateNames(uniqueNames);
        debugPrint('🌏 translated map size = ${koMap.length}');
      } catch (e) {
        // 번역 실패해도 전체 UI는 살려둔다
        debugPrint('⚠ 번역 실패 (무시하고 영어 이름만 사용): $e');
      }

      // 3) BreedItem 리스트 생성 (한글 이름 있으면 사용)
      final breeds = dogBreeds.map((dog) {
        final ko = koMap[dog.name];
        return BreedItem.fromDogBreed(dog, nameKo: ko);
      }).toList();

      setState(() {
        _allBreeds = breeds;
        _isLoading = false;
      });
    } catch (e) {
      // 여기까지 오면 "견종 리스트 자체"를 못 받은 경우
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

              // 상태별 분기
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

                // 종 카드 그리드 + 당겨서 새로고침
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _loadBreeds(forceRefresh: true),
                    child: GridView.builder(
                      itemCount: breeds.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
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
