import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite/blocs/comment_bloc.dart';
import 'package:infinite/events/coment_events.dart';
import 'package:infinite/infinite_list.dart';
import 'package:infinite/model/comment.dart';
import 'package:infinite/services/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: BlocProvider(
        create: (context)=>CommentBloc()..add(CommentFetchedEvent()),
        child: InfiniteList(),
      )
    );
  }

}

