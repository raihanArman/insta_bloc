import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_bloc/models/models.dart';
import 'package:insta_bloc/repositories/user/user_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;

  SearchCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchState.initial());

  void searchUsers(String query) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final users = await _userRepository.searchUsers(query: query);
      emit(state.copyWith(users: users, status: SearchStatus.loaded));
    } catch (err) {
      emit(state.copyWith(
          status: SearchStatus.error,
          failure: Failure(message: 'Something went wrong')));
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchStatus.initial));
  }
}
