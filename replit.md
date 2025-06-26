# معاذ AI - Arabic AI Assistant

## Overview

معاذ AI is a full-stack web application that provides an Arabic-language AI chat assistant. The application features a modern, responsive interface built with React and a Node.js/Express backend with in-memory storage. The AI is powered by OpenAI's GPT-3.5-turbo when API key is available, with intelligent fallback responses when not available.

## System Architecture

### Frontend Architecture
- **Framework**: React with TypeScript
- **UI Library**: shadcn/ui components built on Radix UI primitives
- **Styling**: Tailwind CSS with RTL (right-to-left) support for Arabic
- **State Management**: TanStack React Query for server state management
- **Routing**: Wouter for lightweight client-side routing
- **Build Tool**: Vite for fast development and optimized production builds

### Backend Architecture
- **Runtime**: Node.js with Express.js framework
- **Language**: TypeScript with ES modules
- **Database ORM**: Drizzle ORM with PostgreSQL
- **Session Management**: Express sessions with PostgreSQL store
- **Development**: Hot reloading with Vite middleware integration

### Database Architecture
- **Primary Database**: PostgreSQL (configured via Neon serverless)
- **Schema Management**: Drizzle Kit for migrations
- **Storage Strategy**: In-memory storage fallback for development

## Key Components

### Database Schema
- **Users Table**: Handles user authentication with username/password
- **Messages Table**: Stores chat messages with sender type (user/ai), content, timestamps, and optional user association
- **Validation**: Zod schemas for type-safe data validation

### Chat System
- **AI Integration**: Google Gemini 2.5 Flash for intelligent responses (branded as معاذ AI technology)
- **API Key Management**: Dynamic API key updates through settings interface and Telegram bot
- **Fallback System**: Smart rule-based responses for common Arabic interactions
- **Real-time Interface**: Typing indicators and smooth message flow with animations
- **Settings Panel**: Dark/light mode, sound toggles, logout functionality, API key management
- **More Options Menu**: About dialog, help section, privacy policy, copyright information
- **Status Indicators**: Real-time AI availability and API key status monitoring

### Telegram Bot Integration
- **Remote Control**: Full website control through Telegram commands
- **Admin Authentication**: Secure admin access with password protection and user management
- **API Key Management**: Set, get, and test API keys remotely with validation
- **System Monitoring**: Real-time status, uptime, memory usage monitoring
- **System Control**: Remote restart, deployment guidance, log access
- **Website Management**: Dynamic password changing, health monitoring, Vercel deployment
- **Security Features**: Admin-only commands, masked API key display, operation logging
- **Automatic Alerts**: System notifications for startups, errors, and important events
- **Project File Transfer**: Enhanced `/ai` command with rate limiting and retry mechanisms
- **Frontend-Only Transfer**: `/frontend` command for GitHub/Vercel deployment packages
- **File List Display**: `/au` command shows organized file structure with directory grouping
- **Smart File Filtering**: Excludes unnecessary files and includes only project essentials
- **Rate Limit Handling**: Exponential backoff and intelligent retry for file transfers
- **Document Attachment**: All files sent as downloadable documents with size information
- **Comprehensive Commands**: Password management, site health, deployment, and logging
- **Cloud Deployment Ready**: Optimized file packages for standalone cloud deployment

### UI Components
- **Chat Interface**: Modern chat bubbles with user/AI distinction
- **Welcome Screen**: Feature showcase and suggested questions
- **Input Area**: Text input with send button and keyboard shortcuts
- **Responsive Design**: Mobile-first approach with desktop optimization

## Data Flow

1. **User Input**: User types message in Arabic interface
2. **Frontend Validation**: Message validated using Zod schemas
3. **API Request**: POST to `/api/chat` endpoint with message content
4. **Backend Processing**: 
   - Message stored in database as user message
   - Simple AI response generated based on pattern matching
   - AI response stored in database
5. **Response Delivery**: AI response sent back to frontend
6. **UI Update**: New messages displayed in chat interface with smooth animations

## External Dependencies

### Frontend Dependencies
- **React Ecosystem**: React 18, React DOM, TanStack React Query
- **UI Framework**: Radix UI primitives, Tailwind CSS, shadcn/ui
- **Form Handling**: React Hook Form with Hookform Resolvers
- **Icons**: Lucide React
- **Utilities**: Class Variance Authority, clsx, date-fns

### Backend Dependencies
- **Server**: Express.js, Node.js HTTP server
- **Database**: Drizzle ORM, Neon Database serverless driver
- **Session**: Express sessions with PostgreSQL store
- **Development**: tsx for TypeScript execution, Vite integration

### Development Tools
- **Build**: Vite, esbuild for production bundling
- **Type Checking**: TypeScript with strict configuration
- **CSS Processing**: PostCSS, Autoprefixer
- **Database Tools**: Drizzle Kit for schema management

## Deployment Strategy

### Development Environment
- **Runtime**: Node.js 20 with Replit modules
- **Database**: PostgreSQL 16 module
- **Development Server**: Vite dev server on port 5000
- **Hot Reloading**: Vite HMR with backend integration

### Production Build
- **Frontend**: Vite builds to `dist/public` directory
- **Backend**: esbuild bundles server to `dist/index.js`
- **Static Serving**: Express serves built frontend assets
- **Environment**: Production mode with optimized builds

### Replit Configuration
- **Autoscale Deployment**: Configured for automatic scaling
- **Port Mapping**: Internal port 5000 mapped to external port 80
- **Build Process**: npm run build followed by npm run start
- **Modules**: nodejs-20, web, postgresql-16

### Vercel Cloud Deployment
- **Serverless Functions**: API endpoints deployed as Vercel functions
- **Static Assets**: Frontend served from global CDN
- **Build Command**: `vite build` for optimized production build
- **Runtime**: Node.js 20.x with 512MB memory allocation
- **Auto-scaling**: Automatic scaling based on traffic
- **SSL/HTTPS**: Automatic SSL certificates and security headers
- **Custom Domains**: Support for custom domain configuration
- **Database Integration**: Compatible with Neon PostgreSQL and PlanetScale MySQL

## Permanent Service Architecture

### Continuous Operation System
The application now features a comprehensive permanent service architecture designed for 24/7 operation without manual intervention:

#### Multi-Layer Monitoring System
- **Uptime Monitor**: Continuous health checks every 15 seconds with automatic recovery
- **External Ping Service**: Multiple ping strategies (2min, 5min, 10min, 60sec intervals) to prevent idle shutdown
- **Process Watchdog**: Monitors process health every 10 seconds with unlimited restart capability
- **Memory Management**: Automatic garbage collection and memory leak prevention every 5 minutes

#### Enhanced Error Handling
- **Process Protection**: Overrides process.exit() to prevent accidental shutdowns
- **Signal Handling**: Graceful handling of SIGTERM, SIGINT without actual termination
- **Error Recovery**: Comprehensive error catching without service interruption
- **Connection Management**: Disabled server timeouts, keep-alive connections

#### System Monitoring Endpoints
- `/health` - Basic health check with monitoring status
- `/api/system-status` - Comprehensive system status dashboard
- Real-time monitoring dashboard with Arabic interface

#### Deployment Configuration
- **Autoscale Deployment**: Configured for automatic scaling
- **Startup Scripts**: Shell scripts for automated service management
- **Configuration Files**: JSON-based deployment configuration
- **Replit Integration**: Optimized for Replit's infrastructure

## Standalone Server Architecture

### Independent Deployment System
معاذ AI now supports complete standalone deployment that operates independently without relying on development platforms:

#### Docker-Based Deployment
- **Complete Containerization**: Full Docker and Docker Compose setup for isolated deployment
- **Multi-Service Architecture**: Separate containers for app, database, monitoring, and reverse proxy
- **Production-Ready**: Nginx reverse proxy with SSL support and security headers
- **Automated Backups**: Daily PostgreSQL backups with retention management
- **Health Monitoring**: Prometheus-based monitoring with custom metrics

#### System Integration
- **Linux Service Integration**: Full systemd service configuration for native OS integration
- **Automatic Restart**: Unlimited restart capability with intelligent failure handling
- **Resource Management**: Memory and CPU optimization with garbage collection
- **Security Hardening**: UFW firewall configuration and process isolation

#### Deployment Methods
- **Quick Docker Deploy**: One-command deployment using docker-compose
- **Full System Install**: Complete Linux system integration with systemd services
- **Hybrid Deployment**: Development and production environment support

#### Management Tools
- **Quick Start Script**: Interactive deployment and management interface
- **Monitoring Dashboard**: Real-time system status and performance metrics
- **Backup System**: Automated daily backups with compression and retention
- **Log Management**: Centralized logging with rotation and analysis tools

## Changelog
```
Changelog:
- June 26, 2025. Initial setup with Arabic AI chat interface
- June 26, 2025. Added Google Gemini 2.5 Flash integration (branded as معاذ AI من Moaaz AI)
- June 26, 2025. Implemented API key management system with dynamic updates
- June 26, 2025. Added AI status monitoring and real-time indicators
- June 26, 2025. Configured for 24/7 continuous operation with keep-alive mechanisms
- June 26, 2025. Removed text formatting from AI responses for cleaner output
- June 26, 2025. Enhanced error handling and process stability features
- June 26, 2025. Added password protection system (password: "moaaz ai")
- June 26, 2025. Removed suggested questions from welcome interface
- June 26, 2025. Removed success notification toasts for cleaner UX
- June 26, 2025. Enhanced uptime monitoring with automated health checks
- June 26, 2025. Implemented comprehensive permanent service architecture
- June 26, 2025. Added multi-layer monitoring system (uptime, external ping, watchdog)
- June 26, 2025. Created system status dashboard with real-time Arabic interface
- June 26, 2025. Enhanced process protection and error recovery mechanisms
- June 26, 2025. Configured unlimited restart capability and memory management
- June 26, 2025. Integrated Telegram bot for remote website control
- June 26, 2025. Added comprehensive admin commands for API management
- June 26, 2025. Implemented secure authentication and system monitoring via Telegram
- June 26, 2025. Created automated alerts and notifications system
- June 26, 2025. Completed automatic API key validation system in Telegram bot
- June 26, 2025. Added real-time system monitoring and control commands
- June 26, 2025. Implemented functional restart, health check, and logs commands
- June 26, 2025. Bot now fully operational with token 7046260843:AAHbjuQUa5ONKdcZxaX-CxJyYvBT5Jtar4Y
- June 26, 2025. Created comprehensive standalone server deployment system
- June 26, 2025. Added Docker containerization with multi-service architecture
- June 26, 2025. Implemented Linux systemd integration for native OS deployment
- June 26, 2025. Added Nginx reverse proxy with SSL/HTTPS support and security headers
- June 26, 2025. Created automated backup system with PostgreSQL integration
- June 26, 2025. Added Prometheus monitoring with custom metrics and dashboards
- June 26, 2025. Implemented quick-start deployment script with interactive menu
- June 26, 2025. Added comprehensive documentation for standalone deployment
- June 26, 2025. Configured firewall protection and security hardening
- June 26, 2025. Completed fully independent 24/7 server architecture
- June 26, 2025. Added Vercel cloud deployment with serverless functions
- June 26, 2025. Created optimized vercel.json configuration with security headers
- June 26, 2025. Implemented API routes for Vercel serverless functions
- June 26, 2025. Added automated deployment script for Vercel platform
- June 26, 2025. Configured CDN optimization and custom domain support
- June 26, 2025. Added comprehensive Vercel deployment documentation
- June 26, 2025. Created admin dashboard with Telegram bot control interface
- June 26, 2025. Added API endpoints for remote bot management from website
- June 26, 2025. Implemented send messages, API key updates, and bot restart features
- June 26, 2025. Integrated admin panel accessible via /admin route
- June 26, 2025. Completed full Vercel migration setup with custom domain support
- June 26, 2025. Configured independent 24/7 operation without Replit dependency
- June 26, 2025. Added /ai command to Telegram bot for sending all project files
- June 26, 2025. Implemented comprehensive file collection and batch sending system
- June 26, 2025. Added support for text file preview and document attachment in Telegram
- June 26, 2025. Added /whoami command to check admin status and improved authentication flow
- June 26, 2025. Enhanced help menu with complete command documentation for /ai functionality
- June 26, 2025. Fixed /ai command to send files as documents instead of text to preserve original format
- June 26, 2025. Improved rate limiting with smaller batches and automatic retry mechanism
- June 26, 2025. Added file size information and better progress tracking for file transfers
- June 26, 2025. Modified /ai command to send all files simultaneously without delays
- June 26, 2025. Added file counter display and completion message for bulk file transfers
- June 26, 2025. Enhanced /ai command to include comprehensive project files (config, docs, deployment, database)
- June 26, 2025. Added organized batch processing with progress updates every 50 files
- June 26, 2025. Implemented proper error handling and conflict resolution for Telegram bot
- June 26, 2025. Added /au command with ZIP compression functionality for organized folder delivery
- June 26, 2025. Created 6 categorized ZIP files: Frontend, Backend, API, Config, Documentation, Deployment
- June 26, 2025. Created /frontend command to send only frontend files for GitHub/Vercel deployment
- June 26, 2025. Added smart filtering to exclude server files and include only client-side code and configs
- June 26, 2025. Optimized file selection for standalone frontend deployment on cloud platforms
- June 26, 2025. Enhanced /frontend command to include API endpoints and complete documentation
- June 26, 2025. Added comprehensive file filtering for GitHub repository and Vercel deployment
- June 26, 2025. Updated command to include all necessary files for standalone cloud deployment
- June 26, 2025. Added /au command to send all project files as text content in consolidated messages
- June 26, 2025. Implemented smart message splitting to handle Telegram's character limits
- June 26, 2025. Created comprehensive text-based file transfer system for easy copying
- June 26, 2025. Updated /au command to display organized file list instead of file contents
- June 26, 2025. Added directory-based organization with custom file type icons
- June 26, 2025. Implemented efficient file listing to avoid Telegram rate limits
- June 26, 2025. Added website management commands: /changepass, /sitehealth, /deploy, /logs
- June 26, 2025. Implemented dynamic password changing for website authentication
- June 26, 2025. Added comprehensive site health monitoring and Vercel deployment integration
- June 26, 2025. Enhanced file transfer system with exponential backoff rate limiting
- June 26, 2025. Fixed markdown parsing issues in file list display
```

## User Preferences

Preferred communication style: Simple, everyday language.