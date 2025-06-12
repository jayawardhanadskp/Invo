import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invo/blocs/due/due_bloc.dart';
import 'package:invo/repositories/due_repository.dart';

class DuePage extends StatefulWidget {
  const DuePage({super.key});

  @override
  State<DuePage> createState() => _DuePageState();
}

class _DuePageState extends State<DuePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DueBloc>().add(GetAllDueCount());
    DueRepository().getDueDetailList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 60),

              Text(
                'Due Tracking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF101124),
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    top: BorderSide(color: Color(0xFF454654), width: 2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wallet_rounded, color: Color(0xFFFF3B30)),
                        const SizedBox(width: 10),
                        Text(
                          'Total Credit Outstanding',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<DueBloc, DueState>(
                      builder: (context, state) {
                        if (state is GetAllDueCountSuccess) {
                          return Text(
                            'RS ${state.count}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFFF3B30),
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return Text('-- --');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SearchBar(
                controller: _searchController,
                hintText: 'Search buyers by name ',
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.white, width: 1),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(Color(0xFF101124)),
                textStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF101124),
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF454654), width: 2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buyerDueCard(
                      'Priya Patel',
                      '2000',
                      '+91 9876543211',
                      'Since: 15 Apr 2023',
                    ),
                    _buyerDueCard(
                      'Rahul Sharma',
                      ' 1500',
                      '+91 9876543212',
                      'Since: 10 Apr 2023',
                    ),
                    _buyerDueCard(
                      'Anita Desai',
                      '3000',
                      '+91 9876543213',
                      'Since: 20 Mar 2023',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buyerDueCard(String name, String amount, String phone, String since) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontSize: 14, color: Colors.white)),
              Text(
                'Rs $amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF3B30),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(phone, style: TextStyle(fontSize: 14, color: Colors.white)),
              Text(
                'Since: $since',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _showPaymentDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF272938),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.price_check_sharp,
                        color: Color(0xFF36AE09),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Mark as Paid',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF36AE09),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF272938),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      color: Color(0xFF36AE09),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Notify',
                      style: TextStyle(fontSize: 14, color: Color(0xFF36AE09)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF454654), width: 2),
          ),
          backgroundColor: Color(0xFF101124).withOpacity(0.6),
          title: Center(child: Text('Payment Confirmation')),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter amount paid',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF313341),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  hintText: 'Amount',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            Center(
              child: Container(
                width: 180,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF00480A),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_sharp,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Record Payment  ',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
