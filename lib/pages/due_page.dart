// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:invo/blocs/due/due_bloc.dart';
import 'package:invo/blocs/whatsapp/whatsapp_bloc.dart';
import 'package:invo/repositories/whatsapp_message_repository.dart';
import 'package:invo/utils/app_snackbars.dart';

class DuePage extends StatefulWidget {
  const DuePage({super.key});

  @override
  State<DuePage> createState() => _DuePageState();
}

class _DuePageState extends State<DuePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final WhatsappMessageRepository _whatsapp = WhatsappMessageRepository();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Future.delayed(Duration(seconds: 3), () {
      context.read<DueBloc>().add(GetAllDueCount());
      // });
      context.read<DueBloc>().add(GetBuyersWithDueList());
    });

    _searchController.addListener(() {
      setState(() {});
    });
  }

  List<dynamic> _filterBuyersWithDue(List<dynamic> buyersList) {
    final queary = _searchController.text.toLowerCase();
    if (queary.isEmpty) return buyersList;
    return buyersList.where((b) {
      final name = b['name']?.toString().toLowerCase() ?? '';

      return name.contains(queary);
    }).toList();
  }

  String formatDate(String? isoDateString) {
    if (isoDateString == null) return 'No Date';

    try {
      final date = DateTime.parse(isoDateString).toLocal();
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.money_outlined,
                    color: Color(0xFFB67CFF),
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Due Tracking',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
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
                        if (state is DueDataState && state.count != null) {
                          // if (state.count != null) {
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
                child: BlocConsumer<DueBloc, DueState>(
                  listener: (context, state) async {
                    if (state is DueDataState && state.payDueSucess != null) {
                      // AppSnackbars.showSucessSnackbar(
                      //   context,
                      //   'Credit Due Saved Sucessfully',
                      // );

                      // await Future.delayed(Duration(microseconds: 300));

                      // if (mounted) {
                      // context.read<DueBloc>().add(GetAllDueCount());
                      // context.read<DueBloc>().add(GetBuyersWithDueList());
                      // }
                    }
                  },
                  builder: (context, state) {
                    if (state is DueDataState && state.isLoadingList == true) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    //else if (state is GetBuyersWithDueListError) {
                    //   return Center(
                    //     child: Text(
                    //       state.message,
                    //       style: TextStyle(color: Colors.red),
                    //     ),
                    //   );
                    // } else
                    if (state is DueDataState && state.dueDetailsList != null) {
                      final buyersList = _filterBuyersWithDue(
                        state.dueDetailsList!,
                      );
                      if (buyersList.isEmpty) {
                        return Center(
                          child: Text(
                            'No buyers found',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: buyersList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final buyer = buyersList[index];
                          return _buyerDueCard(
                            buyer['id'],
                            buyer['name']?.toString() ?? 'Unknown',
                            buyer['totalDue']?.toString() ?? '0',
                            buyer['phone']?.toString() ?? '',
                            formatDate(buyer['firstDueDate']),
                          );
                        },
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buyerDueCard(
    String buyerId,
    String name,
    String amount,
    String phone,
    String since,
  ) {
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
                onTap: () => _showPaymentDialog(buyerId),
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
              BlocListener<WhatsappBloc, WhatsappState>(
                listener: (context, state) {
                  if (state is SendMessageError) {
                    AppSnackbars.showErrorSnackbar(
                      context,
                      'Cannot Open Whatsapp',
                    );
                  }
                },
                child: InkWell(
                  onTap: () {
                    context.read<WhatsappBloc>().add(
                      SendMessage(
                        name: name,
                        amount: amount,
                        phone: phone,
                        since: since,
                      ),
                    );
                  },
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
                          Icons.notifications_none,
                          color: Color(0xFF36AE09),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Notify',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF36AE09),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _showPaymentDialog(String buyerId) {
    showDialog(
      context: context,

      builder: (context) {
        return BlocListener<DueBloc, DueState>(
          listener: (context, state) async {
            if (state is DueDataState && state.payDueSucess != null) {
              AppSnackbars.showSucessSnackbar(
                context,
                'Credit Due Saved Sucessfully',
              );

              await Future.delayed(Duration(microseconds: 300));

              Navigator.pop(context);

              // if (mounted) {
              //   context.read<DueBloc>().add(GetAllDueCount());
              //   context.read<DueBloc>().add(GetBuyersWithDueList());
              // }
            }
          },
          child: AlertDialog(
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
                child: InkWell(
                  onTap: () async {
                    if (_amountController.text.isNotEmpty) {
                      context.read<DueBloc>().add(
                        PayDueEvent(buyerId, int.parse(_amountController.text)),
                      );
                    }
                  },
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
                            'Record Payment',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
