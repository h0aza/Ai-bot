import { Bot } from "lucide-react";

export default function TypingIndicator() {
  return (
    <div className="flex justify-end mb-4">
      <div className="flex items-end space-x-2 space-x-reverse">
        <div className="w-8 h-8 bg-gradient-primary rounded-full flex items-center justify-center">
          <Bot className="text-white" size={14} />
        </div>
        <div className="bg-white rounded-2xl px-4 py-3 shadow-sm border border-gray-200">
          <div className="flex space-x-1">
            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce-typing"></div>
            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce-typing"></div>
            <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce-typing"></div>
          </div>
        </div>
      </div>
    </div>
  );
}
