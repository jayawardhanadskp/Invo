import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:invo/blocs/purchase/purchase_bloc.dart';
import 'package:invo/models/recent_sale_model.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final List<String> _tabs = ['Day', 'Week', 'Month'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    
    context.read<PurchaseBloc>().add(GetPurchaseWithBuyerNameEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 60),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Color(0xFFB67CFF),
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  'Sales Analytics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Custom Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF101124),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                tabs: List.generate(_tabs.length, (i) {
                  final bool isSelected = _currentIndex == i;
                  return Tab(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 00),
                      width: double.infinity,
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [Color(0xFFB67CFF), Color(0xFF9B59B6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Color(0xFFB67CFF).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _tabs[i],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                padding: EdgeInsets.all(0),
              ),
            ),

            const SizedBox(height: 30),

            // Chart Content
            SizedBox(
              height: 400,
              child: BlocBuilder<PurchaseBloc, PurchaseState>(
                builder: (context, state) {
                  if (state is GetPurchaseWithBuyerNameLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB67CFF)),
                      ),
                    );
                  }
                  
                  if (state is GetPurchaseWithBuyerNameErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error loading data',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Text(
                            state.error,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (state is GetPurchaseWithBuyerNameSuccessState) {
                    return TabBarView(
                      controller: _tabController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        // Daily Bar Chart
                        _buildDailyChart(state.recentSales),
                        // Weekly Line Chart
                        _buildWeeklyChart(state.recentSales),
                        // Monthly Line Chart
                        _buildMonthlyChart(state.recentSales),
                      ],
                    );
                  }
                  
                  return Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChart(List<RecentSale> sales) {
    final dailyData = _processDailyData(sales);
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: Color(0xFFB67CFF), size: 24),
              SizedBox(width: 10),
              Text(
                'Daily Sales (Last 7 Days)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: dailyData.values.isNotEmpty ? 
                      dailyData.values.reduce((a, b) => a > b ? a : b) * 1.2 : 100,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    // tooltipBgColor: Color(0xFF2A2A3E),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()} pieces',
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final keys = dailyData.keys.toList();
                        if (value.toInt() < keys.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              keys[value.toInt()],
                              style: TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: dailyData.entries.map((entry) {
                  final index = dailyData.keys.toList().indexOf(entry.key);
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        gradient: LinearGradient(
                          colors: [Color(0xFFB67CFF), Color(0xFF9B59B6)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 25,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(List<RecentSale> sales) {
    final weeklyData = _processWeeklyData(sales);
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Color(0xFF00D4AA), size: 24),
              SizedBox(width: 10),
              Text(
                'Weekly Sales Trend',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final keys = weeklyData.keys.toList();
                        if (value.toInt() < keys.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              keys[value.toInt()],
                              style: TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: weeklyData.length.toDouble() - 1,
                minY: 0,
                maxY: weeklyData.values.isNotEmpty ? 
                      weeklyData.values.reduce((a, b) => a > b ? a : b) * 1.2 : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklyData.entries.map((entry) {
                      final index = weeklyData.keys.toList().indexOf(entry.key);
                      return FlSpot(index.toDouble(), entry.value);
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00D4AA), Color(0xFF007991)],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Color(0xFF00D4AA),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF00D4AA).withOpacity(0.3),
                          Color(0xFF007991).withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    // tooltipBgColor: Color(0xFF2A2A3E),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.round()} pieces',
                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart(List<RecentSale> sales) {
    final monthlyData = _processMonthlyData(sales);
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: Color(0xFFFF6B6B), size: 24),
              SizedBox(width: 10),
              Text(
                'Monthly Sales Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final keys = monthlyData.keys.toList();
                        if (value.toInt() < keys.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              keys[value.toInt()],
                              style: TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: monthlyData.length.toDouble() - 1,
                minY: 0,
                maxY: monthlyData.values.isNotEmpty ? 
                      monthlyData.values.reduce((a, b) => a > b ? a : b) * 1.2 : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: monthlyData.entries.map((entry) {
                      final index = monthlyData.keys.toList().indexOf(entry.key);
                      return FlSpot(index.toDouble(), entry.value);
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Color(0xFFFF6B6B),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF6B6B).withOpacity(0.3),
                          Color(0xFFFF8E53).withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    // tooltipBgColor: Color(0xFF2A2A3E),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.round()} pieces',
                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _processDailyData(List<RecentSale> sales) {
    final Map<String, double> dailyData = {};
    final now = DateTime.now();
    
    // Initialize last 7 days with 0
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateFormat('MM/dd').format(date);
      dailyData[dateKey] = 0;
    }
    
    // Group sales by day and sum pieces
    for (final sale in sales) {
      final saleDate = sale.dateTime;
      final dateKey = DateFormat('MM/dd').format(saleDate);
      
      if (dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = (dailyData[dateKey] ?? 0) + (sale.pieces ?? 0);
      }
    }
    
    return dailyData;
  }

  Map<String, double> _processWeeklyData(List<RecentSale> sales) {
    final Map<String, double> weeklyData = {};
    final now = DateTime.now();
    
    // Initialize last 8 weeks with 0
    for (int i = 7; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (i * 7)));
      final weekKey = 'W${DateFormat('MM/dd').format(weekStart)}';
      weeklyData[weekKey] = 0;
    }
    
    // Group sales by week and sum pieces
    for (final sale in sales) {
      final saleDate = sale.dateTime;
      final weekStart = saleDate.subtract(Duration(days: saleDate.weekday - 1));
      final weekKey = 'W${DateFormat('MM/dd').format(weekStart)}';
      
      if (weeklyData.containsKey(weekKey)) {
        weeklyData[weekKey] = (weeklyData[weekKey] ?? 0) + (sale.pieces ?? 0);
      }
    }
    
    return weeklyData;
  }

  Map<String, double> _processMonthlyData(List<RecentSale> sales) {
    final Map<String, double> monthlyData = {};
    final now = DateTime.now();
    
    // Initialize last 6 months with 0
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = DateFormat('MMM').format(month);
      monthlyData[monthKey] = 0;
    }
    
    // Group sales by month and sum pieces
    for (final sale in sales) {
      final saleDate = sale.dateTime;
      final monthKey = DateFormat('MMM').format(saleDate);
      
      if (monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + (sale.pieces ?? 0);
      }
    }
    
    return monthlyData;
  }
}