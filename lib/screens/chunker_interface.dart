import 'package:atri/services/chunker_service.dart';
import 'package:atri/widgets/content_box.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:async';
void main() {
  runApp(const ChunkerInterface());
}

class ChunkerInterface extends StatefulWidget {
  const ChunkerInterface({super.key});

  @override
  State<ChunkerInterface> createState() => _ChunkerInterfaceState();
}

class _ChunkerInterfaceState extends State<ChunkerInterface> {
  // File and Content State
  String? _fileName;
  String _originalFileContent = 'Select a text file to display its content here.';
  String _chunkedContent = 'Chunked content will appear here after processing.';
  String _translatedContent = 'Translated content will appear here.';

  // UI and Chunking Parameters
  ChunkingMethod _selectedChunkingMethod = ChunkingMethod.lines;
  final TextEditingController _linesPerChunkController = TextEditingController(text: '10');
  final TextEditingController _wordsPerChunkController = TextEditingController(text: '100');
  final TextEditingController _charactersPerChunkController = TextEditingController(text: '1000');
  final TextEditingController _regexPatternController = TextEditingController(text: r'\n\n+');
  final TextEditingController _overlapController = TextEditingController(text: '0');

  // Translation State
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _targetLanguageController = TextEditingController(text: 'Spanish');
  final TranslationService _translationService = TranslationService();
  List<String> _chunks = [];
  List<String?>? _translatedChunks;
  bool _isTranslating = false;
  double _translationProgress = 0.0;

  @override
  void dispose() {
    _linesPerChunkController.dispose();
    _wordsPerChunkController.dispose();
    _charactersPerChunkController.dispose();
    _regexPatternController.dispose();
    _overlapController.dispose();
    _apiKeyController.dispose();
    _targetLanguageController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null && result.files.single.path != null) {
        PlatformFile platformFile = result.files.single;
        File file = File(platformFile.path!);
        String content = await file.readAsString();
        setState(() {
          _fileName = platformFile.name;
          _originalFileContent = content;
          _chunkedContent = 'Press "Chunk Text" to process.';
          _translatedContent = 'Translate chunks to see the result.';
          _chunks = [];
          _translatedChunks = null;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking or reading file: $e');
    }
  }

  void _performChunking() {
    try {
      _chunks = TextChunkerService.chunkText(
        originalContent: _originalFileContent,
        method: _selectedChunkingMethod,
        linesPerChunk: int.tryParse(_linesPerChunkController.text) ?? 10,
        wordsPerChunk: int.tryParse(_wordsPerChunkController.text) ?? 100,
        charactersPerChunk: int.tryParse(_charactersPerChunkController.text) ?? 1000,
        regexPattern: _regexPatternController.text,
        overlap: int.tryParse(_overlapController.text) ?? 0,
      );

      setState(() {
        _chunkedContent = _chunks.asMap().entries.map((entry) {
          return '--- Chunk ${entry.key + 1} ---\n${entry.value}';
        }).join('\n\n');
        _translatedContent = 'Ready to translate ${_chunks.length} chunks.';
        _translatedChunks = null;
        _translationProgress = 0.0;
      });
    } catch (e) {
      _showErrorSnackBar('Error during chunking: $e');
    }
  }

  Future<void> _performTranslation() async {
    if (_chunks.isEmpty) {
      _showErrorSnackBar('Please chunk the text before translating.');
      return;
    }
    if (_apiKeyController.text.isEmpty) {
      _showErrorSnackBar('Please enter your OpenAI API Key.');
      return;
    }

    setState(() {
      _isTranslating = true;
      _translationProgress = 0.0;
      _translatedChunks = List.filled(_chunks.length, null);
      _translatedContent = 'Translating...';
    });

    _translationService.setApiKey(_apiKeyController.text);
    int completedCount = 0;

    try {
      await _translationService.translateChunksConcurrently(
        chunks: _chunks,
        targetLanguage: _targetLanguageController.text,
        onChunkTranslated: (index, translatedChunk) {
          setState(() {
            _translatedChunks![index] = translatedChunk;
            completedCount++;
            _translationProgress = completedCount / _chunks.length;
            // Optionally update the text box live, might be slow for very large files
            // _translatedContent = _translatedChunks!.where((s) => s != null).join('\n\n');
          });
        },
      );
    } catch (e) {
      _showErrorSnackBar('Translation failed: $e');
    } finally {
      setState(() {
        _isTranslating = false;
        _translatedContent = _translatedChunks?.join('\n\n') ?? 'Translation finished with errors.';
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter File Chunker & Translator',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('File Chunker & Translator'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Top Control Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickFile,
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Select File'),
                          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                        ),
                        const SizedBox(height: 8),
                        Text(_fileName ?? 'No file selected', textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        TextField(
                          controller: _apiKeyController,
                          decoration: const InputDecoration(labelText: 'OpenAI API Key'),
                          obscureText: true,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _targetLanguageController,
                          decoration: const InputDecoration(labelText: 'Target Language'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Chunking Options and Actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Chunking Method:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 8.0,
                          children: ChunkingMethod.values.map((method) {
                            return ChoiceChip(
                              label: Text(method.name[0].toUpperCase() + method.name.substring(1)),
                              selected: _selectedChunkingMethod == method,
                              onSelected: (selected) {
                                if (selected) setState(() => _selectedChunkingMethod = method);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        if (_selectedChunkingMethod == ChunkingMethod.lines)
                          TextField(controller: _linesPerChunkController, decoration: const InputDecoration(labelText: 'Lines per chunk'), keyboardType: TextInputType.number)
                        else if (_selectedChunkingMethod == ChunkingMethod.words)
                          TextField(controller: _wordsPerChunkController, decoration: const InputDecoration(labelText: 'Words per chunk'), keyboardType: TextInputType.number)
                        else if (_selectedChunkingMethod == ChunkingMethod.characters)
                          TextField(controller: _charactersPerChunkController, decoration: const InputDecoration(labelText: 'Characters per chunk'), keyboardType: TextInputType.number)
                        else
                          TextField(controller: _regexPatternController, decoration: const InputDecoration(labelText: 'Regex Pattern')),
                        const SizedBox(height: 8),
                        if (_selectedChunkingMethod != ChunkingMethod.regex)
                          TextField(controller: _overlapController, decoration: InputDecoration(labelText: 'Overlap (${_selectedChunkingMethod.name})'), keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _performChunking,
                      icon: const Icon(Icons.cut),
                      label: const Text('Chunk Text'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isTranslating ? null : _performTranslation,
                      icon: const Icon(Icons.translate),
                      label: const Text('Translate Chunks'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(45),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isTranslating)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: _translationProgress),
                      const SizedBox(height: 4),
                      Text('Translating... ${(_translationProgress * 100).toStringAsFixed(0)}%'),
                    ],
                  ),
                ),
              const Divider(height: 24),
              // Content Display
              Expanded(
                child: Row(
                  children: [
                    ContentDisplayBox(title: 'Original Content', content: _originalFileContent),
                    const SizedBox(width: 16),
                    ContentDisplayBox(title: 'Chunked Content (${_chunks.length} chunks)', content: _chunkedContent),
                    const SizedBox(width: 16),
                    ContentDisplayBox(title: 'Translated Content', content: _translatedContent),
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
