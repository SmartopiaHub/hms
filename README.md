# Homework Management System
Smartopia Homework Management System (HMS) is a cross-platform solution for parents and children to manage homework and rewards. AI coders were heavily used in its development.

## Features

- Modern UI (responsive design)
- Localization (Chinese/English)
- Multi-platform: Web, Windows, macOS, Linux, Android, iOS
- Real-time notifications (SSE)
- Reward shop, redemption history, image uploads
- Parent/child roles, authentication
- Dockerized server for easy deployment

## Configuration

The server uses three configuration files located in `server/data/config/`:

### 1. config.json

Main server configuration file.

**Location**: `server/data/config/config.json`

**Fields**:
```json
{
  "pointSystemEnabled": true,
  "default_admin_password": "admin"
}
```

- `pointSystemEnabled` (boolean, default: `true`): Enable/disable the point reward system for completed tasks
- `default_admin_password` (string, default: `"admin"`): Password for the default admin user created on first startup

**Notes**: 
- If the file doesn't exist, the server will create it with default values
- The default admin username is always `admin`

### 2. mqtt.json

MQTT broker configuration for real-time task notifications.

**Location**: `server/data/config/mqtt.json`

**Fields**:
```json
{
  "host": "10.0.0.2",
  "port": 1883,
  "clientId": "hms_server",
  "username": "mqtt_user",
  "password": "your_mqtt_password",
  "topicPrefix": "hms/task"
}
```

- `host` (string, required): MQTT broker hostname or IP address
- `port` (number, required): MQTT broker port (default: 1883)
- `clientId` (string, optional, default: `"hms_server"`): Client identifier for the MQTT connection
- `username` (string, optional): MQTT authentication username
- `password` (string, optional): MQTT authentication password
- `topicPrefix` (string, optional, default: `"hms/task"`): Topic prefix for publishing task notifications

**Notes**:
- MQTT is optional. If the file doesn't exist or connection fails, the server will continue without MQTT
- MQTT can be configured from the admin settings page in the web interface

### 3. ai_config.json

AI service configuration for task extraction from images and voice.

**Location**: `server/data/config/ai_config.json`

**Fields**:
```json
{
  "provider": "openai",
  "model": "gpt-4o",
  "openaiApiKey": "sk-proj-...",
  "geminiApiKey": "...",
  "systemPrompt": "You are an AI assistant that extracts homework tasks..."
}
```

- `provider` (string, required): AI provider to use (`"openai"` or `"gemini"`)
- `model` (string, optional): Model name to use (e.g., `"gpt-4o"`, `"gemini-pro"`)
- `openaiApiKey` (string, optional): OpenAI API key (required if provider is `"openai"`)
- `geminiApiKey` (string, optional): Google Gemini API key (required if provider is `"gemini"`)
- `systemPrompt` (string, optional): Custom system prompt for task extraction

**Notes**:
- AI features are optional. If not configured, AI extraction features will be unavailable
- Can be configured from the admin settings page in the web interface
- API keys are never sent to the client for security

## How to Deploy & Build

### 1. Deploy Web
```bash
./deploy_web.sh
```
This builds and deploys the web client to the `server/public` folder for serving static files.

### 2. Build Flutter Clients
```bash
./build_clients.sh
```
Builds supported Flutter clients (web, desktop, mobile). For Windows, you need to build the client from a Windows machine. Similar requirements for macOS and iOS. The built client apps will be copied into `server/data/clients` folder for downloading from the web portal.

### 3. Build Docker Image
```bash
docker build -f server/Dockerfile -t smartopiahub/hms-server:latest .
```
Builds the server Docker image with all dependencies and static files.

### 4. Docker Compose Up
```bash
cd server
docker-compose up -d --build
```
- **Data Folder**: By default, `/server/data` is mounted to `/data` in the container. Change the `volumes` section in `docker-compose.yaml` to use a custom path.

### Git pre-commit hook: Auto-increment pubspec.yaml version

This project includes a `pre-commit` hook that automatically increments the patch version in all `pubspec.yaml` files before each commit.

**How to enable:**
1. Copy the script to `.git/hooks/pre-commit` in your repo root.
2. Make it executable:
	```bash
	chmod +x .git/hooks/pre-commit
	```
3. On every commit, the hook will update the patch version and stage the changes.

**Note:**
- Git hooks are local and not shared via git. Each developer must set up the hook manually.
- For team-wide hooks, consider using [pre-commit](https://pre-commit.com/) or document these steps for your team.


## TODO

- [x] Modern UI design
- [x] ZH/EN localization
- [x] Multi-platform support
- [x] Dockerized deployment
- [ ] Test Android/iOS/Windows app
- [ ] Secure http connection
- [ ] Beautify drawer and task filter panels
- [ ] More date range options in task search
- [ ] Mobile app notifications via Firebase
- [ ] Craft SSE notification messages
- [ ] Edit individual task instance
- [ ] Clean-up stale/canceled tasks