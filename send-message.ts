import { VercelRequest, VercelResponse } from '@vercel/node';
import { getTelegramBot } from '../../server/telegram-bot';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { message, chatId } = req.body;
    
    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    const bot = getTelegramBot();
    if (!bot) {
      return res.status(503).json({ error: 'Telegram bot not available' });
    }

    // Send system alert to all admins if no specific chatId
    if (!chatId) {
      await bot.sendSystemAlert(message);
    } else {
      // Send to specific chat (future feature)
      return res.status(400).json({ error: 'Specific chat messaging not implemented yet' });
    }
    
    res.json({ 
      success: true, 
      message: 'Message sent successfully',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Failed to send Telegram message:', error);
    res.status(500).json({ error: 'Failed to send message' });
  }
}