import '../../../../../core/error/exceptions.dart';
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

  @override
  Future<String> sendMessage(String message) async {
    try {
      final apiKey = ApiKeys.geminiApiKey;
      
      if (apiKey.isEmpty) {
        // Return a helpful message when API key is not configured
        await Future.delayed(const Duration(seconds: 1));
        return "🤖 To use IGCSE AI Tutor, you need to configure your Gemini API key.\n\n1. Get your API key from: https://makersuite.google.com/app/apikey\n2. Open lib/config/api_keys.dart\n3. Replace the empty string with your API key\n4. Restart the app\n\nAfter configuring, I'll be able to help you with your IGCSE studies!";
      }
      
      // TODO: Implement actual Gemini API call here
      // For now, simulate a response if API key is provided
      if (apiKey.isNotEmpty) {
        // This is where you'll implement the actual Gemini API call
        // For testing, we'll return a helpful message
        await Future.delayed(const Duration(seconds: 2));
        
        String response = _generateEducationalResponse(message);
        return response;
      }
      
      return "Please configure your Gemini API key to use the AI Tutor.";
      
    } catch (e) {
      throw ServerException('Failed to send message to AI: ${e.toString()}');
    }
  }
  
  // Simple educational response generator for testing
  String _generateEducationalResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();
    
    if (userMessage.contains('math') || userMessage.contains('mathematics')) {
      return "Math is a fundamental IGCSE subject! Here are some tips:\n\n• Practice regularly with past papers\n• Master the basics before moving to complex topics\n• Use diagrams for geometry problems\n• Show your work step-by-step\n• Check your answers using different methods\n\nWhat specific math topic are you struggling with?";
    }
    
    if (userMessage.contains('science') || userMessage.contains('biology') || userMessage.contains('chemistry') || userMessage.contains('physics')) {
      return "Science subjects require both theoretical understanding and practical application!\n\n• Create mind maps for concepts\n• Use flashcards for key terms\n• Practice with lab experiment write-ups\n• Connect topics to real-world examples\n• Review past paper questions regularly\n\nWhich science subject would you like help with?";
    }
    
    if (userMessage.contains('study') || userMessage.contains('how to study')) {
      return "Here are effective study strategies for IGCSE:\n\n📚 Study Techniques:\n• Use spaced repetition for long-term retention\n• Create a study schedule with breaks\n• Teach concepts to someone else (the Feynman technique)\n• Use past papers under exam conditions\n• Join study groups for difficult topics\n\n⏰ Time Management:\n• Study in 25-45 minute focused sessions\n• Prioritize difficult subjects when fresh\n• Review notes within 24 hours of class\n• Use the Pomodoro technique for focus\n\nNeed help with a specific subject or study technique?";
    }
    
    if (userMessage.contains('exam') || userMessage.contains('test')) {
      return "Exam preparation is key for IGCSE success!\n\n📝 Before the Exam:\n• Create a study timeline 2-3 months before\n• Review syllabus objectives thoroughly\n• Practice with timed past papers\n• Understand the exam format and marking scheme\n• Get enough sleep the night before\n\n✍️ During the Exam:\n• Read all questions carefully\n• Plan your time for each section\n• Show your working in math/science\n• Answer questions you know first\n• Leave time to review your answers\n\nWhat subject or specific exam would you like help preparing for?";
    }
    
    // Default response with encouragement
    return "Hello! I'm your IGCSE AI Tutor and I'm here to help you succeed! 🎓\n\nI can assist you with:\n• All IGCSE subjects (Math, Sciences, Languages, etc.)\n• Study strategies and techniques\n• Homework help and explanations\n• Exam preparation tips\n• Time management skills\n\nWhat would you like to learn about today? Whether it's a specific subject, study technique, or exam advice - I'm here to guide you step by step!";
  }

  @override
  Future<void> clearConversation() async {
    try {
      // TODO: Implement clearing conversation logic if using persistent chat
    } catch (e) {
      throw ServerException('Failed to clear conversation: ${e.toString()}');
    }
  }
}
