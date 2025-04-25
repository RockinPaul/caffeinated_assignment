import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caffeinated_assignment/bloc/order/order_cubit.dart';
import 'package:caffeinated_assignment/bloc/order/order_state.dart';
import 'package:caffeinated_assignment/data/order.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OrderCubit>().submitOrder();
                  },
                  child: const Text('Submit Order'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}