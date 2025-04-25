import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:caffeinated_assignment/bloc/order/order_cubit.dart';
import 'package:caffeinated_assignment/bloc/order/order_state.dart';
import 'package:caffeinated_assignment/bloc/storage/storage_cubit.dart';
import 'package:caffeinated_assignment/bloc/storage/storage_state.dart';
import 'package:caffeinated_assignment/data/order.dart';
import 'package:caffeinated_assignment/constants.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<OrderCubit>()),
        BlocProvider(create: (_) => StorageCubit()),
      ],
      child: BlocListener<StorageCubit, StorageState>(
        listener: (context, state) {
          if (state is StorageOrderSaved) {
            // Navigate to orders page after successful save
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order saved successfully!')),
            );
            context.goNamed('orders');
          } else if (state is StorageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Order Overview'),
          ),
          body: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              // Safely extract order from any state
              final Order order;
              if (state is OrderUpdated) {
                order = state.order;
              } else if (state is OrderInitial) {
                order = state.order;
              } else if (state is OrderSubmitting) {
                order = state.order;
              } else if (state is OrderSuccess) {
                order = state.order;
              } else {
                return const Center(child: Text('Error: Invalid order state'));
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListTile(
                    title: const Text('Coffee Style'),
                    subtitle: Text(order.type.name),
                  ),
                  ListTile(
                    title: const Text('Size'),
                    subtitle: Text(order.size.name),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Extras', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  if (order.extras.isEmpty)
                    const Text('None', style: TextStyle(color: Colors.grey)),
                  ...order.extras.map((sub) => ListTile(
                        title: Text(sub.name),
                        dense: true,
                      )),
                  const SizedBox(height: 24),
                  Center(
                    child: BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, orderState) {
                        return ElevatedButton(
                          onPressed: orderState is OrderSubmitting
                              ? null // Disable button while submitting
                              : () {
                                  final orderCubit = context.read<OrderCubit>();
                                  final storageCubit = context.read<StorageCubit>();
                                  
                                  // First submit the order via OrderCubit
                                  orderCubit.submitOrder();
                                  
                                  // Then save it to storage
                                  if (orderState is OrderUpdated || 
                                      orderState is OrderInitial) {
                                    final order = orderState is OrderUpdated 
                                        ? orderState.order 
                                        : (orderState as OrderInitial).order;
                                        
                                    storageCubit.saveOrder(
                                      order, 
                                      machineId: AppConstants.defaultMachineId,
                                    );
                                  }
                                },
                          child: orderState is OrderSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Submit Order'),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
