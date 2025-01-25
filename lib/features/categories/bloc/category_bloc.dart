import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rapidlie/config/data_state.dart';
import 'package:rapidlie/features/categories/models/category_model.dart';
import 'package:rapidlie/features/categories/repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  List<CategoryModel>? _cachedCategories;

  CategoryBloc({required this.categoryRepository})
      : super(CategoryInitialState()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoadingState());
    if (_cachedCategories != null) {
      emit(CategoryLoadedState(categories: _cachedCategories!));
      return;
    }
    try {
      final categoriesResponse = await categoryRepository.getCategories();

      if (categoriesResponse is DataSuccess<List<CategoryModel>>) {
        _cachedCategories = categoriesResponse.data;
        emit(CategoryLoadedState(categories: categoriesResponse.data!));
      } else if (categoriesResponse is DataFailed) {
        emit(CategoryErrorState(error: categoriesResponse.error.toString()));
      }
    } catch (e) {
      emit(CategoryErrorState(error: e.toString()));
    }
  }
}
