import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caffeinated_assignment/bloc/coffee_cubit.dart';
import 'package:caffeinated_assignment/bloc/coffee_state.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';

class SizePage extends StatelessWidget {
  final String machineId;
  final CoffeeType type;
  const SizePage({Key? key, required this.machineId, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoffeeCubit()..loadSizesForType(machineId, type),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sizes for ${type.name}'),
        ),
        body: BlocBuilder<CoffeeCubit, CoffeeState>(
          builder: (context, state) {
            if (state is CoffeeInitial || state is CoffeeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CoffeeSizesLoaded) {
              final sizes = state.sizes;
              return ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemCount: sizes.length,
                itemBuilder: (context, index) {
                  final size = sizes[index];
                  return ListTile(
                    title: Text(size.name),
                    onTap: () {
                      // TODO: Navigate to extras page
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