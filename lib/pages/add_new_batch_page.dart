import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invo/blocs/batch/batch_bloc.dart';
import 'package:invo/utils/app_snackbars.dart';

class AddNewBatchPage extends StatefulWidget {
  const AddNewBatchPage({super.key});

  @override
  State<AddNewBatchPage> createState() => _AddNewBatchPageState();
}

class _AddNewBatchPageState extends State<AddNewBatchPage> {
  final TextEditingController _gramsController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  double _pieces = 0;

  bool seeAll = false;

  @override
  void initState() {
    super.initState();
    _gramsController.addListener(_updatePieces);
    context.read<BatchBloc>().add(GetBatchesEvent());
  }

  void _updatePieces() {
    final grams = double.tryParse(_gramsController.text) ?? 0;
    setState(() {
      _pieces = grams * 10;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gramsController.removeListener(_updatePieces);
    _gramsController.dispose();
    _noteController.dispose();
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
                  Icons.add_circle_outline_outlined,
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
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFB39CD0),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset('assets/svg/addnewbatch.svg'),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grams Purchased',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _gramsController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF313341),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Enter grams (e.g. 5)',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pieces Produced (0.1g each)',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF313341),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '${_pieces.toInt()} pieces',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notes (Optional)',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            filled: false,
                            fillColor: Color(0xFF313341),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            hintText: 'Add any additional notes...',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          maxLines: 4,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    BlocConsumer<BatchBloc, BatchState>(
                      listener: (context, state) {
                        if (state is BatchSuccess) {
                          AppSnackbars.showSucessSnackbar(
                            context,
                            'Batch added successfully!',
                          );
                        } else if (state is BatchFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to add batch: ${state.error}',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is BatchLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          onPressed: () {
                            final grams = _gramsController.text;
                            final pieces = _pieces.toInt();
                            final note = _noteController.text;
                            final createAt = DateTime.now();

                            context.read<BatchBloc>().add(
                              CreateBatch(
                                grams: grams,
                                pieces: pieces,
                                note: note,
                                createAt: createAt,
                              ),
                            );
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
                              48,
                            ),
                          ),
                          child: Text(
                            'Add to Inventory',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF01031A),
                              fontFamily: 'Inter_Bold',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Current Inventory',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                seeAll = !seeAll;
                              });
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<BatchBloc, BatchState>(
                        builder: (context, state) {
                          if (state is GetBatchSuccess && state.batchList.isNotEmpty) {
                            final batchList = state.batchList;
                            return ListView.builder(
                              itemCount:
                                  seeAll == false ? 1 : state.batchList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final batch = batchList[index];
                                return currentIntventoryCard(
                                  batch.grams,
                                  batch.pieces,
                                  batch.sales ?? 0,
                                );
                              },
                            );
                          }
                          return const Center(child: Text('No Batchs'));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentIntventoryCard(String grams, int pieces, int sales) {
    final doublegrams = double.tryParse(grams) ?? 0;
    final totalPieces = (doublegrams * 10);
    return Column(
      children: [
        _currentInventoryDetails('Total purchased:', sales.toString()),
        const SizedBox(height: 5),
        _currentInventoryDetails(
          'Total pieces produced:',
          totalPieces.toString().replaceAll('.0', ''),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Remaining stock:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB39CD0),
              ),
            ),
            Text(
              '$pieces pieces',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFB39CD0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Row _currentInventoryDetails(String title, String inventoryCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.white)),
        Text(
          inventoryCount,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }
}
