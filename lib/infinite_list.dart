import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite/blocs/comment_bloc.dart';
import 'package:infinite/events/coment_events.dart';
import 'package:infinite/model/comment.dart';
import 'package:infinite/services/services.dart';
import 'package:infinite/states/comment_states.dart';

class InfiniteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _InfiniteList();
  }
}

class _InfiniteList extends State<InfiniteList> {
  CommentBloc _commentBloc;
  final _scrollController = ScrollController();
  final _scrollThreadhold = 250.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
    _commentBloc = BlocProvider.of(context);
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollThreadhold) {
        _commentBloc.add(CommentFetchedEvent());
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCommentsFromApi(0, 20);
    // TODO: implement build
    return Scaffold(
      body: Center(child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state is CommentStateInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CommentStateFailure) {
            return Center(
              child: Text(
                "Cannot load comments from server",
                style: TextStyle(color: Colors.red, fontSize: 22),
              ),
            );
          }
          if (state is CommentStateSuccess) {
            if (state.comments.isEmpty) {
              return Center(
                child: Text("Empty comments !"),
              );
            }
            return ListView.builder(
              //controller:
              itemCount: state.hasReachedEnd
                  ? state.comments.length
                  : state.comments.length + 1,
              itemBuilder: (BuildContext buildContext, int index) {
                if (index >= state.comments.length) {
                  return Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                  );
                } else
                  return ListTile(
                    leading: Text("${state.comments[index].id}",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange)),
                    title: Text("${state.comments[index].title}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                    isThreeLine: true,
                    subtitle: Text("${state.comments[index].body}"),
                  );
              },
              controller: _scrollController,
            );
          }
        },
      )),
    );
  }
}
