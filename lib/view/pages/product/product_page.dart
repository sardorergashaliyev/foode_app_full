import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foode/controllers/home_controller.dart';
import 'package:foode/view/style/style.dart';
import 'package:foode/view/widgets/cached_network_image.dart';
import 'package:foode/view/widgets/custom_textform.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>()
        ..getProduct(isLimit: false)
        ..getCategory(isLimit: false)
        ..getUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeController>();
    final event = context.read<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFrom(
                    controller: search,
                    label: "Search",
                    onChange: (s) {
                      // event.searchCategory(s);
                    },
                    hintext: '',
                  ),
                ),
                IconButton(
                    onPressed: () {
                      event.setFilterChange();
                    },
                    icon: const Icon(Icons.menu))
              ],
            ),
          ),
          state.setFilter || (state.selectIndex == -1)
              ? const SizedBox.shrink()
              : Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.pinkAccent),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child:
                      Text(state.listOfCategory[state.selectIndex].name ?? ""),
                ),
          Expanded(
            child: state.setFilter
                ? Wrap(
                    children: [
                      for (int i = 0; i < state.listOfCategory.length; i++)
                        InkWell(
                          onTap: () {
                            event.changeIndex(i);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: state.selectIndex == i
                                  ? Colors.pinkAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.pinkAccent),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Text(state.listOfCategory[i].name ?? ""),
                          ),
                        )
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        context.watch<HomeController>().listOfProduct.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width - 48,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Style.greyColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            state.listOfProduct[index].image == null
                                ? const CustomImageNetwork(
                                    height: 100,
                                    width: 100,
                                    image:
                                        'https://cdn11.bigcommerce.com/s-4f830/stencil/21634b10-fa2b-013a-00f1-62a1dd733893/e/4a0532a0-6207-013b-8ab2-261f9b1f5b00/icons/icon-no-image.svg',
                                  )
                                : CustomImageNetwork(
                                    image: context
                                            .watch<HomeController>()
                                            .listOfProduct[index]
                                            .image ??
                                        '',
                                    height: 80,
                                    width: 80,
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  20.horizontalSpace,
                                  Text(state.listOfProduct[index].name ?? ""),
                                  20.horizontalSpace,
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      state.listOfProduct[index].desc ?? "",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  20.horizontalSpace
                                ],
                              ),
                            ),
                            // const Spacer(),
                            Text(state.listOfProduct[index].price.toString()),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                event.changeLike(index);
                              },
                              icon: (state.listOfProduct[index].isLike)
                                  ? const Icon(Icons.favorite)
                                  : const Icon(Icons.favorite_border),
                            )
                          ],
                        ),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
