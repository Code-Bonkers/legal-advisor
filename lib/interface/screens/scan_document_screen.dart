import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myapp/interface/custom/widgets/chat_message_widget.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';  // For PDF text extraction
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../services/gemini_service.dart';

class ScanDocumentsScreen extends StatefulWidget {
  const ScanDocumentsScreen({super.key});

  @override
  State<ScanDocumentsScreen> createState() => _ScanDocumentsScreenState();
}

class _ScanDocumentsScreenState extends State<ScanDocumentsScreen> {
  String fileDirectory = "No file selected";
  bool haveText = false;
  String extractedText = "";
  String geminiResult = "";
  bool isLoading = false;

  final GeminiService _geminiService = GeminiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator(),
              if (!isLoading && geminiResult.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChatMessage(message: geminiResult, isMe: false)
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  geminiResult = "";
                  haveText = false;
                });
              },
              child: const Text('Clear'),
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

      setState(() {
        fileDirectory = file.path;
        isLoading = true;
      });

      // Extract text from PDF
      await _extractText(file.path);

      if (haveText) {
        // Send extracted text to Gemini API
        await _generateGeminiContent(extractedText);
      }

      setState(() {
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _extractText(String filePath) async {
    try {
      // Read file from the file system
      File file = File(filePath);
      final Uint8List fileBytes = await file.readAsBytes();

      // Load the PDF document
      PdfDocument _pdfDocument = PdfDocument(inputBytes: fileBytes);

      // Extract text
      PdfTextExtractor extractor = PdfTextExtractor(_pdfDocument);
      String text = extractor.extractText();

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
      setState(() {
        extractedText = "Error extracting text: $e";
        haveText = false;
      });
    }
  }

  Future<void> _generateGeminiContent(String promptText) async {
    try {
      // Create content object (modify this as per your model's expected input)
      final String prompt = promptText;

      // Call the Gemini API to generate content
      final result = await _geminiService.generateContent(Content('user',[TextPart(prompt)]));

      setState(() {
        geminiResult = result ?? "No response from Gemini.";
      });
    } catch (e) {
      setState(() {
        geminiResult = "Error generating content: $e";
      });
    }
  }
}
