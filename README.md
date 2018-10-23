# CallBlocker

Application for processes incoming phone calls, and texts.

## Description

The app is using Call Directory app extension to identify and block incoming callers by their phone number, and also app is using Message Filter Extension for blocking sms/mms with a specific keyword.

## Features

Call Blocker:
Incoming calls can be in one of three states:
1. Regular calls (it will ring and pass through the device)
2. Suspicious calls (it will ring and pass through device with a warning)
3. Blocked calls (it will not ring and not pass through the device)

Message Filter:
It will filter messages by specific keyword, but only if the message is received from unknown senders.

This example also includes unit tests


Call directory extension works on iOS 10+

Message Filter extension works on iOS 11+




