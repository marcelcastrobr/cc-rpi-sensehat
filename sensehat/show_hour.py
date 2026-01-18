#!/usr/bin/env python3
from sense_hat import SenseHat
from datetime import datetime
import time

sense = SenseHat()

while True:
    # Get current hour in 12-hour format
    hour = datetime.now().hour % 12
    if hour == 0:
        hour = 12  # 12 AM/PM instead of 0

    # Display first digit of the hour
    sense.show_letter(str(hour)[0])

    # Wait 60 seconds before updating
    time.sleep(60)
