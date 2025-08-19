import 'package:openai_dart/openai_dart.dart';
import 'dart:async';

/// Enum to define different chunking methods for text.
enum ChunkingMethod {
  lines,
  words,
  regex,
  characters,
}

/// Service class responsible for text chunking operations.
class TextChunkerService {
  static List<String> chunkText({
    required String originalContent,
    required ChunkingMethod method,
    int linesPerChunk = 10,
    int wordsPerChunk = 100,
    int charactersPerChunk = 500,
    String regexPattern = r'\n\n+',
    int overlap = 0,
  }) {
    if (originalContent.isEmpty) return [];

    if (overlap < 0) {
      throw ArgumentError('Overlap must be a non-negative number.');
    }

    List<String> chunks = [];

    switch (method) {
      case ChunkingMethod.lines:
        if (linesPerChunk <= 0) throw ArgumentError('Lines per chunk must be a positive number.');
        if (overlap >= linesPerChunk) throw ArgumentError('Overlap must be smaller than lines per chunk.');

        final List<String> contentLines = originalContent.split('\n');
        int step = linesPerChunk - overlap;
        for (int i = 0; i < contentLines.length; i += step) {
          int end = (i + linesPerChunk > contentLines.length) ? contentLines.length : i + linesPerChunk;
          chunks.add(contentLines.sublist(i, end).join('\n'));
          if (end == contentLines.length) break;
        }
        break;

      case ChunkingMethod.words:
        if (wordsPerChunk <= 0) throw ArgumentError('Words per chunk must be a positive number.');
        if (overlap >= wordsPerChunk) throw ArgumentError('Overlap must be smaller than words per chunk.');

        final List<String> contentWords = originalContent.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
        int step = wordsPerChunk - overlap;
        for (int i = 0; i < contentWords.length; i += step) {
          int end = (i + wordsPerChunk > contentWords.length) ? contentWords.length : i + wordsPerChunk;
          chunks.add(contentWords.sublist(i, end).join(' '));
          if (end == contentWords.length) break;
        }
        break;

      case ChunkingMethod.characters:
        if (charactersPerChunk <= 0) throw ArgumentError('Characters per chunk must be a positive number.');
        if (overlap >= charactersPerChunk) throw ArgumentError('Overlap must be smaller than characters per chunk.');

        final String content = originalContent;
        int step = charactersPerChunk - overlap;
        for (int i = 0; i < content.length; i += step) {
          int end = (i + charactersPerChunk > content.length) ? content.length : i + charactersPerChunk;
          chunks.add(content.substring(i, end));
          if (end == content.length) break;
        }
        break;

      case ChunkingMethod.regex:
        if (regexPattern.isEmpty) throw ArgumentError('Regex pattern cannot be empty.');
        final RegExp regExp = RegExp(regexPattern);
        chunks = originalContent.split(regExp).where((s) => s.isNotEmpty).toList();
        break;
    }

    if (chunks.isEmpty && originalContent.isNotEmpty) {
      chunks.add(originalContent);
    }
    return chunks;
  }
}

/// Service for handling translation via OpenAI API.
class TranslationService {
  // A single client can handle concurrent requests.
  OpenAIClient? _client;

  // Use a setter for the API key to initialize the client.
  void setApiKey(String apiKey) {
    if (apiKey.isNotEmpty) {
      _client = OpenAIClient(apiKey: apiKey, baseUrl: "https://api.avalai.org/v1");
    } else {
      _client = null;
    }
  }

  Future<String> _translateTextChunk(String text, String targetLanguage) async {
    if (_client == null) {
      throw Exception('API Key not set. Please provide a valid OpenAI API key.');
    }
    if (text.trim().isEmpty) {
      return text; // Return empty or whitespace text as is.
    }

    final prompt = 'Translate the following text to $targetLanguage. Return only the translated text, without any introductory phrases or explanations.';

    try {
      final res = await _client!.createChatCompletion(
        request: CreateChatCompletionRequest(
          // Using a standard, reliable OpenAI model.
          model: const ChatCompletionModel.modelId('gemini-2.5-flash-lite'),
          messages: [
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string('$prompt\n\nText: """$text"""'),
            ),
          ],
          temperature: 0.2, // Lower temperature for more deterministic translations.
        ),
      );
      return res.choices.first.message.content?.trim() ?? '[Translation Failed: Empty Response]';
    } catch (e) {
      // Return a specific error message for this chunk.
      return '[Translation Error: ${e.toString()}]';
    }
  }

  /// Translates a list of text chunks concurrently.
  ///
  /// This method processes chunks in batches to avoid overwhelming the API and to manage memory.
  /// It's more stable than managing a complex queue of individual futures.
  Future<void> translateChunksConcurrently({
    required List<String> chunks,
    required String targetLanguage,
    required Function(int index, String translatedChunk) onChunkTranslated,
    int batchSize = 5, // Process 5 chunks at a time. Adjust based on performance.
  }) async {
    if (_client == null) {
      throw Exception('API Key not set before starting translation.');
    }

    for (int i = 0; i < chunks.length; i += batchSize) {
      // Determine the end of the current batch.
      int end = (i + batchSize > chunks.length) ? chunks.length : i + batchSize;
      List<String> batchChunks = chunks.sublist(i, end);

      // Create a list of translation futures for the current batch.
      List<Future<String>> batchFutures = batchChunks
          .map((chunk) => _translateTextChunk(chunk, targetLanguage))
          .toList();

      // Wait for all translations in the current batch to complete.
      List<String> translatedBatch = await Future.wait(batchFutures);

      // Report progress for each completed chunk in the batch.
      for (int j = 0; j < translatedBatch.length; j++) {
        onChunkTranslated(i + j, translatedBatch[j]);
      }
    }
  }
}
