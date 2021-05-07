import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite/events/coment_events.dart';
import 'package:infinite/services/services.dart';
import 'package:infinite/states/comment_states.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final NUMBER_OF_COMMENTS_PER_PAGE = 20;
  CommentBloc() : super(CommentStateInitial());

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    try {
      final hasRechedEndOfOnePage = (state is CommentStateSuccess &&
          (state as CommentStateSuccess).hasReachedEnd);
      if (event is CommentFetchedEvent && !hasRechedEndOfOnePage) {
        if (state is CommentStateInitial) {
          print("CommentStateInitial");
          final comments =
              await getCommentsFromApi(0, NUMBER_OF_COMMENTS_PER_PAGE);
          yield CommentStateSuccess(
            comments: comments,
            hasReachedEnd: false,
          );
        }
        else {
          if (state is CommentStateSuccess) {
            print("CommentStateSuccess");
            final currentState = state as CommentStateSuccess;
            int finalIndexOfCurrentPage = currentState.comments.length;
            final comments = await getCommentsFromApi(
                finalIndexOfCurrentPage, NUMBER_OF_COMMENTS_PER_PAGE);
            print("CommentStateSuccess");
            if (comments.isEmpty) {
              yield currentState.cloneWith(hasReachedEnd: true);
            }
            else {
              yield CommentStateSuccess(
                comments: currentState.comments + comments,
                hasReachedEnd: false,
              );
            }
            print("CommentStateSuccess");
          }
        }
      }
    } catch (exception) {
      yield CommentStateFailure();
    }
  }
}
