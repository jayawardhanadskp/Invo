import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invo/blocs/auth/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Map<String, String>> sampleSales = [
  {
    'customerName': 'Amit Sharma',
    'amount': 'RS 2100',
    'dateTime': 'Today, 2:30 PM',
    'paymentMethod': 'Cash',
  },
  {
    'customerName': 'Priya Verma',
    'amount': 'RS 1500',
    'dateTime': 'Yesterday, 5:00 PM',
    'paymentMethod': 'Cash',
  },
  {
    'customerName': 'Ravi Kumar',
    'amount': 'RS 3200',
    'dateTime': 'Today, 11:00 AM',
    'paymentMethod': 'Card',
  },
];


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
              const SizedBox(height: 80),
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
        
              GridView.count(
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
                    subtitle: '500g',
                    onTap: () {},
                  ),
                  _buildDashboardCard(
                    icon: 'assets/svg/pieces made.svg',
                    title: 'Pieces Made',
                    subtitle: '50',
                    onTap: () {},
                  ),
                  _buildDashboardCard(
                    icon: 'assets/svg/stoke left.svg',
                    title: 'Stock Left',
                    subtitle: '3250',
                    onTap: () {},
                  ),
                  _buildDashboardCard(
                    icon: 'assets/svg/total sales.svg',
                    title: 'Total Sales',
                    subtitle: 'RS. 8750',
                    onTap: () {},
                  ),
                ],
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
                          Text(
                            'RS. 2100',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontFamily: 'Inter_Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
        
                      const SizedBox(height: 10),
        
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB39CD0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          fixedSize: Size(MediaQuery.of(context).size.width, 40),
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
                      child: ListView.builder(
                        itemCount: sampleSales.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                        final sale = sampleSales[index];
                        return _recentSaleCard(
                          customerName: sale['customerName']!,
                          amount: sale['amount']!,
                          dateTime: sale['dateTime']!,
                          paymentMethod: sale['paymentMethod']!,
                        );
                      },),
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
