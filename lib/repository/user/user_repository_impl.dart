
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:reading_book_4k/model/author.dart';
import 'package:reading_book_4k/repository/user/response_auth.dart';
import 'package:reading_book_4k/repository/user/user_repository.dart';
import 'package:reading_book_4k/services/app_shared_preference.dart';

class UserRepositoryImpl extends UserRepository {

  final FirebaseAuth _firebaseAuth = GetIt.I<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = GetIt.I<FirebaseFirestore>();
  final pref = GetIt.I<AppSharedPreference>();
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<ResponseAuth> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try {
      return ResponseAuth(userCredential: await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ResponseAuth(errorMessage: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return ResponseAuth(errorMessage: 'Wrong password provided for that user.');
      } else {
        return ResponseAuth(errorMessage: e.message);
      }
    } catch (e) {
      return ResponseAuth(errorMessage: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    pref.deleteData('authorId');
    await _firebaseAuth.signOut();
  }
  
  @override
  Future<ResponseAuth> createUserWithEmailAndPassword({
    required String email, 
    required String password
  }) async {
    try {
      final response = ResponseAuth(userCredential: await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password));
      
      
      return response;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ResponseAuth(errorMessage: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ResponseAuth(errorMessage: 'The account already exists for that email.');
      } else {
        return ResponseAuth(errorMessage: e.message);
      }
    } catch (e) {
      return ResponseAuth(errorMessage: e.toString());
    }
  }

  @override
  Future<Author> getMe(String userId) async {
    final snapshot = await _firebaseFirestore.collection('author').get();
    final doc = snapshot.docs.where((element) => element['userId'] == userId);
    Author author = Author.fromQueryDocumentSnapshot(doc.first);
    pref.saveString('authorId', doc.first.id);
    return author;
  }
  
  @override
  Future<Author> getAuthorInfo() async {
    final authorId = pref.getString('authorId');
    final snapshot = await _firebaseFirestore.collection('author').get();
    final doc = snapshot.docs.where((element) => element.id == authorId);
    return Author.fromQueryDocumentSnapshot(doc.first);
  }
  
  @override
  Future<Author> updateAuthorInfo(Author author) async {
    final authorId = pref.getString('authorId');
    final snapshot = await _firebaseFirestore.collection('author').get();
    final doc = snapshot.docs.where((element) => element.id == authorId).first;
    await doc.reference.update(author.toMap());
    return author;
  }

  @override
  Future<Author> addAuthor(User user) async {
    final collectionRef = _firebaseFirestore.collection('author');
    final author = Author(
                          userId: user.uid, 
                          name: user.email!, 
                          email: user.email!, 
                          avatarLink: 'https://firebasestorage.googleapis.com/v0/b/reading-book-1aa02.appspot.com/o/img_holder.jpg?alt=media&token=3bae214a-601f-4b82-8ee4-71189ceb55c1', 
                          favStoryIds: []);
    await collectionRef.add(author.toMap());
    return author;
  }
  
  @override
  Future<bool> addFavStory(String authorId, String storyId) async {
    try {
      final snapshot = await _firebaseFirestore.collection('author').get();
      final doc = snapshot.docs.where((element) => element.id == authorId).first;
      Author author = Author.fromQueryDocumentSnapshot(doc);
      author.favStoryIds.add(storyId);
      await doc.reference.update(author.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> removeFavstory(String authorId, String storyId) async {
    try {
      final snapshot = await _firebaseFirestore.collection('author').get();
      final doc = snapshot.docs.where((element) => element.id == authorId).first;
      Author author = Author.fromQueryDocumentSnapshot(doc);
      author.favStoryIds.remove(storyId);
      await doc.reference.update(author.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<void> resetPassword(String email) { return _firebaseAuth.sendPasswordResetEmail(email: email); }

  
}