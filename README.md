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