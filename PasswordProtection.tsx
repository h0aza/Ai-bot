import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Lock, Bot } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

interface PasswordProtectionProps {
  onAuthenticated: () => void;
}

export default function PasswordProtection({ onAuthenticated }: PasswordProtectionProps) {
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const { toast } = useToast();

  const correctPassword = "moaaz ai";

  useEffect(() => {
    // Check if user is already authenticated
    const isAuthenticated = localStorage.getItem("moaaz_ai_authenticated");
    if (isAuthenticated === "true") {
      onAuthenticated();
    }
  }, [onAuthenticated]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    setTimeout(() => {
      if (password.toLowerCase().trim() === correctPassword) {
        localStorage.setItem("moaaz_ai_authenticated", "true");
        onAuthenticated();
        toast({
          title: "تم الدخول بنجاح",
          description: "مرحباً بك في معاذ AI",
        });
      } else {
        toast({
          title: "كلمة سر خاطئة",
          description: "يرجى المحاولة مرة أخرى",
          variant: "destructive",
        });
      }
      setIsLoading(false);
    }, 1000);
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleSubmit(e as any);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 via-white to-purple-50 p-4">
      <Card className="w-full max-w-md shadow-lg">
        <CardHeader className="text-center">
          <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center mx-auto mb-4">
            <Bot className="text-white text-2xl" size={24} />
          </div>
          <CardTitle className="text-2xl font-bold text-gray-900">معاذ AI</CardTitle>
          <p className="text-gray-600">مساعد ذكي من Moaaz AI</p>
        </CardHeader>
        
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <label className="text-sm font-medium text-gray-700 flex items-center gap-2">
                <Lock size={16} />
                كلمة السر
              </label>
              <Input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                onKeyPress={handleKeyPress}
                placeholder="أدخل كلمة السر للدخول"
                className="text-center"
                disabled={isLoading}
                autoFocus
              />
            </div>
            
            <Button 
              type="submit" 
              className="w-full bg-gradient-primary hover:opacity-90 transition-opacity"
              disabled={isLoading || !password.trim()}
            >
              {isLoading ? "جاري التحقق..." : "دخول"}
            </Button>
          </form>
          
          <div className="mt-6 text-center text-sm text-gray-500">
            <p>محمي بواسطة تقنية معاذ AI</p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}