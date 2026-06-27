class MenuItemData {
  final String title;
  final String route;

  const MenuItemData({
    required this.title,
    required this.route,
  });
}

const List<MenuItemData> menuItems = [
  MenuItemData(
    title: 'Home',
    route: '/',
  ),
  MenuItemData(
    title: 'Apps',
    route: '/apps',
  ),
  MenuItemData(
    title: 'Downloads',
    route: '/downloads',
  ),
  MenuItemData(
    title: 'Store',
    route: '/store',
  ),
  MenuItemData(
    title: 'Gallery',
    route: '/gallery',
  ),
  MenuItemData(
    title: 'Blog',
    route: '/blog',
  ),
  MenuItemData(
    title: 'About',
    route: '/about',
  ),
  MenuItemData(
    title: 'Contact',
    route: '/contact',
  ),
];