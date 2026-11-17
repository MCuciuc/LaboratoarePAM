import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2/data/repositories/medical_repository.dart';
import 'package:lab2/screens/home_screen.dart';
import 'package:lab2/state/medical_cubit.dart';
import 'package:lab2/core/app_colors.dart';

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => const MedicalRepository(),
      child: BlocProvider(
        create: (context) => MedicalCubit(context.read<MedicalRepository>())..load(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Medical App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
              primary: AppColors.primary,
            ),
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
