import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:invo/blocs/buyer/buyer_bloc.dart';
import 'package:invo/blocs/purchase/purchase_bloc.dart';
import 'package:invo/models/buyer_model.dart';
import 'package:invo/models/purchase_model.dart';

class SellPiecePage extends StatefulWidget {
  const SellPiecePage({super.key});

  @override
  State<SellPiecePage> createState() => _SellPiecePageState();
}

class _SellPiecePageState extends State<SellPiecePage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _selectbuyerController = TextEditingController();
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _buyerNumberController = TextEditingController();
  final TextEditingController _pieceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List searchList = [];

  final List<String> paymentOptions = ['Cash', 'Card', 'Credit'];
  String selectedPaymentOption = 'Cash';

  BuyerModel? selectedBuyer;

  bool isNewBuyer() {
    return _buyerNameController.text.isNotEmpty &&
        _buyerNumberController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    context.read<BuyerBloc>().add(GetBuyersListEvent());

    _searchController.addListener(() {
      setState(() {});
    });

    Future.delayed(Duration.zero, () {
      getBuyerNameById();
    });

    _buyerNameController.addListener(() {
      setState(() {});
    });
  }

  Future<void> getBuyerNameById() async {
    final state = context.read<BuyerBloc>().state;
    if (state is BuyersListLoadedState) {
      final names = state.buyers.map((buyer) => buyer.name).toList();
      setState(() {
        searchList = names;
      });
    } else {
      context.read<BuyerBloc>().stream.listen((state) {
        if (state is BuyersListLoadedState) {
          final names = state.buyers.map((buyer) => buyer.name).toList();
          if (mounted) {
            setState(() {
              searchList = names;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _selectbuyerController.dispose();
    _buyerNameController.dispose();
    _buyerNumberController.dispose();
    _pieceController.dispose();
    _priceController.dispose();

    super.dispose();
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
                'Add New Batch',
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
                  children: [
                    const SizedBox(height: 10),
                    if (_buyerNameController.text.isEmpty) ...[
                      GFSearchBar(
                        controller: _searchController,
                        searchList: searchList,
                        searchQueryBuilder:
                            (query, list) =>
                                list
                                    .where(
                                      (item) => item!
                                          .toString()
                                          .toLowerCase()
                                          .contains(query.toLowerCase()),
                                    )
                                    .toList(),
                        overlaySearchListItemBuilder:
                            (dynamic item) => Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                        onItemSelected: (dynamic item) {
                          print(item);
                          final state = context.read<BuyerBloc>().state;
                          if (state is BuyersListLoadedState) {
                            final buyer = state.buyers.firstWhere(
                              (b) => b.name == item.toString(),
                              orElse: () => BuyerModel(name: '', phone: 0),
                            );
                            setState(() {
                              _selectbuyerController.text = buyer.name;
                              selectedBuyer = buyer;
                            });
                          }

                          if (item == null) {
                            setState(() {
                              selectedBuyer = null;
                            });
                          }
                        },

                        padding: EdgeInsets.all(0),
                      ),

                      const SizedBox(height: 20),
                      if (selectedBuyer != null) ...[
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedBuyer!.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF454654),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '${selectedBuyer!.totalPieces} purchases',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  selectedBuyer!.phone.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            if ((selectedBuyer!.totalDue) > 0)
                              Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Color(0xFFFF3B30),
                                    size: 17,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'RS. ${selectedBuyer!.totalDue} credit due',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFFF3B30),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Buyer',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _selectbuyerController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF313341),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Please select a buyer',
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    if (selectedBuyer == null &&
                        _buyerNameController.text.isEmpty) ...[
                      Text('OR', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 20),
                    ],
                    if (selectedBuyer == null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Buyer',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _buyerNameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF313341),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Please enter name',
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 15),

                          TextFormField(
                            controller: _buyerNumberController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFF313341),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Please enter contact',
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),

                        Row(
                          children:
                              paymentOptions.map((payment) {
                                return Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPaymentOption = payment;
                                      });
                                      print(
                                        'Selected payment option: $payment',
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            selectedPaymentOption == payment
                                                ? Color(0xFFB39CD0)
                                                : Color(0xFF313341),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Color(0xFF454654),
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          payment,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Price & piece',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF313341),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Please enter price ',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _pieceController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF313341),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Please enter piece count',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_pieceController.text.isEmpty ||
                            _pieceController.text == '0') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter a valid piece count.',
                              ),
                            ),
                          );
                          return;
                        }

                        if (isNewBuyer()) {
                          final buyer = BuyerModel(
                            name: _buyerNameController.text,
                            phone: int.parse(_buyerNumberController.text),
                          );

                          final purchase = PurchaseModel(
                            pieces: int.parse(_pieceController.text),
                            amount: int.parse(_priceController.text),
                            paymentType: selectedPaymentOption,
                            paymentStatus:
                                selectedPaymentOption == 'Credit'
                                    ? 'Due'
                                    : 'Paid',
                            purchaseDate: DateTime.now(),
                          );
                          context.read<PurchaseBloc>().add(
                            CreatePurchaseNewBuyerEvent(
                              buyer: buyer,
                              purchase: purchase,
                            ),
                          );
                        } else {
                          final buyer = BuyerModel(
                            id: selectedBuyer!.id,
                            name: selectedBuyer!.name,
                            phone: selectedBuyer!.phone,
                          );

                          final purchase = PurchaseModel(
                            pieces: int.parse(_pieceController.text),
                            amount: int.parse(_priceController.text),
                            paymentType: selectedPaymentOption,
                            paymentStatus:
                                selectedPaymentOption == 'Credit'
                                    ? 'Due'
                                    : 'Paid',
                            purchaseDate: DateTime.now(),
                          );

                          context.read<PurchaseBloc>().add(
                            CreatePurchaseExistingBuyerEvent(
                              buyer: buyer,
                              purchase: purchase,
                            ),
                          );
                        }
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
                        fixedSize: Size(MediaQuery.of(context).size.width, 48),
                      ),
                      child: Text(
                        'Complete Sale',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF01031A),
                          fontFamily: 'Inter_Bold',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFD6FFD8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Stock',
                      style: TextStyle(
                        color: Color(0xFF36AE09),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remaining pieces:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '20',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
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
}
