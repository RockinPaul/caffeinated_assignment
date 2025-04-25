import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:caffeinated_assignment/constants.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';
import 'package:caffeinated_assignment/bloc/order/order_cubit.dart';
import 'package:caffeinated_assignment/presentation/style_page.dart';
import 'package:caffeinated_assignment/presentation/size_page.dart';
import 'package:caffeinated_assignment/presentation/extras_page.dart';
import 'package:caffeinated_assignment/presentation/overview_page.dart';
import 'package:caffeinated_assignment/presentation/orders_page.dart';

/// Application router configuration
final router = GoRouter(
  initialLocation: '/styles',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) => const OrdersPage(),
    ),
    GoRoute(
      path: '/styles',
      name: 'styles',
      builder: (context, state) => const StylePage(machineId: AppConstants.defaultMachineId),
    ),
    GoRoute(
      path: '/sizes',
      name: 'sizes',
      builder: (context, state) {
        final type = state.extra as CoffeeType;
        return SizePage(machineId: AppConstants.defaultMachineId, type: type);
      },
    ),
    GoRoute(
      path: '/extras',
      name: 'extras',
      builder: (context, state) {
        final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
        final type = extras['type'] as CoffeeType;
        final size = extras['size'] as Size;
        return ExtrasPage(
          machineId: AppConstants.defaultMachineId,
          type: type,
          size: size,
        );
      },
    ),
    GoRoute(
      path: '/overview',
      name: 'overview',
      builder: (context, state) {
        final orderCubit = state.extra as OrderCubit;
        return BlocProvider.value(
          value: orderCubit,
          child: const OverviewPage(),
        );
      },
    ),
  ],
);
