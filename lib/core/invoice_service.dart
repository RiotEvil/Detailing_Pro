import 'package:flutter/material.dart' show BuildContext;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../l10n/app_localizations.dart';
import 'constants.dart';
import 'order_services.dart';

/// Generates and prints a VAT invoice for an order in the app's current language.
class InvoiceService {
  /// Returns next invoice number and increments the counter.
  static String _nextInvoiceNumber(Box settingsBox, String prefix) {
    final year = DateTime.now().year;
    final key = 'invoiceCounter_$year';
    final current = (settingsBox.get(key) as int?) ?? 0;
    final next = current + 1;
    settingsBox.put(key, next);
    return '$prefix/$year/${next.toString().padLeft(3, '0')}';
  }

  static Future<void> generateAndPrint({
    required BuildContext context,
    required Map orderData,
    required String currency,
  }) async {
    final settingsBox = Hive.box(HiveBoxes.settings);
    final l10n = AppLocalizations.of(context)!;

    // VAT rate
    final vatRate =
        (settingsBox.get('companyVatRate') as num?)?.toDouble() ?? 23.0;
    final vatStr = '${vatRate.toStringAsFixed(0)}%';

    // Company data
    final companyName =
        settingsBox.get('companyName', defaultValue: '')?.toString() ?? '';
    final companyNip =
        settingsBox.get('companyNip', defaultValue: '')?.toString() ?? '';
    final companyRegon =
        settingsBox.get('companyRegon', defaultValue: '')?.toString() ?? '';
    final companyAddress =
        settingsBox.get('companyAddress', defaultValue: '')?.toString() ?? '';
    final companyCity =
        settingsBox.get('companyCity', defaultValue: '')?.toString() ?? '';
    final companyPostalCode =
        settingsBox.get('companyPostalCode', defaultValue: '')?.toString() ??
        '';

    // Order data
    final clientName = orderData['client']?.toString() ?? '-';
    final serviceItems = orderServiceList(orderData);
    final serviceName = serviceItems.isEmpty
        ? '-'
        : (serviceItems.length == 1
              ? serviceItems.first
              : serviceItems.map((item) => '• $item').join('\n'));
    final grossPrice = (orderData['price'] as num?)?.toDouble() ?? 0.0;
    final netPrice = grossPrice / (1 + vatRate / 100);
    final vatAmount = grossPrice - netPrice;

    final invoiceNumber =
        _nextInvoiceNumber(settingsBox, l10n.invoiceNumberPrefix);
    final issueDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
    final serviceDate = _formatOrderDate(orderData);

    // Noto Sans supports all the locales (Latin, Cyrillic, Chinese, Arabic-adjacent).
    // Fall back to built-in Helvetica when offline so the invoice still generates.
    pw.Font fontRegular = pw.Font.helvetica();
    pw.Font fontBold = pw.Font.helveticaBold();
    try {
      fontRegular = await PdfGoogleFonts.notoSansRegular();
      fontBold = await PdfGoogleFonts.notoSansBold();
    } catch (_) {
      // offline or font fetch failed — Helvetica fallback already assigned
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    l10n.invoiceTitle,
                    style: pw.TextStyle(font: fontBold, fontSize: 22),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        invoiceNumber,
                        style: pw.TextStyle(font: fontBold, fontSize: 14),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${l10n.invoiceIssueDateLabel}: $issueDate',
                        style: pw.TextStyle(font: fontRegular, fontSize: 10),
                      ),
                      pw.Text(
                        '${l10n.invoiceServiceDateLabel}: $serviceDate',
                        style: pw.TextStyle(font: fontRegular, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 24),

              // ── Seller / Buyer ───────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _partyBox(
                      title: l10n.invoiceSeller,
                      name: companyName.isEmpty
                          ? l10n.invoiceFillCompanyLabel
                          : companyName,
                      lines: [
                        if (companyAddress.isNotEmpty) companyAddress,
                        if (companyPostalCode.isNotEmpty ||
                            companyCity.isNotEmpty)
                          '$companyPostalCode $companyCity'.trim(),
                        if (companyNip.isNotEmpty)
                          '${l10n.invoicePrimaryIdLabel}: $companyNip',
                        if (companyRegon.isNotEmpty)
                          '${l10n.invoiceSecondaryIdLabel}: $companyRegon',
                      ],
                      fontBold: fontBold,
                      fontRegular: fontRegular,
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: _partyBox(
                      title: l10n.invoiceBuyer,
                      name: clientName,
                      lines: const [],
                      fontBold: fontBold,
                      fontRegular: fontRegular,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 28),

              // ── Items table ──────────────────────────────
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey400,
                  width: 0.5,
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FixedColumnWidth(30),
                  2: const pw.FixedColumnWidth(70),
                  3: const pw.FixedColumnWidth(35),
                  4: const pw.FixedColumnWidth(60),
                  5: const pw.FixedColumnWidth(70),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      _cell(l10n.invoiceDescriptionLabel, fontBold,
                          isHeader: true),
                      _cell(l10n.invoiceQtyLabel, fontBold, isHeader: true),
                      _cell(l10n.invoiceNetPriceLabel, fontBold,
                          isHeader: true),
                      _cell(l10n.invoiceVatPctLabel, fontBold, isHeader: true),
                      _cell(l10n.invoiceVatAmountLabel, fontBold,
                          isHeader: true),
                      _cell(l10n.invoiceGrossPriceLabel, fontBold,
                          isHeader: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _cell(serviceName, fontRegular),
                      _cell('1', fontRegular),
                      _cell('${_fmt(netPrice)} $currency', fontRegular),
                      _cell('${vatRate.toStringAsFixed(0)}%', fontRegular),
                      _cell('${_fmt(vatAmount)} $currency', fontRegular),
                      _cell('${_fmt(grossPrice)} $currency', fontRegular),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 16),

              // ── Totals ───────────────────────────────────
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.SizedBox(
                  width: 240,
                  child: pw.Column(
                    children: [
                      _totalRow(
                        l10n.invoiceNetTotalLabel,
                        '${_fmt(netPrice)} $currency',
                        fontRegular,
                        fontBold,
                      ),
                      _totalRow(
                        l10n.invoiceVatLineLabel(vatStr),
                        '${_fmt(vatAmount)} $currency',
                        fontRegular,
                        fontBold,
                      ),
                      pw.SizedBox(height: 4),
                      _totalRow(
                        l10n.invoiceTotalDueLabel,
                        '${_fmt(grossPrice)} $currency',
                        fontBold,
                        fontBold,
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              // ── Footer ───────────────────────────────────
              pw.Divider(color: PdfColors.grey400),
              pw.Text(
                '${l10n.invoiceIssuedByLabel}: $companyName',
                style: pw.TextStyle(
                  font: fontRegular,
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: '$invoiceNumber.pdf',
    );
  }

  static pw.Widget _partyBox({
    required String title,
    required String name,
    required List<String> lines,
    required pw.Font fontBold,
    required pw.Font fontRegular,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(name, style: pw.TextStyle(font: fontBold, fontSize: 11)),
          ...lines.map(
            (l) => pw.Text(
              l,
              style: pw.TextStyle(font: fontRegular, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _cell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: isHeader ? 9 : 10),
      ),
    );
  }

  static pw.Widget _totalRow(
    String label,
    String value,
    pw.Font labelFont,
    pw.Font valueFont, {
    bool isTotal = false,
  }) {
    return pw.Container(
      decoration: isTotal
          ? const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
              ),
            )
          : null,
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(font: labelFont, fontSize: isTotal ? 11 : 10),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(font: valueFont, fontSize: isTotal ? 11 : 10),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) => v.toStringAsFixed(2);

  static String _formatOrderDate(Map orderData) {
    final date = orderData['scheduledDate'];
    if (date is num) {
      final d = DateTime.fromMillisecondsSinceEpoch(date.toInt());
      return DateFormat('dd.MM.yyyy').format(d);
    }
    return DateFormat('dd.MM.yyyy').format(DateTime.now());
  }
}
