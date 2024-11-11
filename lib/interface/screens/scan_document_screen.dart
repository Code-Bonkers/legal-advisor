import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myapp/interface/custom/widgets/chat_message_widget.dart';
import 'package:myapp/services/gemini_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoading && fileDirectory != "No file selected")
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChatMessage(
                        message: fileDirectory.split('/').last,
                        isMe: true,
                      ),
                    ),
                  if (!isLoading && geminiResult.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChatMessage(message: geminiResult, isMe: false),
                    ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
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
              style: TextButton.styleFrom(
                side: const BorderSide(
                    color: Colors.deepPurple,
                    width: 1.5), // Border color and width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), // Rounded corners
                ),
              ),
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

      await _withLoading(() async {
        setState(() {
          fileDirectory = file.path;
        });

        await _extractText(file.path);

        if (haveText) {
          await _generateGeminiContent(extractedText);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> _extractText(String filePath) async {
    try {
      File file = File(filePath);
      final Uint8List fileBytes = await file.readAsBytes();

      PdfDocument pdfDocument = PdfDocument(inputBytes: fileBytes);

      PdfTextExtractor extractor = PdfTextExtractor(pdfDocument);
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
      final String prompt =
          "$promptText. Return following details: summarize the important points of the legal document in 250 words in a simplified manner. point out high priority clauses of document. point out unclear clauses. point out potential loopholes in the document. Identify any privacy-related concerns and potential loopholes in the document. Provide a legal analysis of compliance with GDPR regulations. Provide any unauthorized activity that taked place without giving permission.";

      final result = await _geminiService
          .generateContent(Content('user', [TextPart(prompt)]));

      setState(() {
        geminiResult = result ?? "No response from Gemini.";
      });
    } catch (e) {
      setState(() {
        geminiResult = "Error generating content: $e";
      });
    }
  }

  Future<void> _withLoading(Future<void> Function() action) async {
    setState(() => isLoading = true);
    await action();
    setState(() => isLoading = false);
  }
}
