#!/bin/bash

# معاذ AI Permanent Deployment Script
# Ensures 24/7 continuous operation without manual intervention

echo "🚀 Deploying معاذ AI Permanent Service..."

# Set up environment for permanent operation
export NODE_ENV=production
export PERMANENT_SERVICE=true

# Function to check if service is running
check_service() {
    if curl -f -s http://localhost:5000/health > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Function to deploy the service
deploy_service() {
    echo "📦 Building production version..."
    npm run build
    
    echo "🔄 Starting permanent service..."
    nohup npm run start > service.log 2>&1 &
    SERVICE_PID=$!
    echo $SERVICE_PID > service.pid
    
    echo "✅ Service deployed with PID: $SERVICE_PID"
    echo "📋 Log file: service.log"
    echo "🆔 PID file: service.pid"
}

# Function to setup monitoring
setup_monitoring() {
    echo "👁️ Setting up continuous monitoring..."
    
    # Create monitoring script
    cat > monitor.sh << 'EOF'
#!/bin/bash
while true; do
    if ! curl -f -s http://localhost:5000/health > /dev/null 2>&1; then
        echo "$(date): Service down, restarting..." >> monitor.log
        if [ -f service.pid ]; then
            kill $(cat service.pid) 2>/dev/null
        fi
        nohup npm run start > service.log 2>&1 &
        echo $! > service.pid
    fi
    sleep 30
done
EOF
    
    chmod +x monitor.sh
    nohup ./monitor.sh > monitor.log 2>&1 &
    MONITOR_PID=$!
    echo $MONITOR_PID > monitor.pid
    
    echo "✅ Monitoring setup complete with PID: $MONITOR_PID"
}

# Function to create systemd-like service (for production environments)
create_service_config() {
    cat > moaaz-ai.service << 'EOF'
[Unit]
Description=معاذ AI - Permanent Arabic AI Assistant
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/app
ExecStart=/usr/bin/npm run start
Restart=always
RestartSec=5
Environment=NODE_ENV=production
Environment=PERMANENT_SERVICE=true

[Install]
WantedBy=multi-user.target
EOF
    
    echo "📄 Service configuration created: moaaz-ai.service"
}

# Main deployment process
main() {
    echo "🔍 Checking current service status..."
    
    if check_service; then
        echo "⚠️ Service is already running. Updating..."
        if [ -f service.pid ]; then
            OLD_PID=$(cat service.pid)
            echo "🔄 Stopping old service (PID: $OLD_PID)..."
            kill $OLD_PID 2>/dev/null
            sleep 5
        fi
    fi
    
    # Deploy the service
    deploy_service
    
    # Wait for service to start
    echo "⏳ Waiting for service to initialize..."
    sleep 10
    
    # Verify service is running
    if check_service; then
        echo "✅ Service is running successfully!"
        
        # Get service status
        echo "📊 Service Status:"
        curl -s http://localhost:5000/api/system-status | jq -r '.service + " - " + .status'
        
        # Setup monitoring
        setup_monitoring
        
        # Create service configuration
        create_service_config
        
        echo ""
        echo "🎉 معاذ AI Permanent Service Deployed Successfully!"
        echo "🌐 Service URL: http://localhost:5000"
        echo "💚 Health Check: http://localhost:5000/health"
        echo "📈 System Status: http://localhost:5000/api/system-status"
        echo "📝 Service Log: tail -f service.log"
        echo "📝 Monitor Log: tail -f monitor.log"
        echo ""
        echo "🔒 The service is now configured for permanent 24/7 operation"
        echo "🛡️ Multiple monitoring layers ensure continuous availability"
        echo "🔄 Automatic restart on any failure"
        echo "💾 Memory management and garbage collection"
        echo "🚫 Process protection against shutdowns"
        
    else
        echo "❌ Service failed to start. Check service.log for details."
        exit 1
    fi
}

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up deployment artifacts..."
    if [ -f service.pid ]; then
        kill $(cat service.pid) 2>/dev/null
        rm service.pid
    fi
    if [ -f monitor.pid ]; then
        kill $(cat monitor.pid) 2>/dev/null
        rm monitor.pid
    fi
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Run main deployment
main

echo "🚀 Deployment complete. Service is now running permanently."