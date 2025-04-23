import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/category_model.dart';


class Homepage extends StatelessWidget {
  Homepage({super.key});

  List<CategoryModel> categories = [];

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  // @override
  // void initState() {
  //   _getCategories();
  // }

  @override
  Widget build(BuildContext context) {
    _getCategories();
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        shrinkWrap: true,// Use when encountering size-related errors for list and grid
        children: [
          _search(),
          const SizedBox(
            height: 10,
          ),
          _CategorySection(),
        ],
      ),
    );
  }

  Column _search() {
    return Column(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.yellow,
                    blurRadius: 40,
                    spreadRadius: 0.0)
              ]),
              child: TextField(
                decoration: InputDecoration(
                  filled: false,
                  fillColor: Colors.green,
                  contentPadding: const EdgeInsets.all(15),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Color(0xff504949),
                    fontSize: 14,
                  ),
                  prefixIcon: SizedBox(
                    width: 20,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset('assets/icons/cat.svg'),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 70, // 设定width不然会占满 hintText 就show不到了
                    // IntrinsicHeight是一个试图将其子级的大小调整为该子级的固有高度的小部件。
                    // 这意味着它会让它的孩子达到孩子想要的高度，但不会更高。
                    height: 50,
                    child: IntrinsicHeight(
                      //有VerticalDivider(）要放
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const VerticalDivider(
                            //生成 直线
                            color: Colors.black,
                            thickness: 0.1,
                            indent: 10, //往上padding
                            endIndent: 10, // 往下padding
                          ),
                          SizedBox(
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0,right: 12, top: 12, bottom: 12),
                              child: SvgPicture.asset('assets/icons/cat.svg'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        );
  }

  Column _CategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'category',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(
              width: 25,
            ),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                    color: categories[index].boxColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(categories[index].iconPath),
                      ),
                    ),
                    Text(
                      categories[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){},
                      child: Container(
                        height: 15,
                        width: 45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Colors.red,
                            Colors.white,
                          ]
                          ),
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: const Center(
                          child: Text(
                            'view',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }


  AppBar appBar() {
    return AppBar(
      title: const Text(
        'cat',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.green,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          // if width and height did not function can add this
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset(
            'assets/icons/cat.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 37,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset(
              'assets/icons/cat.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
      ],
    );
  }
}
