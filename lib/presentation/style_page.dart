import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:caffeinated_assignment/bloc/coffee/coffee_cubit.dart';
import 'package:caffeinated_assignment/bloc/coffee/coffee_state.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';

class StylePage extends StatelessWidget {
  final String machineId;
  const StylePage({super.key, required this.machineId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoffeeCubit()..loadTypes(machineId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select your style'),
          centerTitle: false,
        ),
        body: BlocBuilder<CoffeeCubit, CoffeeState>(
          builder: (context, state) {
            if (state is CoffeeInitial || state is CoffeeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CoffeeTypesLoaded) {
              final types = state.types;
              return ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemCount: types.length,
                itemBuilder: (context, index) {
                  final type = types[index];
                  return ListTile(
                    title: Text(type.name),
                    onTap: () {
                      context.goNamed('sizes', extra: type);
                    },
                  );
                },
              );
            } else if (state is CoffeeError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}