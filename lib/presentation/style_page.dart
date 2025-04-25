import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caffeinated_assignment/bloc/coffee_cubit.dart';
import 'package:caffeinated_assignment/bloc/coffee_state.dart';
import 'package:caffeinated_assignment/presentation/size_page.dart';
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
          title: const Text('Coffee Styles'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SizePage(machineId: machineId, type: type),
                        ),
                      );
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