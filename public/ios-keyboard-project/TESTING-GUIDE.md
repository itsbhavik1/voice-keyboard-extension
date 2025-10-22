# Testing Guide for Voice Keyboard Extension

## Pre-Testing Setup

### 1. Get Groq API Key
1. Visit https://console.groq.com
2. Sign up or log in
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key (you won't be able to see it again)

### 2. Device Setup
- Use a **physical iOS device** for best results
- Simulator can be used but microphone may not work properly
- iOS 14.0 or later required

### 3. Build Configuration
- Build in **Debug** mode for testing
- Use **Release** mode for performance testing
- Ensure code signing is configured

## Installation and Setup Testing

### Test 1: App Installation
- [ ] App installs successfully
- [ ] App icon appears on home screen
- [ ] App launches without crashes
- [ ] Main screen displays properly

### Test 2: Microphone Permission
- [ ] Tap "Grant Microphone Permission" button
- [ ] System permission dialog appears
- [ ] Permission granted successfully
- [ ] Button updates to show granted status
- [ ] Re-opening app remembers permission status

### Test 3: API Key Configuration
- [ ] Enter API key in text field
- [ ] Tap "Save API Key"
- [ ] Success message appears
- [ ] Close and reopen app
- [ ] Status shows "API key configured ✓"

### Test 4: Keyboard Installation
1. Go to **Settings > General > Keyboard > Keyboards**
2. Tap **Add New Keyboard**
3. Verify:
   - [ ] "VoiceKeyboard" appears in list
   - [ ] Tap to add keyboard
   - [ ] Keyboard added successfully
   - [ ] Appears in keyboard list

### Test 5: Full Access Permission
1. In **Settings > General > Keyboard > Keyboards**
2. Tap **VoiceKeyboard**
3. Verify:
   - [ ] "Allow Full Access" toggle present
   - [ ] Toggle can be enabled
   - [ ] Warning message appears explaining why access is needed
   - [ ] Confirm enabling full access

## Functional Testing

### Test 6: Keyboard Activation
1. Open any app with text input (Notes, Messages, Safari)
2. Tap text field to show keyboard
3. Long-press globe icon (🌐)
4. Verify:
   - [ ] VoiceKeyboard appears in keyboard list
   - [ ] Can select VoiceKeyboard
   - [ ] Keyboard switches successfully
   - [ ] Custom keyboard UI appears

### Test 7: UI Display
When keyboard appears, verify:
- [ ] Microphone button centered and visible
- [ ] Button size appropriate (~120pt)
- [ ] Button color matches design (blue in idle)
- [ ] Background color correct for light/dark mode
- [ ] No layout issues or overlapping elements

### Test 8: Recording Interaction
1. Press and hold microphone button
2. While holding, verify:
   - [ ] Button immediately changes to red
   - [ ] Pulsing animation starts
   - [ ] Haptic feedback occurs on press
   - [ ] Recording indicator visible

3. Speak clearly: "Testing voice keyboard"
4. Continue holding for 3-5 seconds

5. Release button
6. Verify:
   - [ ] Recording stops immediately
   - [ ] Haptic feedback occurs on release
   - [ ] Button shows processing state (gray with spinner)
   - [ ] Processing indicator animates

### Test 9: Transcription Success
After releasing button:
- [ ] Processing indicator shows for 1-5 seconds
- [ ] Transcribed text appears at cursor
- [ ] Text matches spoken words reasonably well
- [ ] Space added after text
- [ ] Button returns to idle state (blue)
- [ ] Success haptic feedback plays
- [ ] Can immediately start new recording

### Test 10: Multiple Recordings
1. Complete 5 recordings in a row
2. Verify:
   - [ ] Each recording works independently
   - [ ] No memory leaks or slowdowns
   - [ ] Text insertion works every time
   - [ ] No accumulated lag

### Test 11: Dark Mode Support
1. Enable Dark Mode in iOS Settings
2. Switch to VoiceKeyboard
3. Verify:
   - [ ] Background color changes appropriately
   - [ ] Button colors remain visible
   - [ ] Text colors adapt to dark mode
   - [ ] All UI elements readable

## Error Handling Testing

### Test 12: No Internet Connection
1. Enable Airplane Mode
2. Record and release
3. Verify:
   - [ ] Error message displays
   - [ ] Message says "Network error" or similar
   - [ ] Error shown for 2 seconds
   - [ ] Button returns to idle
   - [ ] Error haptic feedback plays
   - [ ] Can retry after reconnecting

### Test 13: Invalid API Key
1. In main app, enter invalid API key
2. Save and switch to keyboard
3. Record and release
4. Verify:
   - [ ] Error message displays
   - [ ] Message mentions API key issue
   - [ ] Keyboard doesn't crash
   - [ ] Can fix key and retry

### Test 14: API Timeout
1. Use slow network connection
2. Record long audio (30+ seconds)
3. Verify:
   - [ ] Timeout error after 30 seconds
   - [ ] Appropriate error message
   - [ ] Keyboard remains functional

### Test 15: Permission Denied
1. Revoke microphone permission in Settings
2. Try to record
3. Verify:
   - [ ] Error message about permission
   - [ ] Keyboard doesn't crash
   - [ ] Instructions to enable permission

### Test 16: No Full Access
1. Disable "Allow Full Access" in Settings
2. Try to record and transcribe
3. Verify:
   - [ ] Network request fails gracefully
   - [ ] Error message explains full access needed
   - [ ] Keyboard doesn't crash

### Test 17: Very Short Recording
1. Press and immediately release (< 0.5 seconds)
2. Verify:
   - [ ] Recording still attempts
   - [ ] Either transcribes or shows error
   - [ ] No crash occurs

### Test 18: Maximum Duration
1. Press and hold for over 60 seconds
2. Verify:
   - [ ] Recording stops at 60 seconds
   - [ ] Transcription processes
   - [ ] No crash or error

## Performance Testing

### Test 19: Memory Usage
1. Use Xcode Instruments with Memory Profiler
2. Perform 20 recordings
3. Verify:
   - [ ] Memory usage stays under 25MB
   - [ ] No memory leaks detected
   - [ ] Memory released after each recording

### Test 20: Response Time
Measure times:
- [ ] Recording starts: < 100ms after press
- [ ] Recording stops: Immediate on release
- [ ] Transcription: < 10s for 10s audio
- [ ] UI updates: < 100ms

### Test 21: Battery Impact
1. Use keyboard continuously for 10 minutes
2. Check battery usage in Settings
3. Verify:
   - [ ] Reasonable battery consumption
   - [ ] No excessive drain

## Edge Case Testing

### Test 22: Background Audio
1. Play music in another app
2. Switch to keyboard and record
3. Verify:
   - [ ] Recording works
   - [ ] Music pauses during recording
   - [ ] Music resumes after (if configured)

### Test 23: Phone Call Interruption
1. Start recording
2. Receive phone call
3. Verify:
   - [ ] Recording stops gracefully
   - [ ] No crash
   - [ ] Keyboard recovers after call

### Test 24: App Switching
1. Start recording
2. Switch to another app mid-recording
3. Verify:
   - [ ] Recording stops
   - [ ] No crash on return
   - [ ] Keyboard resets to idle

### Test 25: Rapid Interactions
1. Rapidly tap button (don't hold)
2. Verify:
   - [ ] No crash
   - [ ] Keyboard remains responsive
   - [ ] States transition correctly

### Test 26: Different Text Fields
Test in various apps:
- [ ] Notes app
- [ ] Messages
- [ ] Safari URL bar
- [ ] Safari text area
- [ ] Email compose
- [ ] Third-party apps

### Test 27: Cursor Position
1. Type some text
2. Move cursor to middle
3. Record and insert
4. Verify:
   - [ ] Text inserts at cursor position
   - [ ] Existing text not affected
   - [ ] Cursor moves to end of inserted text

## Compatibility Testing

### Test 28: iPhone Models
Test on different iPhone models:
- [ ] iPhone SE (small screen)
- [ ] iPhone 14/15 (standard)
- [ ] iPhone 14/15 Pro Max (large screen)

### Test 29: iPad Support
If supporting iPad:
- [ ] Keyboard height correct (264pt)
- [ ] Button size appropriate
- [ ] Layout looks good on larger screen

### Test 30: iOS Versions
Test on:
- [ ] iOS 14.0 (minimum supported)
- [ ] iOS 15.x
- [ ] iOS 16.x
- [ ] iOS 17.x (latest)

## Accessibility Testing

### Test 31: VoiceOver
1. Enable VoiceOver
2. Verify:
   - [ ] Button is labeled properly
   - [ ] States announced clearly
   - [ ] Keyboard navigation works

### Test 32: Dynamic Type
1. Increase text size in Settings
2. Verify:
   - [ ] Text remains readable
   - [ ] Layout doesn't break

## Acceptance Criteria

### Must Pass (Critical):
- ✅ Recording starts and stops correctly
- ✅ Transcription works and text inserts
- ✅ No crashes during normal use
- ✅ Error handling functional
- ✅ Permission requests work

### Should Pass (Important):
- ✅ Dark mode support
- ✅ Haptic feedback works
- ✅ Memory stays under limits
- ✅ Performance acceptable

### Nice to Have:
- ✅ Works across all iOS versions
- ✅ Perfect on all device sizes
- ✅ Accessibility fully supported

## Bug Reporting Template

When bugs are found, document:
```
**Bug Title**: [Short description]
**Severity**: [Critical/High/Medium/Low]
**Device**: [iPhone model, iOS version]
**Steps to Reproduce**:
1. 
2. 
3. 

**Expected**: [What should happen]
**Actual**: [What actually happened]
**Screenshot/Video**: [If applicable]
**Console Logs**: [Any relevant errors]
```

## Testing Sign-off

Tester: ________________
Date: ________________
iOS Version: ________________
Device: ________________

✅ All critical tests passed
✅ No blocking issues found
✅ Ready for submission
