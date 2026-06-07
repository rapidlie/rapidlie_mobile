import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/features/contributions/blocs/contribution_bloc/contribution_bloc.dart';

class ContributeScreen extends StatefulWidget {
  final String eventId;
  final String eventName;

  const ContributeScreen(
      {Key? key, required this.eventId, required this.eventName})
      : super(key: key);

  @override
  State<ContributeScreen> createState() => _ContributeScreenState();
}

class _ContributeScreenState extends State<ContributeScreen> {
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  String _network = 'MTN';
  String? _amountError;
  String? _phoneError;

  static const _networks = ['MTN', 'VODAFONE', 'AIRTELTIGO'];

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  bool _validate() {
    final amount = double.tryParse(_amountController.text.trim());
    setState(() {
      _amountError = amount == null || amount < 1 ? 'Enter a valid amount (min 1)' : null;
      _phoneError = _phoneController.text.trim().isEmpty ? 'Phone number is required' : null;
    });
    return _amountError == null && _phoneError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribute'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<ContributionBloc, ContributionState>(
        listener: (context, state) {
          if (state is ContributionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          } else if (state is ContributionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contributing to',
                  style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                ),
                Text(
                  widget.eventName,
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18.sp),
                ),
                const SizedBox(height: 24),
                // Amount
                Text('Amount (GHS)',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14.sp)),
                const SizedBox(height: 8),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                  ],
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixText: 'GHS ',
                    border: const OutlineInputBorder(),
                    errorText: _amountError,
                  ),
                ),
                const SizedBox(height: 16),
                // Network
                Text('Mobile Network',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14.sp)),
                const SizedBox(height: 8),
                Row(
                  children: _networks
                      .map((n) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(n,
                                    style:
                                        TextStyle(fontSize: 11.sp)),
                                selected: _network == n,
                                onSelected: (_) =>
                                    setState(() => _network = n),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                // Phone
                Text('Mobile Money Number',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14.sp)),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: '024XXXXXXX',
                    prefixText: '+233 ',
                    border: const OutlineInputBorder(),
                    errorText: _phoneError,
                  ),
                ),
                const SizedBox(height: 16),
                // Optional message
                Text('Message (optional)',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14.sp)),
                const SizedBox(height: 8),
                TextField(
                  controller: _messageController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Add a note...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 28),
                ButtonTemplate(
                  buttonName: 'Send Contribution',
                  loading: state is ContributionLoading,
                  buttonAction: () {
                    if (_validate()) {
                      context.read<ContributionBloc>().add(SubmitContribution(
                            eventId: widget.eventId,
                            amount: double.parse(
                                _amountController.text.trim()),
                            phone: _phoneController.text.trim(),
                            network: _network,
                            message: _messageController.text.trim(),
                          ));
                    }
                  },
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Payments are processed via Hubtel MoMo',
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
