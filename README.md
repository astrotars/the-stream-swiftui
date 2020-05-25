# Stream Flutter: Building a Social Network with Stream and Flutter
## Part 4: 1-on-1 Video Chat 

In the fourth part of our series on building a social network, we'll integrate video chat. To do this, we integrate [Dolby.io](https://dolby.io)'s [Interactivity APIs](https://dolby.io/products/interactivity-apis), formally known as [Voxeet](https://www.voxeet.com/), into our application. Note the library is still named Voxeet.

For this part, the application will support 1-on-1 private chat. Since Dolby is a purely client side library, we only touch our `ios` application. The `backend` remains unchanged. The app performs these steps:

* Initialize Voxeet libraries
* When a user navigates to the "People" screen show a video icon next to a user's name.
* When a user clicks this icon, start and join a Voxeet conference with a unique alias. The user waits for the other party to join.
* When the other user joins following the previous steps, they'll be placed in a 1-on-1 conference. 

Voxeet's [UXKit](https://github.com/voxeet/voxeet-uxkit-ios) takes care of the connection and presentation for this 1-on-1 call. Our application just needs to create and join the call at the appropriate time.

Let's dive in.

### Step 1: Create a Dolby Account

Go to [dolby.io](https://dolby.io) and create an account. Once registered, navigate to the Dashboard (you can click in the top right if you're not there). Find the list of applications:

![](images/dolby-applications.png)

If you already have an app ("my first app") click into it. If you don't create an app by hitting "Add New App". Now we can grab our API key and secret for our application. The keys we need are under the "Interactivty APIs" section. :

![](images/dolby-keys.png)

Click on "Show Secret" to view the secret. 

### Step 2: Confgure the Voxeet UXKit Library

Since the Voxeet library is not tied to an account, we can configure it on application load. Change our `AppDelegate` to this:

```swift
// ios/TheStream/AppDelegate.swift:1
import UIKit
import VoxeetSDK
import VoxeetUXKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Voxeet SDKs initialization.
        VoxeetSDK.shared.initialize(consumerKey: "<VOXEET_CONSUMER_KEY>", consumerSecret: "<VOXEET_CONSUMER_SECRET>")
        VoxeetUXKit.shared.initialize()
        
        // Example of public variables to change the conference behavior.
        VoxeetSDK.shared.notification.push.type = .none
        VoxeetSDK.shared.conference.defaultBuiltInSpeaker = true
        VoxeetSDK.shared.conference.defaultVideo = true
        VoxeetUXKit.shared.appearMaximized = true
        VoxeetUXKit.shared.telecom = true
        
        return true
    }
    
    // ...
}
```

Change `<VOXEET_CONSUMER_KEY>` and `<VOXEET_CONSUMER_SECRET>` to the values you retrieved in Step 1. We configure Voxeet to not have any push notifications, turn on the speaker and video by default, and appear maximized. We also set `telecom` to true. When true, the conference will behave like a cellular call meaning when either party hangs up, or declines the call (not implemented in this tutorial), it will end the call. 

If you'd like to use push notifications to notify a user when a call is incoming, check out [CallKit](https://developer.apple.com/documentation/callkit) combined with `VoxeetSDK.shared.notification.push.type`. This is out of scope for this tutorial.

### Step 3: 