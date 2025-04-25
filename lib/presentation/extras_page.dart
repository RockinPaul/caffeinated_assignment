import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caffeinated_assignment/bloc/coffee/coffee_cubit.dart';
import 'package:caffeinated_assignment/bloc/coffee/coffee_state.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';
import 'package:caffeinated_assignment/data/order.dart';
import 'package:caffeinated_assignment/bloc/order/order_cubit.dart';
import 'package:caffeinated_assignment/bloc/order/order_state.dart';
import 'package:caffeinated_assignment/presentation/overview_page.dart';

class ExtrasPage extends StatelessWidget {
  final String machineId;
  final CoffeeType type;
  final Size size;
  const ExtrasPage({super.key, required this.machineId, required this.type, required this.size});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoffeeCubit>(
          create: (_) => CoffeeCubit()..loadExtrasForType(machineId, type),
        ),
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit(initialOrder: Order(type: type, size: size, extras: [])),
        ),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Extras for ${type.name}'),
            centerTitle: false,
          ),
          body: BlocBuilder<CoffeeCubit, CoffeeState>(
            builder: (context, state) {
              if (state is CoffeeInitial || state is CoffeeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CoffeeExtrasLoaded) {
                final extras = state.extras;
                return BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, orderState) {
                    // Safely extract extras from any state
                    final List<Subselection> selectedExtras;
                    if (orderState is OrderUpdated) {
                      selectedExtras = orderState.order.extras;
                    } else if (orderState is OrderInitial) {
                      selectedExtras = orderState.order.extras;
                    } else if (orderState is OrderSubmitting) {
                      selectedExtras = orderState.order.extras;
                    } else if (orderState is OrderSuccess) {
                      selectedExtras = orderState.order.extras;
                    } else {
                      selectedExtras = [];
                    }
                    
                    return ListView.separated(
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: extras.length,
                      itemBuilder: (context, index) {
                        final extra = extras[index];
                        return ExpansionTile(
                          title: Text(extra.name),
                          children: extra.subselections.map((sub) {
                            final isSelected = selectedExtras.any((e) => e.id == sub.id);
                            return ListTile(
                              title: Text(sub.name),
                              trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                              onTap: () {
                                context.read<OrderCubit>().toggleExtra(sub);
                              },
                            );
                          }).toList(),
                        );
                      },
                    );
                  }
                );
              } else if (state is CoffeeError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final orderCubit = context.read<OrderCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: orderCubit,
                    child: const OverviewPage(),
                  ),
                ),
              );
            },
            child: const Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}