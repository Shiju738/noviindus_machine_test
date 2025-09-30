import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/branch_model.dart';
import '../models/treatment_model.dart';
import '../helpers/image_paths.dart';

class PdfService {
  // Alternative method that returns PDF bytes for manual handling
  static Future<Uint8List> generatePatientBookingPDFBytes({
    required String patientName,
    required String patientAddress,
    required String patientPhone,
    required String bookingDate,
    required String treatmentDate,
    required String treatmentTime,
    required BranchModel branch,
    required List<TreatmentModel> treatments,
    required int maleCount,
    required int femaleCount,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
  }) async {
    try {
      // Load logo image
      Uint8List? logoBytes;
      try {
        logoBytes = await _loadLogoImage();
      } catch (e) {
        log('Could not load logo image: $e');
      }

      // Load signature image
      Uint8List? signatureBytes;
      try {
        signatureBytes = await _loadSignatureImage();
      } catch (e) {
        log('Could not load signature image: $e');
      }

      // Create PDF document
      final pdf = pw.Document();

      // Add page to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildPDFContent(
              patientName: patientName,
              patientAddress: patientAddress,
              patientPhone: patientPhone,
              bookingDate: bookingDate,
              treatmentDate: treatmentDate,
              treatmentTime: treatmentTime,
              branch: branch,
              treatments: treatments,
              maleCount: maleCount,
              femaleCount: femaleCount,
              totalAmount: totalAmount,
              discountAmount: discountAmount,
              advanceAmount: advanceAmount,
              balanceAmount: balanceAmount,
              logoBytes: logoBytes,
              signatureBytes: signatureBytes,
            );
          },
        ),
      );

      // Return PDF bytes
      return await pdf.save();
    } catch (e) {
      log('Error generating PDF bytes: $e');
      rethrow;
    }
  }

  static Future<void> generatePatientBookingPDF({
    required String patientName,
    required String patientAddress,
    required String patientPhone,
    required String bookingDate,
    required String treatmentDate,
    required String treatmentTime,
    required BranchModel branch,
    required List<TreatmentModel> treatments,
    required int maleCount,
    required int femaleCount,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
  }) async {
    try {
      // Load logo image
      Uint8List? logoBytes;
      try {
        logoBytes = await _loadLogoImage();
      } catch (e) {
        log('Could not load logo image: $e');
      }

      // Load signature image
      Uint8List? signatureBytes;
      try {
        signatureBytes = await _loadSignatureImage();
      } catch (e) {
        log('Could not load signature image: $e');
      }

      // Create PDF document
      final pdf = pw.Document();

      // Add page to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return _buildPDFContent(
              patientName: patientName,
              patientAddress: patientAddress,
              patientPhone: patientPhone,
              bookingDate: bookingDate,
              treatmentDate: treatmentDate,
              treatmentTime: treatmentTime,
              branch: branch,
              treatments: treatments,
              maleCount: maleCount,
              femaleCount: femaleCount,
              totalAmount: totalAmount,
              discountAmount: discountAmount,
              advanceAmount: advanceAmount,
              balanceAmount: balanceAmount,
              logoBytes: logoBytes,
              signatureBytes: signatureBytes,
            );
          },
        ),
      );

      // Try to save PDF to device (with fallback)
      try {
        await _savePDFToDevice(pdf, patientName);
      } catch (e) {
        log('Warning: Could not save PDF to device: $e');
      }

      // Show PDF preview (with fallback)
      try {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
          name: 'Patient_Booking_${patientName.replaceAll(' ', '_')}.pdf',
        );
      } catch (e) {
        log('PDF generated successfully but preview not available');
      }
    } catch (e) {
      rethrow;
    }
  }

  static pw.Widget _buildPDFContent({
    required String patientName,
    required String patientAddress,
    required String patientPhone,
    required String bookingDate,
    required String treatmentDate,
    required String treatmentTime,
    required BranchModel branch,
    required List<TreatmentModel> treatments,
    required int maleCount,
    required int femaleCount,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    Uint8List? logoBytes,
    Uint8List? signatureBytes,
  }) {
    return pw.Stack(
      children: [
        // Watermark background
        pw.Positioned.fill(
          child: pw.Opacity(
            opacity: 0.1,
            child: pw.Center(
              child: pw.Container(
                width: 200,
                height: 200,
                decoration: pw.BoxDecoration(
                  color: PdfColors.green,
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Center(
                  child: pw.Text(
                    'AM',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 60,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Main content
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(branch, logoBytes),

              pw.SizedBox(height: 25),

              // Patient Details Section
              _buildPatientDetails(
                patientName: patientName,
                patientAddress: patientAddress,
                patientPhone: patientPhone,
                bookingDate: bookingDate,
                treatmentDate: treatmentDate,
                treatmentTime: treatmentTime,
              ),

              pw.SizedBox(height: 25),

              // Treatment Details Table
              _buildTreatmentTable(
                treatments: treatments,
                maleCount: maleCount,
                femaleCount: femaleCount,
              ),
              pw.SizedBox(height: 8),
              // Dashed line separator
              pw.Container(
                width: double.infinity,
                height: 1,
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(
                      color: PdfColors.grey,
                      width: 0.5,
                      style: pw.BorderStyle.dashed,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 25),

              // Summary Section
              _buildSummarySection(
                totalAmount: totalAmount,
                discountAmount: discountAmount,
                advanceAmount: advanceAmount,
                balanceAmount: balanceAmount,
                signatureBytes: signatureBytes,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildHeader(BranchModel branch, Uint8List? logoBytes) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        // Logo from assets or fallback
        pw.Container(
          width: 60,
          height: 60,
          child: logoBytes != null
              ? pw.Image(
                  pw.MemoryImage(logoBytes),
                  width: 60,
                  height: 60,
                  fit: pw.BoxFit.contain,
                )
              : pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      'AM',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),

        // Branch Information
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'KUMARAKOM',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              'Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey900),
            ),
            pw.Text(
              'e-mail: unknown@gmail.com',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey900),
            ),
            pw.Text(
              'Mob: +91 9876543210 | +91 9786543210',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey900),
            ),

            pw.Text(
              'GST No: 32AABCU9603R1ZW',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey900),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildPatientDetails({
    required String patientName,
    required String patientAddress,
    required String patientPhone,
    required String bookingDate,
    required String treatmentDate,
    required String treatmentTime,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Patient Details',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Name', patientName),
                  _buildDetailRow('Address', patientAddress),
                  _buildDetailRow('WhatsApp Number', patientPhone),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Booked On', bookingDate),
                  _buildDetailRow('Treatment Date', treatmentDate),
                  _buildDetailRow('Treatment Time', treatmentTime),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTreatmentTable({
    required List<TreatmentModel> treatments,
    required int maleCount,
    required int femaleCount,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Dotted line separator (simulated using dashed line with short dashes)
        pw.SizedBox(height: 8),
        // Dashed line separator
        pw.Container(
          width: double.infinity,
          height: 1,
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                color: PdfColors.grey,
                width: 0.5,
                style: pw.BorderStyle.dashed,
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Treatment',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green,
          ),
        ),
        pw.SizedBox(height: 8),

        // Custom table-like layout without TableRow
        pw.Column(
          children: [
            // Header row
            _buildCustomTableHeader(),

            // Treatment rows
            for (var treatment in treatments)
              _buildCustomTableRow(
                treatment: treatment,
                maleCount: maleCount,
                femaleCount: femaleCount,
              ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCustomTableHeader() {
    return pw.Container(
      decoration: const pw.BoxDecoration(color: PdfColors.green),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          _buildCustomTableCell('Treatment', isHeader: true, flex: 3),
          _buildCustomTableCell('Price', isHeader: true, flex: 1.5),
          _buildCustomTableCell('Male', isHeader: true, flex: 1),
          _buildCustomTableCell('Female', isHeader: true, flex: 1),
          _buildCustomTableCell('Total', isHeader: true, flex: 1.5),
        ],
      ),
    );
  }

  static pw.Widget _buildCustomTableRow({
    required TreatmentModel treatment,
    required int maleCount,
    required int femaleCount,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.white, width: 0.5),
        ),
      ),
      child: pw.Row(
        children: [
          _buildCustomTableCell(treatment.name, flex: 3),
          _buildCustomTableCell(treatment.price.toStringAsFixed(0), flex: 1.5),
          _buildCustomTableCell(maleCount.toString(), flex: 1),
          _buildCustomTableCell(femaleCount.toString(), flex: 1),
          _buildCustomTableCell(
            (treatment.price * (maleCount + femaleCount)).toStringAsFixed(0),
            flex: 1.5,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCustomTableCell(
    String text, {
    bool isHeader = false,
    required double flex,
  }) {
    return pw.Expanded(
      flex: (flex * 10).round(), // Convert to integer for flex
      child: pw.Container(
        color: isHeader ? PdfColors.white : PdfColors.white,
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: isHeader ? PdfColors.green : PdfColors.black,
            font: isHeader
                ? null
                : pw.Font.helvetica(), // Use Helvetica for better rupee symbol support
          ),
          textAlign: isHeader
              ? pw.TextAlign.center
              : (text.startsWith('₹') ? pw.TextAlign.right : pw.TextAlign.left),
        ),
      ),
    );
  }

  static pw.Widget _buildSummarySection({
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    required Uint8List? signatureBytes,
  }) {
    return pw.Container(
      width: double.infinity,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Container(
            width: 200, // Fixed width for better alignment
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                _buildSummaryRow('Total Amount', totalAmount, isBold: true),
                _buildSummaryRow('Discount', discountAmount),
                _buildSummaryRow('Advance', advanceAmount),

                pw.SizedBox(height: 5),
                _buildSummaryRow('Balance', balanceAmount, isBold: true),
                pw.SizedBox(height: 30),

                // Footer Section
                _buildFooter(signatureBytes: signatureBytes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
          pw.Text(
            amount.toStringAsFixed(0),
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              font: pw
                  .Font.helvetica(), // Use Helvetica for better rupee symbol support
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter({Uint8List? signatureBytes}) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.SizedBox(height: 20),
        pw.Text(
          'Thank you for choosing us',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Your well-being is our commitment, and were honoredyou ve entrusted us with your health journey',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
          textAlign: pw.TextAlign.center,
        ),
        _buildSignatureSection(signatureBytes: signatureBytes),
      ],
    );
  }

  static pw.Widget _buildSignatureSection({Uint8List? signatureBytes}) {
    if (signatureBytes != null) {
      return pw.Column(
        children: [
          pw.Image(
            pw.MemoryImage(signatureBytes),
            width: 120,
            height: 40,
            fit: pw.BoxFit.contain,
          ),
        ],
      );
    } else {
      // Fallback if signature image is not available
      return pw.Text(
        'Signature',
        style: pw.TextStyle(
          fontSize: 10,
          color: PdfColors.grey,
          fontStyle: pw.FontStyle.italic,
        ),
        textAlign: pw.TextAlign.center,
      );
    }
  }

  // Load logo image from assets
  static Future<Uint8List> _loadLogoImage() async {
    try {
      final ByteData data = await rootBundle.load(ImagePaths.logo);
      return data.buffer.asUint8List();
    } catch (e) {
      log('Error loading logo image: $e');
      throw Exception('Failed to load logo image');
    }
  }

  // Load signature image from assets
  static Future<Uint8List?> _loadSignatureImage() async {
    try {
      final ByteData data = await rootBundle.load(ImagePaths.signature);
      return data.buffer.asUint8List();
    } catch (e) {
      log('Error loading signature image: $e');
      return null; // Return null instead of throwing exception
    }
  }

  static Future<void> _savePDFToDevice(
    pw.Document pdf,
    String patientName,
  ) async {
    try {
      // Request storage permission
      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        log('Storage permission not granted, skipping file save');
        return;
      }

      // Try to get application documents directory
      Directory? directory;
      try {
        directory = await getApplicationDocumentsDirectory();
      } catch (e) {
        log('Could not get application documents directory: $e');
        // Fallback to external storage
        try {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
        } catch (e2) {
          log('Could not access external storage: $e2');
          return;
        }
      }

      final fileName =
          'Patient_Booking_${patientName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      // Convert PDF to bytes
      final pdfBytes = await pdf.save();
      await file.writeAsBytes(pdfBytes);
      log('PDF saved to: ${file.path}');
    } catch (e) {
      log('Error saving PDF: $e');
      // Don't rethrow - this is a non-critical operation
    }
  }
}
