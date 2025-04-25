import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:caffeinated_assignment/bloc/storage/storage_cubit.dart';
import 'package:caffeinated_assignment/bloc/storage/storage_state.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';
import 'package:caffeinated_assignment/data/order.dart';
import 'package:caffeinated_assignment/constants.dart';
import 'package:caffeinated_assignment/data/api_service.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StorageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order History'),
          actions: [
            BlocBuilder<StorageCubit, StorageState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _loadOrders(context),
                );
              },
            ),
            BlocBuilder<StorageCubit, StorageState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmClearOrders(context),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<StorageCubit, StorageState>(
          builder: (context, state) {
            if (state is StorageInitial) {
              // Load orders when page is first opened
              _loadOrders(context);
              return const Center(child: CircularProgressIndicator());
            } else if (state is StorageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StorageOrdersLoaded) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return const Center(
                  child: Text('No orders found', style: TextStyle(fontSize: 16)),
                );
              }
              return _buildOrdersList(orders);
            } else if (state is StorageOrdersCleared) {
              return const Center(
                child: Text('Orders cleared', style: TextStyle(fontSize: 16)),
              );
            } else if (state is StorageError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${state.message}', style: const TextStyle(fontSize: 16, color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _loadOrders(context),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.type.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateFormat.format(DateTime.now()), // Would use actual timestamp from storage
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Size: ${order.size.name}'),
                const SizedBox(height: 8),
                if (order.extras.isNotEmpty) ...[
                  const Text('Extras:'),
                  const SizedBox(height: 4),
                  ...order.extras.map((extra) => Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text('• ${extra.name}'),
                  )),
                ] else
                  const Text('No extras'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _loadOrders(BuildContext context) async {
    // First fetch the machine to provide context for orders
    try {
      final apiService = ApiService();
      final machine = await apiService.getMachine(AppConstants.defaultMachineId);
      context.read<StorageCubit>().loadOrders(machine);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading machine data: $e')),
        );
      }
    }
  }

  void _confirmClearOrders(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Order History'),
        content: const Text('Are you sure you want to clear all order history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<StorageCubit>().clearOrders();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
