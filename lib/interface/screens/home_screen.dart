import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/constants.dart';
import 'package:myapp/interface/screens/scan_document_screen.dart';
import 'package:myapp/interface/screens/about_us_screen.dart';
import 'package:myapp/interface/screens/chat_bot_screen.dart';
import '../custom/components/rotated_rectangular_shape.dart';
import '../custom/widgets/navigation_rail_destinations_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
        title: Text(
          ['ChatBot', 'Scan Docs', 'About Us'][_selectedIndex],
          style: GoogleFonts.raleway(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: kGrey,
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: kGrey,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            selectedLabelTextStyle: GoogleFonts.raleway(
              color: kGrey,
              backgroundColor: Colors.white,
              fontSize: 14,
            ),
            unselectedLabelTextStyle: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 14,
            ),
            indicatorColor: Colors.white,
            indicatorShape: RotatedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              width: 80,
              height: 25,
            ),
            destinations: [
              buildRotatedTextRailDestination('ChatBot', 0, _selectedIndex),
              buildRotatedTextRailDestination('Scan Docs', 1, _selectedIndex),
              buildRotatedTextRailDestination('About Us', 2, _selectedIndex),
            ],
            minWidth: 0.1,
          ),
          Expanded(
            child: [
              const ChatBotScreen(),
              const ScanDocumentsScreen(),
              const AboutUsScreen()
            ][_selectedIndex],
          ),
        ],
      ),
    );
  }
}
