# green_ride

Welcome to GreenRide - the app that helps you to save our planet by reducing your ecological footprint!

GreenRide motivates you to travel to work by bicycle instead of using your vehicle that harms the environment.

This will not only help our environment but also your own fitness and health condition.

GreenRide will show you a small tutorial on your first app launch to explain you the main goal and features of GreenRide.

You can skip the tutorial if you do not like it.

After the tutorial you can personalize the app by providing details about your daily work travel.

You can type in the origin and destination of your travel, the weekdays you go to work and the time you usually want to arrive at work.

After saving your information you will get your personalized route to your work.

You can see how long it will take you to go by bicycle instead of going by vehicle.

You can even see how many trees you are saving if you are traveling to work by bicycle. This data is based on your information you provided before.

If you are unsure if the weather will be suitable for bicycling you can check the current weather before you start to make sure you will not get wet.

All the data seen in the app is live data provided by the backends from Google Maps and Open Weather Map.

GreenRide is optimized for portrait and for landscape mode, so that it can be used on mobile phones, tablet or on the web.

A possible extension for GreenRide can be a leaderboard and competitions where people can compete to be the one who saved the planet most.

A notification function can remind the user in the future to not forget to take his bike, for example based on the current weather forecast.

We can also ask the user to input their car manufacturer and model to determine its fuel consumption and give a more accurate number of how many trees the user saved by bicycling.

We hope you will enjoy GreenRide and contribute by joining our movement to save our planet!



## Getting Started

You can find it deployed on firebase hosting here: https://greenride-9984c.web.app/

Known issues on web:

- after clicking on "Start Intro", to one site back in browser history and click again on "Start Intro"
- Google Maps not working (https://github.com/flutter/flutter/issues/45292)

To get it started on your machine:

- Create a google maps api key and follow steps from google maps plugin instruction to set the api key for your platform (https://pub.dev/packages/google_maps_flutter), e. g. for Android set it in the AndroidManifest.xml
- Set the google maps api key in the google_maps_client.dart.
- Create a open weather map api key and insert it in the weather_service.dart.

This app was build with flutter version 1.20.0-2.0.pre.