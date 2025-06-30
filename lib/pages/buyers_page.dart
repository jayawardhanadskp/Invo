import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invo/blocs/buyer/buyer_bloc.dart';
import 'package:invo/models/buyer_model.dart';

class BuyersPage extends StatefulWidget {
  const BuyersPage({super.key});

  @override
  State<BuyersPage> createState() => _BuyersPageState();
}

class _BuyersPageState extends State<BuyersPage> {
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    context.read<BuyerBloc>().add(GetBuyersListEvent());

    _searchController.addListener(() {
      setState(() {});
    });
  }

  List<BuyerModel> _filterBuyers(List<BuyerModel> buyers) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return buyers;
    return buyers.where((b) => b.name.toLowerCase().contains(query)).toList();
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
                  Icons.group,
                  color: Color(0xFFB67CFF),
                  size: 28,
                ),
                const SizedBox(width: 10),
                  Text(
                    'Add New Batch',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              SearchBar(
                controller: _searchController,
                hintText: 'Search buyers by name ',
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(Color(0xFF101124)),
                textStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.white, fontSize: 16),
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
                child: BlocBuilder<BuyerBloc, BuyerState>(
                  builder: (context, state) {
                    if (state is BuyerLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is BuyerErrorState) {
                      return Center(
                        child: Text(
                          'Error: ${state.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is BuyersListLoadedState) {
                      final buyers = _filterBuyers(state.buyers);

                      if (buyers.isEmpty) {
                        return Center(
                          child: Text(
                            'No buyers found',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: buyers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final buyer = buyers[index];
                          return _buyerDetailsCard(
                            buyer.name,
                            buyer.totalPieces,
                            buyer.phone,
                            buyer.totalDue,
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

  Widget _buyerDetailsCard(String name, int pieces, int phone, int creditDue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontSize: 15, color: Colors.white)),
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF8DEB92),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${pieces.toString()} purchases',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.phone_outlined, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                phone.toString(),
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 5),
          creditDue == 0
              ? SizedBox()
              : Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFFF3B30),
                    size: 17,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'RS. $creditDue credit due',
                    style: TextStyle(fontSize: 13, color: Color(0xFFFF3B30)),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
