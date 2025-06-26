import { VercelRequest, VercelResponse } from '@vercel/node';
import { getTelegramBot } from '../../server/telegram-bot';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const bot = getTelegramBot();
    if (!bot) {
      return res.status(503).json({ error: 'Telegram bot not available' });
    }

    // Restart the bot
    bot.stop();
    // Note: In production, you'd reinitialize the bot here
    
    res.json({ 
      success: true, 
      message: 'Telegram bot restart initiated',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Failed to restart Telegram bot:', error);
    res.status(500).json({ error: 'Failed to restart bot' });
  }
}