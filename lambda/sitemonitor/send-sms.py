#!/usr/bin/python
from twilio.rest import TwilioRestClient

# put your own credentials here
ACCOUNT_SID = "ACf04ca113b9cf9bdc0f2b44eb069b3377"
AUTH_TOKEN = "4d59ef7cfddc01da9c288f7b953ae26e"

client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN)

client.messages.create(
    to="6083183642",
    from_="+16084409584",
    body="test MESSAGE",
)
