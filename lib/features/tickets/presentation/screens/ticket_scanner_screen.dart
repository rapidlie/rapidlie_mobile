import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rapidlie/features/tickets/blocs/ticket_bloc/ticket_bloc.dart';
import 'package:rapidlie/features/tickets/data/models/ticket_model.dart';

class TicketScannerScreen extends StatefulWidget {
  final String eventId;
  const TicketScannerScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<TicketScannerScreen> createState() => _TicketScannerScreenState();
}

class _TicketScannerScreenState extends State<TicketScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _processing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_processing) return;
    final code = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
    if (code == null) return;
    setState(() => _processing = true);
    context.read<TicketBloc>().add(ValidateTicket(
          ticketCode: code,
          eventId: widget.eventId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Ticket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: BlocListener<TicketBloc, TicketState>(
        listener: (context, state) {
          if (state is TicketValidated) {
            _controller.stop();
            _showResult(context, success: true, ticket: state.ticket);
          } else if (state is TicketValidationFailed) {
            setState(() => _processing = false);
            _showResult(context, success: false, message: state.message);
          }
        },
        child: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
            // Scan frame overlay
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_processing)
              Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: const Text(
                'Point camera at ticket QR code',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context,
      {required bool success, TicketModel? ticket, String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.cancel,
              color: success ? Colors.green : Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              success ? 'Valid Ticket' : 'Invalid Ticket',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (success && ticket != null) ...[
              Text(ticket.event.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(ticket.ticketCode,
                  style: const TextStyle(
                      letterSpacing: 2, color: Colors.grey)),
            ],
            if (!success && message != null)
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (success) {
                context.pop();
              } else {
                setState(() => _processing = false);
                _controller.start();
              }
            },
            child: Text(success ? 'Done' : 'Try Again'),
          ),
        ],
      ),
    );
  }
}
