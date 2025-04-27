//  ShadeUI, A UI system for JappeOS apps.
//  Copyright (C) 2025  The JappeOS team.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shade_ui/shade_ui.dart';

class ShadeSidebarLayout extends StatefulWidget {
  const ShadeSidebarLayout({super.key, this.controller, required this.title, required this.pages});

  final SidebarLayoutController? controller;
  final String title;
  final List<SidebarLayoutPage> pages;

  @override
  State<ShadeSidebarLayout> createState() => _ShadeSidebarLayoutState();
}

class _ShadeSidebarLayoutState extends State<ShadeSidebarLayout> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late SidebarLayoutController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? SidebarLayoutController(0, (_) {});
    _controller._setPage = _onPageChanged;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onPageChanged(_controller._currentPage);
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller._setPage = null;
    super.dispose();
  }

  void _onPageChanged(int newPage) {
    if (_controller._currentPage == newPage && _isInitialized) return;

    setState(() {});
    _navigatorKey.currentState?.pushReplacementNamed(widget.pages[newPage].title);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSidebar() => Material(color: Colors.transparent, child: SizedBox(
      width: 250,
      child: ListView.builder(
        itemCount: widget.pages.length,
        itemBuilder: (context, index) {
          final page = widget.pages[index];
          return Padding(
            padding: const EdgeInsets.only(left: BPPresets.small, right: BPPresets.small, bottom: BPPresets.small),
            child: ListTile(
              leading: Icon(page.icon),
              title: Text(page.title),
              selected: _controller._currentPage == index,
              onTap: () => _controller.changePage(index),
            ),
          );
        },
      ),
    ),);

    Widget buildContent() => Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(BPPresets.medium)),
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Navigator(
            key: _navigatorKey,
            onGenerateRoute: (settings) {
              if (settings.name == "/") {
                return MaterialPageRoute(builder: (_) => const Center(child: CircularProgressIndicator()), settings: settings);
              }

              final page = widget.pages.firstWhere((it) => it.title == settings.name);
              builder(BuildContext _) => page.content;

              return MaterialPageRoute(builder: builder, settings: settings);
            },
          ),
        ),
      ),
    );

    return Row(
      children: [
        buildSidebar(),
        buildContent(),
      ],
    );
  }
}

class SidebarLayoutController {
  SidebarLayoutController(int initialPage, this.onPageChanged) {
    _currentPage = initialPage;
  }

  int _currentPage = 0;
  void Function(int)? _setPage;

  final void Function(int) onPageChanged;

  void changePage(int pageIndex) {
    _setPage!(pageIndex);
    onPageChanged(pageIndex);
    _currentPage = pageIndex;
  }

  int getPage() => _currentPage;
}

class SidebarLayoutPage {
  const SidebarLayoutPage(this.icon, this.title, this.content);

  final IconData icon;
  final String title;
  final Widget content;
}