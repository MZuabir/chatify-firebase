import 'package:chatify_with_firebase/shared/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/global_appBar_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(mediaWidth, mediaHeight / 15),
          child: const GlobalAppBar(
            title: 'Search',
          )),
      body: Column(
        children: [
          Container(
            color: Constants.primaryColor,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                      hintText: 'Search groups',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintStyle: TextStyle(color: Colors.white)),
                )),
                Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      onSearchFunction();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30)),
                      height: 40,
                      width: 40,
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: Constants.primaryColor),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  onSearchFunction() {}
}
