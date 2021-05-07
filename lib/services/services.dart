import 'dart:convert';
import 'package:infinite/model/comment.dart';
import 'package:http/http.dart' as http;

Future<List<Comment>> getCommentsFromApi(int start, int limit) async {
  final url =
      "https://mocki.io/v1/0ac0a2db-2720-4698-bb3c-2202500eff2e";
  final http.Client httpClient = http.Client();
  try {
    final response = await httpClient.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      print("1.server");
      final List<Comment> Comments = responseData.map((e) {
        return Comment(
            id: e["id"],
            title: e["title"],
            body: e["body"]
        );
      }).toList();
      return Comments;
    }
    else {
      print("hix");
      return List<Comment>();
    }
  } catch (exception) {
    print('Exception sending api'+exception.toString());
  }
}
