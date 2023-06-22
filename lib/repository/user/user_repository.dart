import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_book_4k/repository/user/response_auth.dart';

import '../../model/author.dart';

abstract class UserRepository {
  Future<ResponseAuth> signInWithEmailAndPassword({required String email, required String password});
  Future<void> signOut();
  Future<ResponseAuth> createUserWithEmailAndPassword({required String email, required String password});
  Future<Author> getMe(String userId);
  Future<Author> getAuthorInfo();
  Future<Author> updateAuthorInfo(Author author);
  Future<Author> addAuthor(User user);
  Future<bool> addFavStory(String authorId, String storyId);
  Future<bool> removeFavstory(String authorId, String storyId);
  Future<void> resetPassword(String email);
}