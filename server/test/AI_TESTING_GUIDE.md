# AI Service Test Guide

## Overview
This guide helps you test the AI integrations (OpenAI and Gemini) for task extraction.

## Prerequisites

### 1. Get API Keys

**OpenAI:**
- Visit https://platform.openai.com/api-keys
- Create a new API key
- Save it securely (starts with `sk-proj-...`)

**Google Gemini:**
- Visit https://aistudio.google.com/app/apikey
- Generate an API key
- Save it securely

### 2. Set Up Configuration

```bash
cd server

# Method 1: Via API (recommended)
# Start the server
dart_frog dev --port 8088

# Then use curl or navigate to the client UI
curl -X POST http://localhost:8088/api/config/ai \
  -H "Content-Type: application/json" \
  -d '{
    "provider": "openai",
    "openaiApiKey": "sk-proj-YOUR-KEY-HERE"
  }'

# Method 2: Manual config file
mkdir -p data
cat > data/ai_config.json << EOF
{
  "provider": "openai",
  "openaiApiKey": "sk-proj-YOUR-KEY-HERE"
}
EOF
```

### 3. Prepare Test Files

Create `server/test/fixtures/` directory and add test files:

```bash
mkdir -p test/fixtures

# Add a to-do list image (take a photo of a handwritten list)
# Save as: test/fixtures/test_todo_list.jpg

# Record a short voice memo
# Save as: test/fixtures/test_audio.m4a
# Example: "Please remind me to review the project docs and submit the report by Friday"
```

## Running Tests

### Quick Config Test
```bash
cd server
dart test/ai_service_test.dart
```

This will verify configuration save/load works.

### Full Testing (requires API keys)

1. **Uncomment tests** in `ai_service_test.dart`
2. **Run specific tests:**

```bash
# Test Whisper (audio transcription)
dart test/ai_service_test.dart

# Check console output for extracted tasks
```

## Manual API Testing

### Test OpenAI Whisper
```bash
curl -X POST https://api.openai.com/v1/audio/transcriptions \
  -H "Authorization: Bearer YOUR_OPENAI_KEY" \
  -F "file=@test_audio.m4a" \
  -F "model=whisper-1"
```

### Test GPT-4 Vision
```bash
# First, convert image to base64
base64 test_todo_list.jpg > image_base64.txt

# Then send to API (create a JSON file or use a tool)
```

### Test Gemini
```bash
# Base64 encode image
base64 test_todo_list.jpg > image_base64.txt

# Make request
curl -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=YOUR_GEMINI_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Extract tasks from this image as JSON"},
        {"inline_data": {"mime_type": "image/jpeg", "data": "BASE64_DATA_HERE"}}
      ]
    }]
  }'
```

## End-to-End Testing

1. **Start Server:**
   ```bash
   dart_frog dev --port 8088
   ```

2. **Upload Test Media:**
   ```bash
   curl -X POST http://localhost:8088/api/extract_tasks \
     -F "images=@test/fixtures/test_todo_list.jpg"
   ```

3. **Check Response:**
   Should return JSON array of extracted tasks:
   ```json
   [
     {
       "title": "Review project documentation",
       "description": "Read and provide feedback",
       "priority": 4,
       "expectedCompletionTimeInMinutes": 45
     }
   ]
   ```

## Testing from Client App

1. **Configure AI Settings:**
   - Navigate to `/admin/ai-settings`
   - Enter API key
   - Save

2. **Create Task with Media:**
   - Go to Task Templates
   - Tap "+" button
   - Choose "Camera", "Voice", or "Gallery"
   - Upload/capture content
   - Verify tasks appear in review page

3. **Verify Results:**
   - Check extracted task titles
   - Verify descriptions are meaningful
   - Confirm priorities are reasonable
   - Test editing and saving

## Troubleshooting

### "AI configuration not found"
- Run configuration API call or check `data/ai_config.json` exists

### "OpenAI API error: 401"
- Invalid API key, regenerate from OpenAI dashboard

### "Gemini API error: 400"
- Check API key is valid
- Verify image is base64 encoded properly

### "No JSON array found in response"
- AI didn't return proper format
- Try adjusting system prompt
- Check AI response in server logs

## Expected Costs

**OpenAI:**
- GPT-4 Vision: ~$0.01 per image
- Whisper: ~$0.006 per minute

**Gemini:**
- Free tier: 15 req/min
- Very low cost if exceeding free tier

## Example Output

```
=== AI Service Integration Tests ===

Test 1: Configuration Management
-----------------------------------
✓ Config saved successfully
✓ Config loaded successfully
  Provider: openai
  Has OpenAI Key: true
  Model: gpt-4-vision-preview
✓ Configuration test passed

Test 2: OpenAI Whisper Transcription
----------------------------------------
✓ Extracted 2 tasks from audio
  Task 1: Review project documentation
  Task 2: Submit report by Friday
✓ Whisper test passed

=== All Tests Completed ===
```
