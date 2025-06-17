import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:invo/blocs/batch/batch_bloc.dart';
import 'package:invo/blocs/due/due_bloc.dart';
import 'package:invo/blocs/purchase/purchase_bloc.dart';
import 'package:invo/pages/main_page.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String formatCustomDate(DateTime inputDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final input = DateTime(inputDate.year, inputDate.month, inputDate.day);

    if (input == today) {
      return 'Today';
    } else if (input == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(inputDate);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<BatchBloc>().add(GetBatchesEvent());
    context.read<DueBloc>().add(GetAllDueCount());
    context.read<PurchaseBloc>().add(GetPurchaseWithBuyerNameEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            children: [
              // BlocConsumer<AuthBloc, AuthState>(
              //   listener: (context, state) {},

              //   builder: (context, state) {
              //     if (state is AuthLoading) {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //     else if (state is AuthFailure) {
              //       return Center(child: Text('Error: ${state.error}'));
              //     } else if (state is AuthSuccess) {
              //       return Center(child: Text('Welcome ${state.user.email}'));
              //     } else {
              //       return Center(
              //         child: ElevatedButton.icon(
              //           icon: const Icon(Icons.login),
              //           label: const Text('Sign in with Google'),
              //           onPressed: () {
              //             context.read<AuthBloc>().add(SignInWithGoogle());
              //           },
              //         ),
              //       );
              //     }

              //   },
              // ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/svg/notification.svg',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Overview of your Ayurvedic business',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              BlocBuilder<BatchBloc, BatchState>(
                builder: (context, state) {
                  if (state is GetBatchSuccess) {
                    final batch = state.batchList[0];

                    final doubleGrams = double.tryParse(batch.grams) ?? 0;
                    final pieacesMade = doubleGrams * 10;
                    return GridView.count(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.9,
                      children: [
                        _buildDashboardCard(
                          icon: 'assets/svg/total pur.svg',
                          title: 'Total Purchased',
                          subtitle: '${batch.grams}g',
                          onTap: () {},
                        ),
                        _buildDashboardCard(
                          icon: 'assets/svg/pieces made.svg',
                          title: 'Pieces Made',
                          subtitle: pieacesMade.toString().replaceAll('.0', ''),
                          onTap: () {},
                        ),
                        _buildDashboardCard(
                          icon: 'assets/svg/stoke left.svg',
                          title: 'Stock Left',
                          subtitle: batch.pieces.toString(),
                          onTap: () {},
                        ),
                        _buildDashboardCard(
                          icon: 'assets/svg/total sales.svg',
                          title: 'Total Sales',
                          subtitle: 'RS. ${batch.sales}',
                          onTap: () {},
                        ),
                      ],
                    );
                  }
                  return GridView.count(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.9,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Color(0xFF101124),
                        highlightColor: Color(0xFF454654),
                        child: _buildDashboardCard(
                          icon: 'assets/svg/total pur.svg',
                          title: 'Total Purchased',
                          subtitle: '500g',
                          onTap: () {},
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Color(0xFF101124),
                        highlightColor: Color(0xFF454654),
                        child: _buildDashboardCard(
                          icon: 'assets/svg/pieces made.svg',
                          title: 'Pieces Made',
                          subtitle: '50',
                          onTap: () {},
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Color(0xFF101124),
                        highlightColor: Color(0xFF454654),
                        child: _buildDashboardCard(
                          icon: 'assets/svg/stoke left.svg',
                          title: 'Stock Left',
                          subtitle: '3250',
                          onTap: () {},
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Color(0xFF101124),
                        highlightColor: Color(0xFF454654),
                        child: _buildDashboardCard(
                          icon: 'assets/svg/total sales.svg',
                          title: 'Total Sales',
                          subtitle: 'RS. 8750',
                          onTap: () {},
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF101124),
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF454654), width: 2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.wallet_rounded, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                'Credit Due',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<DueBloc, DueState>(
                            builder: (context, state) {
                              if (state is DueDataState &&
                                  state.count != null) {
                                return Text(
                                  'RS. ${state.count}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontFamily: 'Inter_Bold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return Text('-- --');
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () {
                          mainPageKey.currentState?.onItemTapped(4);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB39CD0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          fixedSize: Size(
                            MediaQuery.of(context).size.width,
                            40,
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF01031A),
                            fontFamily: 'Inter_Bold',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Recent Sales',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF101124),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: BlocBuilder<PurchaseBloc, PurchaseState>(
                        builder: (context, state) {
                          if (state is GetPurchaseWithBuyerNameSuccessState) {
                            final saleList = state.recentSales;

                            return ListView.builder(
                              itemCount: saleList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final sale = saleList[index];
                                return _recentSaleCard(
                                  customerName: sale.customerName,
                                  amount: sale.amount,
                                  dateTime: formatCustomDate(sale.dateTime),
                                  paymentMethod: sale.paymentMethod,
                                );
                              },
                            );
                          }
                          return Shimmer.fromColors(
                            baseColor: Color(0xFF101124),
                            highlightColor: Color(0xFF454654),
                            child: _recentSaleCard(
                              customerName: 'customerName',
                              amount: 'amount',
                              dateTime: 'dateTime',
                              paymentMethod: 'paymentMethod',
                            ),
                          );
                        },
                      ),
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

  Widget _recentSaleCard({
    required String customerName,
    required String amount,
    required String dateTime,
    required String paymentMethod,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                customerName,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Inter_Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateTime,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB0B0B0),
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                paymentMethod,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      paymentMethod == 'Cash'
                          ? Color(0xFF3AF300)
                          : Color(0xFFFF8F2C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Color(0xFF101124),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFF454654), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(icon),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter_Bold',
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
