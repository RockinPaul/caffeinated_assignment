import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caffeinated_assignment/bloc/coffee/coffee_cubit.dart';
import 'package:caffeinated_assignment/bloc/coffee/coffee_state.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';
import 'package:caffeinated_assignment/presentation/extras_page.dart';

class SizePage extends StatelessWidget {
  final String machineId;
  final CoffeeType type;
  const SizePage({super.key, required this.machineId, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoffeeCubit()..loadSizesForType(machineId, type),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select your size'),
          centerTitle: false,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExtrasPage(
                            machineId: machineId,
                            type: type,
                            size: size,
                          ),
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