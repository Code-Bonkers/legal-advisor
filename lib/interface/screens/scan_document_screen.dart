import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';  // Ensure you have syncfusion_flutter_pdf installed

class ScanDocumentsScreen extends StatefulWidget {
  const ScanDocumentsScreen({super.key});

  @override
  State<ScanDocumentsScreen> createState() => _ScanDocumentsScreenState();
}

class _ScanDocumentsScreenState extends State<ScanDocumentsScreen> {
  String fileDirectory = "No file selected";
  bool haveText = false;
  String extractedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(fileDirectory, textAlign: TextAlign.center),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickFile(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.upload_file_rounded),
                        SizedBox(width: 8),
                        Text('Upload'),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      fileDirectory = "No file selected";
                      extractedText = "";
                      haveText = false;
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            if (haveText)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  extractedText,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else if (fileDirectory != "No file selected")
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No text extracted from PDF."),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // Update the state with file directory
      setState(() {
        fileDirectory = file.path;
      });

      // Extract text from the PDF
      await _extractText(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _extractText(String filePath) async {
    try {
      // Read the file from the file system, not assets
      File file = File(filePath);
      final Uint8List fileBytes = await file.readAsBytes();

      // Load the PDF document
      PdfDocument _pdfDocument = PdfDocument(inputBytes: fileBytes);

      // Extract text from the PDF
      PdfTextExtractor extractor = PdfTextExtractor(_pdfDocument);
      String text = extractor.extractText();

      // Check if text was extracted
      setState(() {
        if (text.isNotEmpty) {
          extractedText = text;
          haveText = true;
        } else {
          extractedText = "No text extracted from the PDF.";
          haveText = false;
        }
      });
    } catch (e) {
      // Handle any errors (e.g., invalid PDF file)
      setState(() {
        extractedText = "Error extracting text: $e";
        haveText = false;
      });
    }
  }
}
