part of 'category_bloc.dart';

class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<CategoryModel> categories;

  const CategoryLoadedState({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryErrorState extends CategoryState {
  final String error;

  const CategoryErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
