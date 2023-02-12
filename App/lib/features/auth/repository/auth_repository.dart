import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/firebase_constents.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/typedef.dart';
import '../../../models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    // Now we are using provider for firebase instance as well insted of creating like FirebaseFirestore.instance
    // How I am going to use Firebase provers into this provider?, that is that **ref** is for
    // ref allows us to talk with other providers. IT provides us many methods ref.Read() & ref.Watch most is most important
    // ref.read is usually used out side of build Context means you don't want to read any changes mad in providers
    firestore: ref.read(
        firestoreProvider), //It gives the instance if firebaseFirestore class
    auth: ref.read(
        authProvider), // It all provers coming from firebase_providers.dart
    googleSignIn: ref.read(googleSignInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      // Since variables are private we can't access it by using this. keyword  insted of that we are creating an instance of it and assigning to the private variables
      {required FirebaseAuth auth,
      required FirebaseFirestore firestore,
      required GoogleSignIn googleSignIn})
      : _auth = auth, // assigning to private variables
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      //We are handling errors here but we going to throw them in controller part later on
      UserCredential userCredential;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);

      UserModel userModel;
      // _firestore.collection('User').doc(userCredential.user!.email).set({''})  // We not going to store data like this insted we will create a User model means how the user will look like
      if (userCredential.additionalUserInfo!.isNewUser) {
        // If User is Logging for first time
        userModel = UserModel(
          name: userCredential.user!.displayName ?? ' No Name',
          email: userCredential.user!.email ?? 'Email not Available',
          isAuthenticated: true,
        );
        await _users.doc(userCredential.user!.email).set(userModel.toMap());
      } else {
        // If user already logged In logging In second time
        userModel =
            await getUserData(userCredential.user!.email.toString()).first;
      }
      // _firestore.collection('User');
      return right(userModel); // Passing success  and userModel
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      // If any error occur din above code
      // ScaffoldMessenger(child: ,) // for this I need context and I don;t want to use context in this class for this we have authController class
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
