import 'package:supabase_flutter/supabase_flutter.dart';
import '../posts/post_model.dart';

class PostService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Post>> fetchPosts() async {
    try {
      // Assuming RLS filters by college automatically based on user's college
      // Or we might need to fetch user's college first and filter.
      // For now, let's assume RLS handles it or we fetch all for the college.
      
      // We also need to know if the current user liked the post.
      // This is complex in a single query without a view or function.
      // For simplicity, we'll fetch posts and profiles.
      
      final response = await _supabase
          .from('posts')
          .select('*, profiles(*)')
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  Stream<List<Post>> getPostsStream() {
    return _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .asyncMap((data) async {
      if (data.isEmpty) return <Post>[];

      final userIds = data.map((e) => e['user_id'] as String).toSet().toList();
      final profilesResponse = await _supabase
          .from('profiles')
          .select()
          .in_('id', userIds);
      
      final profilesMap = {
        for (var p in profilesResponse) p['id'] as String: p
      };

      return data.map((postJson) {
        final post = Map<String, dynamic>.from(postJson);
        if (profilesMap.containsKey(post['user_id'])) {
          post['profiles'] = profilesMap[post['user_id']];
        }
        return Post.fromJson(post);
      }).toList();
    });
  }

  Future<List<Story>> fetchStories() async {
    try {
      final response = await _supabase
          .from('stories')
          .select('*, profiles(*)')
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((json) => Story.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching stories: $e');
      return [];
    }
  }

  Future<void> createPost({
    required String title,
    required String description,
    required List<String> tags,
    required String imageUrl,
    required String collegeId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _supabase.from('posts').insert({
      'user_id': user.id,
      'college_id': collegeId,
      'title': title,
      'description': description,
      'tags': tags,
      'image_url': imageUrl,
    });
  }

  Future<void> toggleLike(String postId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // Check if already liked
    final existing = await _supabase
        .from('likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (existing != null) {
      // Unlike
      await _supabase
          .from('likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', user.id);
    } else {
      // Like
      await _supabase.from('likes').insert({
        'post_id': postId,
        'user_id': user.id,
      });
    }
  }

  Future<List<Comment>> fetchComments(String postId) async {
    try {
      final response = await _supabase
          .from('comments')
          .select('*, profiles(*)')
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      final data = response as List<dynamic>;
      return data.map((json) => Comment.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<void> addComment(String postId, String content) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _supabase.from('comments').insert({
      'post_id': postId,
      'user_id': user.id,
      'content': content,
    });
  }
}
