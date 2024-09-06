import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/home/presentation/widgets/explore_categories_list_template.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {
  static const String routeName = "category";
  var language;

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBarTemplate(
            pageTitle: "Browse categories",
            isSubPage: true,
          ),
        ),
        body: SingleChildScrollView(
            child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoadedState) {
              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Number of items in a row
                  crossAxisSpacing: 8.0, // Space between columns
                  mainAxisSpacing: 8.0, // Space between rows
                  childAspectRatio: 0.8, // Adjust the height/width ratio
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  return ExploreCategoryListTemplate(
                    categoryName: state.categories[index].name,
                    imageSrc: state.categories[index].image,
                  );
                },
              );
            } else {
              return Text('');
            }
          },
        )));
  }
}
