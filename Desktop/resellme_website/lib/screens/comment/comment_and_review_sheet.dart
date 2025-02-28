import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../network/api_service.dart';

class CommentsReviewsBottomSheet extends StatefulWidget {
  final String token;
  final int groupId;
  final String groupLogo;
  final String groupName;
  final int userId;

  const CommentsReviewsBottomSheet({
    super.key,
    required this.token,
    required this.groupId,
    required this.groupLogo,
    required this.groupName,
    required this.userId,
  });

  @override
  _CommentsReviewsBottomSheetState createState() => _CommentsReviewsBottomSheetState();
}

class _CommentsReviewsBottomSheetState extends State<CommentsReviewsBottomSheet> with SingleTickerProviderStateMixin {
  late ApiService _apiService;

  TabController? _tabController;
  bool _commentsFetched = false;
  bool _reviewsFetched = false;

  List<dynamic> commentsList = [];
  List<dynamic> reviewsList = [];
  List<bool> _commentReplyVisible = []; // Separate for comments
  List<bool> _reviewReplyVisible = []; // Separate for reviews
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final dio = Dio();
    _apiService = ApiService(dio);

    _tabController = TabController(length: 2, vsync: this);

    // Fetch comments when the bottom sheet is first opened
    fetchComments();

    // Listen for tab changes to fetch comments or reviews accordingly
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) return;

      if (_tabController!.index == 1 && !_reviewsFetched) {
        fetchReviews();
      }
    });
  }


  Future<void> fetchComments() async {
    try {
      final response = await _apiService.getCatalogComments(
        widget.userId,
        widget.groupId,
        "comments",
        "all",
        widget.token,
      );

      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      final dataField = responseData['data'];
      if (dataField is Map<String, dynamic>) {
        final commentReviewList = dataField['commentReviewList'];

        if (commentReviewList is List) {
          commentsList = commentReviewList
              .where((item) => item['commentType'] == "Comment")
              .toList();

          // Re-initialize _replyVisible based on the length of the new commentsList
          _commentReplyVisible = List.generate(commentsList.length, (_) => false);
          _commentsFetched = true;
          setState(() {}); // Update UI after fetching
        }
      }
    } catch (e) {
      print('Failed to fetch comments: $e');
    }
  }


  Future<void> fetchReviews() async {
    try {
      final response = await _apiService.getCatalogComments(
        widget.userId,
        widget.groupId,
        "reviews",
        "all",
        widget.token,
      );

      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      final dataField = responseData['data'];
      if (dataField is Map<String, dynamic>) {
        final commentReviewList = dataField['commentReviewList'];

        print('commentReviewList List Data: $commentReviewList'); // Debugging

        if (commentReviewList is List) {
          reviewsList = commentReviewList
              .where((item) => item['commentType'] == "Rating")
              .toList();

          // Initialize _replyVisible for each review item
          _reviewReplyVisible = List.generate(reviewsList.length, (_) => false);
          _reviewsFetched = true;
          setState(() {}); // Update UI after fetching
        }
      }
    } catch (e) {
      print('Failed to fetch reviews: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // Adjust the radius as needed
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Comments (${commentsList.length})'),
                  Tab(text: 'Reviews (${reviewsList.length})'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      itemCount: commentsList.length,
                      itemBuilder: (context, index) {
                        final comment = commentsList[index];
                        return _buildCommentItem(comment, index);
                      },
                    ),
                    ListView.builder(
                      itemCount: reviewsList.length,
                      itemBuilder: (context, index) {
                        final review = reviewsList[index];
                        return _buildReviewItem(review, index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCommentItem(Map<String, dynamic> item, int index) {

    String commentTime = '';

    String replyCommentTime = '';

    // Format the commentTime if it exists
    if (item['commentTime'] != null) {
      final DateTime time = DateTime.parse(item['commentTime']);
      commentTime = DateFormat('MMM dd, yyyy').format(time);
    }

    if (item['replyTime'] != null) {
      final DateTime time = DateTime.parse(item['replyTime']);
      replyCommentTime = DateFormat('MMM dd, yyyy').format(time);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item['userDp'] ?? ''),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${item['userName'] ?? 'Unknown User'} • $commentTime',
              style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold ),
            ),
          ),
          subtitle: Text(item['comment'] ?? ''),
        ),
        if (item['replyComment'] != null)
          Padding(
            padding: const EdgeInsets.only(left: 66.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.groupLogo ?? ''), // Use group image URL here
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.groupName} • $replyCommentTime",
                  style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold ),
                ),
              ),
              subtitle: Text(
                item['replyComment'],
              ),
            ),
          ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //     onPressed: () {
        //       setState(() {
        //         _commentReplyVisible[index] = !_commentReplyVisible[index];
        //       });
        //     },
        //     child: Text("Reply", style: TextStyle(color: Colors.pink, fontSize: 16,fontWeight: FontWeight.bold ),),
        //   ),
        // ),
        if (_commentReplyVisible[index])
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: "Write a reply...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    final replyText = _replyController.text;
                    if (replyText.isNotEmpty) {
                      _replyController.clear();
                      setState(() {
                        _commentReplyVisible[index] = false;
                        item['replyComment'] = replyText; // Update or add replyComment locally
                      });

                      // Send reply to the server
                      sendReply(
                        item['catalogId'],
                        replyText,
                        "comment",
                        item['catalogCommentId'],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        Divider(),
      ],
    );
  }


  Widget _buildReviewItem(Map<String, dynamic> item, int index) {
    int rating = item['rating'] ?? 0; // Assuming rating is an integer from 0 to 5

    String commentTime = '';

    String replyCommentTime = '';

    // Format the commentTime if it exists
    if (item['commentTime'] != null) {
      final DateTime time = DateTime.parse(item['commentTime']);
      commentTime = DateFormat('MMM dd, yyyy').format(time);
    }

    if (item['replyTime'] != null) {
      final DateTime time = DateTime.parse(item['replyTime']);
      replyCommentTime = DateFormat('MMM dd, yyyy').format(time);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item['userDp'] ?? ''),
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${item['userName'] ?? 'Unknown User'} • $commentTime',
              style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating stars
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    Icons.star,
                    color: i < rating ? Colors.amber : Colors.grey,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(height: 4), // Spacing between stars and comment
              Text(item['comment'] ?? ''),
            ],
          ),
        ),
        if (item['replyComment'] != null)
          Padding(
            padding: const EdgeInsets.only(left: 66.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.groupLogo ?? ''), // Use group image URL here
              ),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.groupName} • $replyCommentTime",
                  style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold ),
                ),
              ),
              subtitle: Text(
                item['replyComment'],
              ),
            ),
          ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //     onPressed: () {
        //       setState(() {
        //         _reviewReplyVisible[index] = !_reviewReplyVisible[index];
        //       });
        //     },
        //     child: Text("Reply", style: TextStyle(color: Colors.pink, fontSize: 16,fontWeight: FontWeight.bold ),),
        //   ),
        // ),
        if (_reviewReplyVisible[index])
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: const InputDecoration(
                      hintText: "Write a reply...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final replyText = _replyController.text;
                    if (replyText.isNotEmpty) {
                      _replyController.clear();
                      setState(() {
                        _reviewReplyVisible[index] = false;
                        item['replyComment'] = replyText; // Add or replace replyComment locally
                      });
                      // Send reply to the server
                      sendReply(
                        item['catalogId'],
                        replyText,
                        "review",
                        item['catalogCommentId'],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        const Divider(),
      ],
    );
  }



  void sendReply(int catalogId, String comment,String commentType,int commentId){
    _apiService.postCatalogComments(widget.groupId, widget.userId, catalogId, commentId ,comment, commentType, 0, widget.token);
  }



  @override
  void dispose() {
    _tabController?.dispose();
    _replyController.dispose();
    super.dispose();
  }
}


