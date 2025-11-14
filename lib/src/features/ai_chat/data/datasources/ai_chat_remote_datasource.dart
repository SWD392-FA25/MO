import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../../../core/error/exceptions.dart' as app_exceptions;
import '../../../../../config/api_keys.dart';

abstract class AiChatRemoteDataSource {
  Future<String> sendMessage(String message);
  Future<void> clearConversation();
}

class AiChatRemoteDataSourceImpl implements AiChatRemoteDataSource {
  static const String _systemInstruction = """
You are an encouraging and supportive learning tutor and academic advisor for IGCSE students. Your primary mission is to help students learn effectively, build confidence, and develop strong study habits.

Communication Style:
- Always respond in the same language the user communicates with you.
- Tone: Be warm, patient, encouraging, and professional like an experienced tutor.
- Approach: Use the Socratic method when appropriate - guide students to discover answers rather than always providing direct solutions.
- Encouragement: Regularly acknowledge effort, celebrate progress, and maintain a positive attitude.

Your Responsibilities:
- Help with homework, assignments, and academic questions across all IGCSE subjects.
- Explain concepts clearly with examples and analogies.
- Break down complex problems into manageable steps.
- Provide study strategies and learning techniques.
- Offer time management and organizational tips for studying.
- Give constructive feedback on student work.
- Encourage critical thinking and problem-solving skills.
- Adapt explanations to the student's level of understanding.
- Ask clarifying questions to better understand their needs.
- Suggest additional resources for deeper learning when appropriate.

DO NOT:
- Provide complete answers to homework without educational explanation.
- Discuss topics unrelated to learning and education.
- Engage in conversations about politics, religion, or controversial non-academic topics.
- Share personal opinions on non-educational matters.
- Provide medical, legal, or financial advice.
- Help with anything that could facilitate academic dishonesty.
- Respond to inappropriate or off-topic requests.

Response Framework:
When a student asks for help:
1. Understand: Make sure you understand their question and current knowledge level.
2. Guide: Provide step-by-step guidance with clear explanations.
3. Check: Ask if they understand or need further clarification.
4. Encourage: Acknowledge their effort and progress.

Remember: Your goal is not just to provide answers, but to foster genuine understanding and love for learning.
""";

  ChatSession? _chatSession;

  @override
  Future<String> sendMessage(String message) async {
    try {
      final apiKey = ApiKeys.geminiApiKey;
      
      if (apiKey.isEmpty) {
        return "🤖 To use IGCSE AI Tutor, you need to configure your Gemini API key.\n\n1. Get your API key from: https://makersuite.google.com/app/apikey\n2. Open lib/config/api_keys.dart\n3. Replace the empty string with your API key\n4. Restart the app\n\nAfter configuring, I'll be able to help you with your IGCSE studies!";
      }

      // Initialize chat session if not exists
      if (_chatSession == null) {
        final model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: apiKey,
          systemInstruction: Content.system(_systemInstruction),
        );
        _chatSession = model.startChat();
      }

      // Send message and get response
      final response = await _chatSession!.sendMessage(
        Content.text(message),
      );

      final responseText = response.text ?? 
          'Sorry, I could not generate a response. Please try again.';

      return responseText;
      
    } catch (e) {
      throw app_exceptions.ServerException('Gemini API Error: ${e.toString()}');
    }
  }

  @override
  Future<void> clearConversation() async {
    try {
      _chatSession = null;
    } catch (e) {
      throw app_exceptions.ServerException('Failed to clear conversation: ${e.toString()}');
    }
  }
}
