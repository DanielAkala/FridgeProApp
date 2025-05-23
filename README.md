FridgePro is a lightweight iOS application that helps users manage their refridgerator contents, reduce food waste, and plan smarter meals.

FEATURES
Add food items with name, quantity, and expiration date
Receive local notification the day the item expires
Expired, expiring soon, and default indicators
Swipe to mark items as used
View meala ideas based on fridge contents
Clean-out reminder when 3+ items are expired
Core Data-powered offline storage (no Firebase or Cloudkit)

TECHNOLOGIES USED
**SWiftUI** - Declarative UI
**Core Data** - Local data storage
**UserNotifications** - Local alerts
**MVVM Pattern** - Seperation of concerns
**XCode 15+**, **Swift 5.9+**

PROJECT STRUCTURE
ContentView.swift - Main dashboard with food items list
AddItemView.swift - Add food UI + notificartion setup
ShoppingListView.swift - Shopping cart screen
Persistence.swift - Core Data stack setup
FridgePalApp.swift - App entry point + notification setup
Recipe.swift - Static recipe data model

SETUP INSTRUCTIONS
Open FridgePal.xcodeproj in XCode
Select a development team under *Signing and Capabilities
Set deployment tartget to iOS 14 or above
Build and run on simulator or real device


FRIDGEPRO WAS BUILT FOR AN IOS MOBILE DEVELOPMENT COURSE AT CAL STATE FULLERTON.**WASTE NOT, WANT NOT**
