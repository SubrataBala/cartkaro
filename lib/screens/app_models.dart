import 'package:flutter/material.dart';

const Color kGroceryGreen  = Color(0xFF4CAF50); 
const Color kRestaurantRed = Color(0xFFE53935);
const Color kMedicalBlue   = Color(0xFF1565C0);

class TabData { final String label; final Color color; final IconData icon; const TabData(this.label, this.color, this.icon); }
class BannerData { final String title, subtitle; final Color bgColor; final String imagePath; final bool isLightBanner; const BannerData(this.title, this.subtitle, this.bgColor, this.imagePath, {this.isLightBanner = false}); }
class SpotlightItem { final String title, imagePath; final Color bgColor, textColor; const SpotlightItem(this.title, this.imagePath, this.bgColor, this.textColor); }
class GridSectionData { final String title; final List<CategoryItem> items; const GridSectionData(this.title, this.items); }
class CategoryItem { final String label, imagePath; const CategoryItem(this.label, this.imagePath); }
class StoreItem { final String label, imagePath; final Color bgColor; const StoreItem(this.label, this.imagePath, this.bgColor); }
class NavItem { final IconData icon; final String label; const NavItem(this.icon, this.label); }