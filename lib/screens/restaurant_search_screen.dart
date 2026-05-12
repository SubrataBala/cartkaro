import 'package:flutter/material.dart';
import 'app_models.dart';   
import '../widgets/item_cards.dart'; 
import 'restaurant_menu_screen.dart'; 
import 'restaurant_data.dart';

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}

class SearchCategoryItem {
  final String label;
  final String imagePath;
  SearchCategoryItem(this.label, this.imagePath);
}

class SearchSection {
  final String title;
  final List<SearchCategoryItem> items;
  SearchSection(this.title, this.items);
}

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showResults = false;

  bool get isDark => false; 
  Color get _bgColor => const Color(0xFFF8F9FA); 
  Color get _searchBgColor => Colors.white;
  Color get _textPrimary => const Color(0xFF1A1A1A); 
  Color get _textSecondary => const Color(0xFF757575);
  Color get _borderColor => Colors.grey.withOpacity(0.15);
  final Color _themeColor = const Color(0xFFE53935); 
  final Color _singleLightRed = const Color.fromARGB(255, 255, 128, 147); 

  // ==========================================
  // 1. PAST SEARCHES (Rich & Realistic)
  // ==========================================
  final List<Map<String, dynamic>> _pastSearches = [
    {'label': 'Biryani', 'icon': Icons.rice_bowl},
    {'label': 'Pizza', 'icon': Icons.local_pizza},
    {'label': 'Burger', 'icon': Icons.fastfood},
    {'label': 'Cold Coffee', 'icon': Icons.local_cafe},
    {'label': 'Momos', 'icon': Icons.set_meal},
    {'label': 'Noodles', 'icon': Icons.ramen_dining},
    {'label': 'Masala Dosa', 'icon': Icons.restaurant},
    {'label': 'Paneer Tikka', 'icon': Icons.room_service},
    {'label': 'Ice Cream', 'icon': Icons.icecream},
    {'label': 'Chole Bhature', 'icon': Icons.dinner_dining},
  ];

  // ==========================================
  // 2. CATEGORY CONTENT (Expanded & Categorized properly)
  // ==========================================
  final List<SearchSection> _searchCategories = [
    SearchSection('Top Picks For You', [
      SearchCategoryItem('Chicken Biryani', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Margherita Pizza', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Paneer Butter Masala', 'assets/images/broccoli.png'),
      SearchCategoryItem('Chicken Roll', 'assets/images/broccoli.png')
    ]),
    SearchSection('Trending This Week', [
      SearchCategoryItem('Zinger Burger', 'assets/images/burger.png'), 
      SearchCategoryItem('Hakka Noodles', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Cold Coffee', 'assets/images/broccoli.png'),
      SearchCategoryItem('Choco Lava Cake', 'assets/images/broccoli.png')
    ]),
    SearchSection('Top Cuisines', [
      SearchCategoryItem('North Indian', 'assets/images/broccoli.png'), 
      SearchCategoryItem('South Indian', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Chinese', 'assets/images/broccoli.png'),
      SearchCategoryItem('Italian', 'assets/images/broccoli.png')
    ]),
    SearchSection('Biryani & Pulao', [
      SearchCategoryItem('Hyderabadi', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Lucknowi', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Kolkata Biryani', 'assets/images/broccoli.png'),
      SearchCategoryItem('Veg Pulao', 'assets/images/broccoli.png')
    ]),
    SearchSection('Fast Food & Snacks', [
      SearchCategoryItem('Pizzas', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Burgers', 'assets/images/burger.png'), 
      SearchCategoryItem('Sandwiches', 'assets/images/broccoli.png'),
      SearchCategoryItem('Fries', 'assets/images/broccoli.png')
    ]),
    SearchSection('Street Food & Chaat', [
      SearchCategoryItem('Pani Puri', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Pav Bhaji', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Samosa', 'assets/images/broccoli.png'),
      SearchCategoryItem('Vada Pav', 'assets/images/broccoli.png')
    ]),
    SearchSection('Desserts & Drinks', [
      SearchCategoryItem('Ice Cream', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Milkshakes', 'assets/images/broccoli.png'), 
      SearchCategoryItem('Gulab Jamun', 'assets/images/broccoli.png'),
      SearchCategoryItem('Sweet Lassi', 'assets/images/broccoli.png')
    ]),
  ];

  // ── 🔥 SMART LOGIC: EXTRACT FROM GLOBAL DICTIONARY ──
  List<Map<String, dynamic>> get _extractedRestaurants {
    List<Map<String, dynamic>> resList = [];
    Set<String> addedRes = {};

    restaurantData.forEach((category, items) {
      for (var item in items) {
        String resName = item['restaurant'] ?? 'Unknown Restaurant';
        
        if (!addedRes.contains(resName)) {
          addedRes.add(resName);
          
          List<Map<String, dynamic>> resMenu = [];
          restaurantData.forEach((cat, itms) {
            resMenu.addAll(itms.where((i) => i['restaurant'] == resName).map((i) {
               // Include original categories for Cart handling
               var newItem = Map<String, dynamic>.from(i);
               newItem['category'] = cat;
               return newItem;
            }));
          });

          resList.add({
            'name': resName,
            'image': item['image'],
            'categories': category, 
            'rating': item['rating'] ?? '4.5',
            'time': item['time'] ?? '30 Mins',
            'distance': item['distance'] ?? '2.0 km',
            'totalSells': item['totalSells'] ?? '1K+ orders',
            'menu': resMenu, 
          });
        }
      }
    });
    return resList;
  }

  // ── 🔥 FILTER RESTAURANTS FOR SEARCH ──
  List<Map<String, dynamic>> get _matchedRestaurants {
     final restaurants = _extractedRestaurants;
     if(_query.isEmpty) return restaurants;

     List<Map<String, dynamic>> results = [];
     String queryLower = _query.toLowerCase();

     for (var res in restaurants) {
        bool isMatch = res['name'].toString().toLowerCase().contains(queryLower);
        
        if(!isMatch) {
            List menu = res['menu'];
            for(var item in menu) {
                 if (item['name'].toString().toLowerCase().contains(queryLower)) {
                    isMatch = true;
                    break;
                 }
            }
        }
        if(isMatch) results.add(res);
     }
     return results;
  }

  void _onSearchSubmit(String val) {
    if (val.isEmpty) return;
    setState(() {
      _query = val;
      _searchController.text = val;
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: NoJellyScrollBehavior(),
          child: Column(
            children: [
              _buildSearchHeader(),
              Expanded(
                child: _searchController.text.isEmpty
                    ? _buildDefaultView()      
                    : _showResults 
                        ? _buildResultsView()  
                        : _buildSuggestionsView(), 
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _searchBgColor, shape: BoxShape.circle, border: Border.all(color: _borderColor)), child: Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 20))),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50, decoration: BoxDecoration(color: _searchBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: _searchController, autofocus: true, onChanged: (v) { setState(() { _query = v; _showResults = false; }); }, onSubmitted: _onSearchSubmit, style: TextStyle(color: _textPrimary, fontSize: 15), decoration: InputDecoration(hintText: 'Search for dishes or restaurants...', hintStyle: TextStyle(color: _textSecondary, fontSize: 14), border: InputBorder.none))),
                  if (_searchController.text.isNotEmpty) GestureDetector(onTap: () { _searchController.clear(); setState(() { _query = ''; _showResults = false; }); }, child: Icon(Icons.close_rounded, color: _textSecondary, size: 22)) else Icon(Icons.mic_none_rounded, color: _textSecondary, size: 22),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultView() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildPastSearches(),
          const SizedBox(height: 30),
          ..._buildSearchCategoryRows(),
        ],
      ),
    );
  }

  Widget _buildPastSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
              Text('Clear', style: TextStyle(color: _themeColor, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          )
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 12,
            children: _pastSearches.map((search) => _buildSearchChip(search)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(Map<String, dynamic> search) {
    return GestureDetector(
      onTap: () => _onSearchSubmit(search['label']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(search['icon'], color: Colors.grey.shade400, size: 16), const SizedBox(width: 6), Text(search['label'], style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700))]),
      ),
    );
  }

  List<Widget> _buildSearchCategoryRows() {
    List<Widget> rows = [];
    for (var section in _searchCategories) {
      rows.add(Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(section.title, style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3))));
      rows.add(const SizedBox(height: 16));
      rows.add(
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16), shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: section.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.6, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemBuilder: (ctx, i) {
            final c = section.items[i];
            return GestureDetector(
              onTap: () => _onSearchSubmit(c.label), 
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                child: Row(
                  children: [
                    Container(
                      width: 55, 
                      decoration: BoxDecoration(color: _singleLightRed, borderRadius: const BorderRadius.horizontal(left: Radius.circular(12))), 
                      child: Center(
                        child: Image.asset(c.imagePath, width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.fastfood, color: Colors.white, size: 24))
                      )
                    ), 
                    const SizedBox(width: 10), 
                    Expanded(child: Text(c.label, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis)), 
                    const SizedBox(width: 8)
                  ]
                ),
              ),
            );
          },
        )
      );
      rows.add(const SizedBox(height: 32));
    }
    return rows;
  }

  Widget _buildSuggestionsView() {
    final restaurants = _matchedRestaurants;
    if(restaurants.isEmpty) return Center(child: Text("No restaurants or dishes found", style: TextStyle(color: _textSecondary)));
    
    return ListView.builder(
      itemCount: restaurants.length, 
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.restaurant, color: Colors.grey, size: 20), 
        title: Text(restaurants[index]['name'], style: const TextStyle(fontWeight: FontWeight.w600)), 
        subtitle: Text("Sells $_query", style: const TextStyle(fontSize: 12, color: Colors.grey)),
        onTap: () => _onSearchSubmit(restaurants[index]['name'])
      )
    );
  }

  Widget _buildResultsView() {
    final restaurants = _matchedRestaurants;

    if (restaurants.isEmpty) {
      return Center(child: Text("No restaurants selling '$_query' found.", style: TextStyle(color: _textSecondary)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Text('Restaurants selling "$_query"', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _textPrimary)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: restaurants.length,
            separatorBuilder: (_, __) => Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Divider(color: Colors.grey.shade200, height: 1)),
            itemBuilder: (context, index) {
              final r = restaurants[index];
              return GestureDetector(
                onTap: () {
                   // ── Map object ko Convert karke pass karenge
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => RestaurantMenuScreen(
                        restaurant: VendorRestaurant(
                             id: 'extracted',
                             name: r['name'],
                             categories: r['categories'],
                             rating: r['rating'],
                             time: r['time'],
                             distance: r['distance'],
                             totalSells: r['totalSells'],
                             imagePath: r['image'],
                             menu: List<Map<String, dynamic>>.from(r['menu'])
                        )
                    )
                  ));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 100, height: 100, color: Colors.grey.shade100,
                        child: Image.asset(r['image'], fit: BoxFit.cover, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 40))),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(r['categories'], style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 14),
                              const SizedBox(width: 4),
                              Text(r['rating'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey)),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: Colors.grey, fontSize: 10))),
                              Text(r['time'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: Colors.grey, fontSize: 10))),
                              Text(r['distance'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: Text('📈 ${r['totalSells']}', style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: _themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: Text('View Menu', style: TextStyle(color: _themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}