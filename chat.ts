import { VercelRequest, VercelResponse } from '@vercel/node';
import { chatRequestSchema } from '../shared/schema';
import { storage } from '../server/storage';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // التحقق من صحة البيانات
    const { message } = chatRequestSchema.parse(req.body);

    // حفظ رسالة المستخدم
    await storage.createMessage({
      content: message,
      sender: 'user'
    });

    // إنشاء رد AI بسيط
    let response = "أهلاً بك في معاذ AI! أنا مساعد ذكي باللغة العربية.";
    
    // ردود ذكية بناءً على المحتوى
    if (message.includes('مرحبا') || message.includes('السلام') || message.includes('أهلا')) {
      response = "مرحباً بك! كيف يمكنني مساعدتك اليوم؟";
    } else if (message.includes('كيف حالك') || message.includes('كيفك')) {
      response = "أنا بخير والحمد لله، شكراً لسؤالك! كيف يمكنني خدمتك؟";
    } else if (message.includes('اسمك') || message.includes('من أنت')) {
      response = "أنا معاذ AI، مساعد ذكي متخصص في اللغة العربية. تم تطويري لمساعدتك في مختلف المهام.";
    } else if (message.includes('شكر') || message.includes('ممتاز')) {
      response = "العفو! أسعدني أن أساعدك. إذا كان لديك أي سؤال آخر، لا تتردد في طرحه.";
    } else if (message.includes('مساعدة') || message.includes('ساعدني')) {
      response = "بالطبع! أنا هنا لمساعدتك. اخبرني بما تحتاجه وسأبذل قصارى جهدي لمساعدتك.";
    } else if (message.includes('وداع') || message.includes('باي')) {
      response = "وداعاً! أتمنى لك يوماً سعيداً. أراك قريباً!";
    }

    // حفظ رد AI
    await storage.createMessage({
      content: response,
      sender: 'ai'
    });

    res.status(200).json({ response });

  } catch (error) {
    console.error('Chat API error:', error);
    res.status(500).json({ error: 'حدث خطأ في معالجة الرسالة' });
  }
}