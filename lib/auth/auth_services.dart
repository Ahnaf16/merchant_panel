import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/auth/employee/employee_model.dart';

import '../widgets/logger.dart';

final authServicesProvider = Provider.autoDispose<AuthServices>((ref) {
  return AuthServices();
});

class AuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  final nameCtrl = TextEditingController();

  final emailCtrl = TextEditingController();

  final passCtrl = TextEditingController();

  Future<void> signUp(String role) async {
    if (emailCtrl.text.isEmpty) {
      EasyLoading.showError('Email is required');
    }
    if (passCtrl.text.isEmpty) {
      EasyLoading.showError('Password is required');
    }
    if (nameCtrl.text.isEmpty) {
      EasyLoading.showError('Name is required');
    }
    if (role.isEmpty) {
      EasyLoading.showError('Role is required');
    } else {
      try {
        EasyLoading.show(status: 'Creating user...');

        final firestore = FirebaseFirestore.instance;

        final ref = firestore.collection('employess');

        final userCred = await auth.createUserWithEmailAndPassword(
          email: emailCtrl.text.trim(),
          password: passCtrl.text.trim(),
        );

        if (userCred.user == null) {
          EasyLoading.showError('Something went wrong');
        } else {
          EasyLoading.show(status: 'User created');

          EasyLoading.show(status: 'Adding Employee to database...');
          final employee = EmployeeModel(
            name: nameCtrl.text.trim(),
            uid: userCred.user!.uid,
            role: role,
            email: emailCtrl.text.trim(),
            password: passCtrl.text.trim(),
          );

          await auth.currentUser!.updateDisplayName(nameCtrl.text.trim());

          EasyLoading.show(status: 'Employee added...');

          await ref.doc(userCred.user!.uid).set(employee.toJson());

          nameCtrl.clear();
          emailCtrl.clear();
          passCtrl.clear();
          EasyLoading.showSuccess('Employee SignUp Successful');
        }
      } on FirebaseAuthException catch (error, st) {
        logger(error: error, st: st);
        EasyLoading.showError(error.message.toString());
      }
    }
  }

  Future<User?> login() async {
    if (emailCtrl.text.isEmpty) {
      EasyLoading.showError('Email is required');
      return null;
    } else if (passCtrl.text.isEmpty) {
      EasyLoading.showError('Password is required');
      return null;
    } else {
      try {
        EasyLoading.show(status: 'Logging in...');

        UserCredential userCred = await auth.signInWithEmailAndPassword(
          email: emailCtrl.text,
          password: passCtrl.text,
        );

        EasyLoading.showSuccess('Login Successful');

        return userCred.user;
      } on FirebaseAuthException catch (e) {
        EasyLoading.showError(
          e.message ?? 'Something went wrong',
        );
        log(e.message.toString());
        return null;
      }
    }
  }

  Future<User?> guestLogin() async {
    try {
      EasyLoading.show(status: 'Logging in as guest...');

      UserCredential userCred = await auth.signInWithEmailAndPassword(
        email: 'guest@mail.com',
        password: '123456',
      );

      EasyLoading.showSuccess('Guest Login Successful');

      return userCred.user;
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(
        e.message ?? 'Something went wrong',
      );
      log(e.message.toString());
      return null;
    }
  }

  logOut() async {
    EasyLoading.show(status: 'Logging out...');
    await auth.signOut();
    EasyLoading.showSuccess('Logout Successful');
  }
}
