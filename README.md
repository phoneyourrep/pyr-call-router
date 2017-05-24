# pyr-twilio / Phone Your Rep Call Router
A simple Sinatra app that serves as an interface between the [Phone Your Rep](https://github.com/phoneyourrep/phone-your-rep-api) and Twilio APIs.

The call router receives a text message with a 5-digit zip code as the body and responds with a phone call offering to connect the user to the closest local office of each of their reps in Congress.

It uses the [PYR](https://github.com/phoneyourrep/pyr) gem to communicate with the Phone Your Rep API and the [twilio-ruby](https://github.com/twilio/twilio-ruby) gem for the Twilio API.

# Usage
Visit Twilio to set up an account and purchase a number, or use a free number for development and testing. On the configuration page for your new number, under the "Messaging" section, apply the following settings:
```
CONFIGURE WITH: Webhooks or TwiML Bins
A MESSAGE COMES IN: Webhook https://your-apps-base-url.com HTTP GET
```

Clone this repo and

```gem install bundler```

```bundle install```

Then set the following environment variables on the system running the app:

```
# The publicly available base URL for the app
# Should be the same as the Twilio Webhook URL from the Twilio config step
APP_URL="https://your-apps-base-url.com"

# The account SID and auth token can be found in your Twilio account dashboard
TWILIO_ACCOUNT_SID="xxxxxxxxxxxxxxxxxxx"
TWILIO_AUTH_TOKEN="xxxxxxxxxxxxxxxxxxx"

# Your new Twilio phone number
TWILIO_PHONE_NUMBER="xxx-xxx-xxxx"
```

When running this app locally you will need to make your server publicly available so Twilio can reach it. [ngrok](https://ngrok.com/) is great for this. Follow the installation instructions, then just run `./ngrok http 9393` to get a publicly available tunnel that exposes your local server (assuming you're using the default port 9393. You can sub out the port ID in the command to expose any port you wish). The url will look something like this `https://example.ngrok.io`. Go to your Twilio dashboard and plug in this URL as the webhook for your number. With your other environment variables already set, you can now start up the server with the `shotgun` command.

```
APP_URL=https://example.ngrok.io bundle exec shotgun
```

This app is ready to deploy to Heroku. Just don't forget to set your Heroku config vars as outlined above.

# Contributing

Contributions are welcome! Fork the repo and make your changes on a feature branch, then submit a PR. Then run the tests with `bundle exec rake` (if there aren't any tests yet they'll be added soon).

Please add RSpec tests that cover all new code, or if you prefer writing tests in another framework, add the test suite to the default Rake task to make sure they're run.
