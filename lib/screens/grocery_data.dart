// Sirf Grocery ka data yahan rahega
final Map<String, List<Map<String, dynamic>>> groceryData = {
  'Vegetables': [
    {
      'id': 'g1', 
      'name': 'Potato', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true, // 🔥 Bestseller tag yahan se aayega
      'variants': [
        {'weight': '500g', 'price': 18.0},
        {'weight': '1kg', 'price': 34.0},
        {'weight': '2kg', 'price': 65.0},
      ]
    },
    {
      'id': 'g2', 
      'name': 'Broccoli', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '1 pc', 'price': 45.0},
        {'weight': '2 pcs', 'price': 85.0},
      ]
    },
    {
      'id': 'g3', 
      'name': 'Carrot', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '250g', 'price': 22.0},
        {'weight': '500g', 'price': 40.0},
        {'weight': '1kg', 'price': 75.0},
      ]
    },
    {
      'id': 'g4', 
      'name': 'Onion', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true, 
      'variants': [
        {'weight': '1kg', 'price': 35.0},
        {'weight': '5kg', 'price': 160.0},
      ]
    },
    {
      'id': 'g5', 
      'name': 'Cabbage', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '1 pc', 'price': 45.0},
      ]
    },
  ],
  
  'Fruits': [
    {
      'id': 'g6', 
      'name': 'Kashmiri Apple', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true, 
      'variants': [
        {'weight': '4 pcs', 'price': 80.0},
        {'weight': '1kg', 'price': 150.0},
      ]
    },
    {
      'id': 'g7', 
      'name': 'Banana (Robusta)', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '6 pcs', 'price': 35.0},
        {'weight': '1 Dozen', 'price': 65.0},
      ]
    },
    {
      'id': 'g8', 
      'name': 'Papaya (Semi-Ripe)', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '1 pc', 'price': 60.0},
        {'weight': '1.5kg', 'price': 85.0},
      ]
    },
    {
      'id': 'g9', 
      'name': 'Nagpur Orange', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true, 
      'variants': [
        {'weight': '500g', 'price': 50.0},
        {'weight': '1kg', 'price': 95.0},
      ]
    },
    {
      'id': 'g10', 
      'name': 'Green Guava', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '500g', 'price': 40.0},
        {'weight': '1kg', 'price': 75.0},
      ]
    },
  ],

  // ── NAYA ADD KIYA HUA GROCERY DATA ──
  'Grocery': [
    {
      'id': 'g11', 
      'name': 'India Gate Basmati Rice', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true, 
      'variants': [
        {'weight': '1kg', 'price': 110.0},
        {'weight': '5kg', 'price': 520.0},
      ]
    },
    {
      'id': 'g12', 
      'name': 'Aashirvaad Shudh Chakki Atta', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true, 
      'variants': [
        {'weight': '1kg', 'price': 55.0},
        {'weight': '5kg', 'price': 240.0},
        {'weight': '10kg', 'price': 450.0},
      ]
    },
    {
      'id': 'g13', 
      'name': 'Tata Sampann Arhar Dal', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '500g', 'price': 85.0},
        {'weight': '1kg', 'price': 160.0},
      ]
    },
    {
      'id': 'g14', 
      'name': 'Fortune Mustard Oil', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '1 L', 'price': 145.0},
        {'weight': '5 L', 'price': 700.0},
      ]
    },
    {
      'id': 'g15', 
      'name': 'Madhur Pure & Hygienic Sugar', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '1kg', 'price': 48.0},
        {'weight': '5kg', 'price': 230.0},
      ]
    },
  ],

  // ── NAYA ADD KIYA HUA SNACKS & DRINKS DATA ──
  'Snacks & Drinks': [
    {
      'id': 'g16', 
      'name': 'Lay\'s Classic Salted Chips', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true, 
      'variants': [
        {'weight': '50g', 'price': 20.0},
        {'weight': '100g', 'price': 40.0},
      ]
    },
    {
      'id': 'g17', 
      'name': 'Haldiram\'s Bhujia Sev', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '200g', 'price': 55.0},
        {'weight': '400g', 'price': 105.0},
      ]
    },
    {
      'id': 'g18', 
      'name': 'Coca Cola Soft Drink', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true, 
      'variants': [
        {'weight': '750ml', 'price': 40.0},
        {'weight': '1.25 L', 'price': 65.0},
        {'weight': '2 L', 'price': 95.0},
      ]
    },
    {
      'id': 'g19', 
      'name': 'Oreo Chocolate Cookies', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '120g', 'price': 30.0},
        {'weight': '300g (Family Pack)', 'price': 80.0},
      ]
    },
    {
      'id': 'g20', 
      'name': 'Real Mixed Fruit Juice', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '200ml', 'price': 25.0},
        {'weight': '1 L', 'price': 110.0},
      ]
    },
  ]
};