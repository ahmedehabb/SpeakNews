import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../articles_screen/controller/articles_cubit.dart';
import '../constants.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key, this.changeSearchQuery}) : super(key: key);

  final void Function(String)? changeSearchQuery;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
        ),
        height: 50.h,
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                    hintText: "Find intresting news",
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30.sp,
                    ),
                    prefixIconColor: Colors.orange,
                    border: InputBorder.none),
                onEditingComplete: () {
                  if (searchQuery.isEmpty) {
                    if (_controller.text.isNotEmpty) {
                      widget.changeSearchQuery?.call(_controller.text);
                      BlocProvider.of<ArticlesCubit>(context)
                          .getCnnArticles(_controller.text);
                      setState(() {
                        searchQuery = _controller.text;
                      });
                    }
                  } else {
                    if (_controller.text.isEmpty) {
                      setState(() {
                        searchQuery = '';
                      });
                      _controller.clear();
                      widget.changeSearchQuery?.call('');
                      BlocProvider.of<ArticlesCubit>(context)
                          .getCnnArticles('');
                    }
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.orange,
              ),
              height: 50.h,
              width: 120.w,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  if (searchQuery.isEmpty) {
                    if (_controller.text.isNotEmpty) {
                      widget.changeSearchQuery?.call(_controller.text);
                      BlocProvider.of<ArticlesCubit>(context)
                          .getCnnArticles(_controller.text);
                      setState(() {
                        searchQuery = _controller.text;
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please fill the search field",
                        backgroundColor: fifthColor,
                        colorText: thirdColor,
                      );
                    }
                  } else {
                    setState(() {
                      searchQuery = '';
                    });
                    _controller.clear();
                    widget.changeSearchQuery?.call('');
                    BlocProvider.of<ArticlesCubit>(context).getCnnArticles('');
                  }
                },
                child: Text(
                  (searchQuery.isEmpty) ? 'Search' : 'Clear',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
