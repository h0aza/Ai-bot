import { useState, useEffect } from "react";
import { Cpu, Zap, Brain } from "lucide-react";

export default function AiStatusIndicator() {
  const [status, setStatus] = useState<'checking' | 'ai-enabled' | 'basic-mode'>('checking');

  useEffect(() => {
    // Check if AI is available by testing health endpoint
    const checkAiStatus = async () => {
      try {
        const response = await fetch('/api/health');
        const data = await response.json();
        
        // Check if OpenAI is available by sending a test message
        const testResponse = await fetch('/api/ai-status');
        const aiData = await testResponse.json();
        
        if (aiData.ai_enabled) {
          setStatus('ai-enabled');
        } else {
          setStatus('basic-mode');
        }
      } catch (error) {
        setStatus('basic-mode');
      }
    };

    checkAiStatus();
  }, []);

  const getStatusInfo = () => {
    switch (status) {
      case 'checking':
        return {
          icon: <Cpu className="w-3 h-3" />,
          text: "جاري الفحص...",
          color: "text-gray-500",
          bgColor: "bg-gray-100"
        };
      case 'ai-enabled':
        return {
          icon: <Brain className="w-3 h-3" />,
          text: "مدعوم بالذكاء الاصطناعي",
          color: "text-green-600",
          bgColor: "bg-green-100"
        };
      case 'basic-mode':
        return {
          icon: <Zap className="w-3 h-3" />,
          text: "الوضع الأساسي",
          color: "text-blue-600",
          bgColor: "bg-blue-100"
        };
    }
  };

  const statusInfo = getStatusInfo();

  return (
    <div className={`inline-flex items-center space-x-1 space-x-reverse px-2 py-1 rounded-full text-xs ${statusInfo.bgColor} ${statusInfo.color}`}>
      {statusInfo.icon}
      <span>{statusInfo.text}</span>
    </div>
  );
}