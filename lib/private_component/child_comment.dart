import 'package:collab/private_component/comment.dart';
import 'package:flutter/material.dart';

class ChildComment extends StatefulWidget {
  final parentComment, allComments, callback;
  const ChildComment(
      {super.key,
      required this.parentComment,
      required this.allComments,
      this.callback});

  @override
  State<ChildComment> createState() => _ChildCommentState();
}

class _ChildCommentState extends State<ChildComment> {
  @override
  Widget build(BuildContext context) {
    final parentComment = super.widget.parentComment;
    final allComments = super.widget.allComments;

    allComments.removeWhere((item) => item['_id'] == parentComment['_id']);
    List<dynamic> childComments = allComments
        .where((comment) => comment['parent'] == parentComment['_id'])
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, right: 8.0),
          child: Icon(Icons.subdirectory_arrow_right,
              size: 15, color: Colors.grey),
        ),
        Flexible(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Comment(comment: parentComment, callback: widget.callback),
            childComments.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: childComments.length,
                    itemBuilder: (context, index) {
                      return ChildComment(
                          parentComment: childComments[index],
                          allComments: allComments,
                          callback: widget.callback);
                    },
                  )
                : Container(),
          ]),
        ),
      ],
    );
  }
}
