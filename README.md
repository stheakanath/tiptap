# tiptap
Tip Tap allows you to easily pay tips digitally with a simple shake of your phone.

![Screenshot](http://i.imgur.com/x6KNKck.png)

## iOS

Our iOS backend connects to Parse and the Nessie frameworks transfer our payments. We first retrieve the location of the devices on launch and once the user whips both phones, a payment is initiated. 

## Parse Cloud and Backend
The backend of the app is built on Parse. The primary task that the backend handles is pairing the user giving the tip with the user receiving the tip. It handles this by using the sensors on the iPhone to narrow down which two users are interacting. The algorithm uses 2 important metrics: GPS data and accelerometer data. With these, the backend is able to narrow down which two people are bumping their phones together by first narrowing down which phones are within 10 meters of you. Then, it uses information about your shaking of the phone to further narrow the backend's search. In addition, the specific time that the shake happens (in milliseconds), which will be very similar for two people bumping, can be used to eliminate other phones that might happen to be nearby and also shaking at almost the same time.

After this, the backend communicates the match down to the phone initiating the transaction, at which point the tipper confirms the identity of the person they are trying to tip. After this, the Parse backend initiates a cash transfer between these two users. For this, the app makes use of the Capital One API, Nessie. Using the Nessie ID, it completes the transaction and informs both users of completion, with the payment recipient getting a push notification.

## Team

Built at the Capital One hackathon, this was a project by Jeff Chang, Harrison Huang, Ankit Mathur, Gabbi Merz, and Sony Theakanath.
