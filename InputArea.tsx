import { useState } from "react";
import { Send, Mic } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

interface InputAreaProps {
  onSendMessage: (message: string) => void;
  isLoading: boolean;
}

export default function InputArea({ onSendMessage, isLoading }: InputAreaProps) {
  const [message, setMessage] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (message.trim() && !isLoading) {
      onSendMessage(message);
      setMessage("");
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSubmit(e);
    }
  };

  return (
    <div className="sticky bottom-0 bg-white border-t border-gray-200 p-4">
      <form onSubmit={handleSubmit}>
        <div className="flex space-x-3 space-x-reverse">
          <div className="flex-1 relative">
            <Input
              type="text"
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="اكتب رسالتك هنا..."
              className="pr-12 py-3 rounded-xl border-gray-300 focus:ring-2 focus:ring-primary focus:border-transparent"
              disabled={isLoading}
            />
            <Button
              type="button"
              variant="ghost"
              size="sm"
              className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600 p-1"
            >
              <Mic size={16} />
            </Button>
          </div>
          <Button
            type="submit"
            disabled={!message.trim() || isLoading}
            className="px-6 py-3 bg-primary text-white rounded-xl hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Send size={16} />
          </Button>
        </div>
      </form>
      
      {/* Status Bar */}
      <div className="flex items-center justify-between mt-3 text-xs text-gray-500">
        <div className="flex items-center space-x-2 space-x-reverse">
          <div className="w-2 h-2 bg-green-500 rounded-full"></div>
          <span>معاذ AI متصل</span>
        </div>
        <div className="flex items-center space-x-2 space-x-reverse">
          <span>مدعوم بتقنية معاذ AI من Moaaz AI</span>
          <div className="w-2 h-2 bg-primary rounded-full"></div>
        </div>
      </div>
    </div>
  );
}
