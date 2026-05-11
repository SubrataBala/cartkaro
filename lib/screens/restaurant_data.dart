// Sirf Restaurant ka data yahan rahega
final Map<String, List<Map<String, dynamic>>> restaurantData = {
  
  // ── 1. TOP PICKS ──
  'Top Picks': [
    {
      'id': 'r1', 
      'name': 'Chicken Dum Biryani', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': 'Half', 'price': 160.0},
        {'weight': 'Full', 'price': 280.0},
      ]
    },
    {
      'id': 'r2', 
      'name': 'Farmhouse Veg Pizza', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': 'Regular', 'price': 199.0},
        {'weight': 'Medium', 'price': 399.0},
      ]
    },
    {
      'id': 'r3', 
      'name': 'Veg Steam Momos', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': '6 pcs', 'price': 80.0},
        {'weight': '10 pcs', 'price': 120.0},
      ]
    },
  ],

  // ── 2. TRENDING ──
  'Trending': [
    {
      'id': 'r4', 
      'name': 'Zinger Chicken Burger', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': '1 pc', 'price': 149.0},
        {'weight': 'Combo (with Fries)', 'price': 249.0},
      ]
    },
    {
      'id': 'r5', 
      'name': 'Veg Hakka Noodles', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': 'Half', 'price': 90.0},
        {'weight': 'Full', 'price': 150.0},
      ]
    },
    {
      'id': 'r6', 
      'name': 'Classic Cold Coffee', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': 'Regular (300ml)', 'price': 120.0},
        {'weight': 'Large (500ml)', 'price': 180.0},
      ]
    },
  ],

  // ── 3. TOP CUISINES ──
  'Top Cuisines': [
    {
      'id': 'r7', 
      'name': 'Butter Chicken (North Indian)', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': 'Half', 'price': 320.0},
        {'weight': 'Full', 'price': 550.0},
      ]
    },
    {
      'id': 'r8', 
      'name': 'Paneer Butter Masala', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': 'Half', 'price': 220.0},
        {'weight': 'Full', 'price': 380.0},
      ]
    },
    {
      'id': 'r9', 
      'name': 'Masala Dosa (South Indian)', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': '1 pc', 'price': 110.0},
      ]
    },
    {
      'id': 'r10', 
      'name': 'Chilli Chicken (Chinese)', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': 'Half', 'price': 180.0},
        {'weight': 'Full', 'price': 320.0},
      ]
    },
  ],

  // ── 4. BIRYANI & PULAO ──
  'Biryani & Pulao': [
    {
      'id': 'r11', 
      'name': 'Hyderabadi Chicken Biryani', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': 'Half', 'price': 180.0},
        {'weight': 'Full', 'price': 320.0},
      ]
    },
    {
      'id': 'r12', 
      'name': 'Mutton Dum Biryani', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': 'Full', 'price': 399.0},
        {'weight': 'Family Pack', 'price': 750.0},
      ]
    },
    {
      'id': 'r13', 
      'name': 'Veg Pulao with Raita', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': 'Full', 'price': 160.0},
      ]
    },
  ],

  // ── 5. PIZZAS & BURGERS ──
  'Pizzas & Burgers': [
    {
      'id': 'r14', 
      'name': 'Cheese Burst Margherita', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': 'Regular', 'price': 149.0},
        {'weight': 'Medium', 'price': 299.0},
      ]
    },
    {
      'id': 'r15', 
      'name': 'Crunchy Chicken Burger', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '1 pc', 'price': 129.0},
      ]
    },
    {
      'id': 'r16', 
      'name': 'Spicy Paneer Tikka Burger', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': '1 pc', 'price': 119.0},
        {'weight': 'Combo (with Coke)', 'price': 169.0},
      ]
    },
  ],

  // ── 6. NOODLES & MOMOS ──
  'Noodles & Momos': [
    {
      'id': 'r17', 
      'name': 'Chicken Hakka Noodles', 
      'image': 'assets/images/broccoli.png', 
      'isBestseller': true,
      'variants': [
        {'weight': 'Half', 'price': 110.0},
        {'weight': 'Full', 'price': 190.0},
      ]
    },
    {
      'id': 'r18', 
      'name': 'Chicken Steam Momos', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '6 pcs', 'price': 99.0},
        {'weight': '10 pcs', 'price': 149.0},
      ]
    },
    {
      'id': 'r19', 
      'name': 'Veg Fried Momos', 
      'image': 'assets/images/broccoli.png', 
      'variants': [
        {'weight': '6 pcs', 'price': 90.0},
        {'weight': '10 pcs', 'price': 130.0},
      ]
    },
  ],
};