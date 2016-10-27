#!/usr/bin/python
from twilio.rest import TwilioRestClient

# put your own credentials here
ACCOUNT_SID = "MG4d4e94e8274e1c7c8384bba545f2757c"
AUTH_TOKEN = "4d59ef7cfddc01da9c288f7b953ae26e"

client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN)

client.messages.create(
    to="+1608318342",
    from_="+16084409584",
    body="This is the ship that made the Kessel Run in fourteen parsecs?",
#    media_url="https://c1.staticflickr.com/3/2899/14341091933_1e92e62d12_b.jpg",
)



# Find these values at https://twilio.com/user/account
account_sid = "MG4d4e94e8274e1c7c8384bba545f2757c"
auth_token = "4d59ef7cfddc01da9c288f7b953ae26e"

toNumb = "+!6083183642"
fromNumb = "+16084409584"

client = TwilioRestClient(account_sid, auth_token)

message = client.messages.create(to = toNumb, from_ = fromNumb,
                                     body="Hello there!")
