# Practice Perfect

Practice Perfect is a mobile app to help musicians (especially young students in school music programs) practice their instruments through games with structured practice and scoring. It can also help music teachers (especially in school music programs) keep their students motivated to practice and making assignments. Users can choose from a number of songs pulled from the API, and can adjust what key their instrument is tuned to and what clef they want the music to be displayed in. In addition to a selection of songs to choose from, the user can also practice scales and arpeggios in any key. There is also a tuner function. Users' top scores are saved over time, and a user can see their practice history (including daily streaks and minutes practiced per day) graphed out on the 'History' page. 



## Architecture

* iOS and SwiftUI
* PostgreSQL

Our back end repo: https://github.com/dartmouth-cs98/19f-practiceperfect-api/

CircleCI: https://circleci.com/gh/dartmouth-cs98



## Setup and Deployment

Install and open with XCode 11.1+ (currently optimized for simulation on iPhone 11/iPhone XR).
* In Practice Perfect directory, install CocoaPods.
    * `sudo gem install cocoapods` or other installation method found here: https://guides.cocoapods.org/using/getting-started.html
    * or `pod repo update`, `pod install`
* `open PracticePerfect.xcworkspace`

The app can be tested through TestFlight using the following link: https://testflight.apple.com/join/z5Oir6TA


## Authors

Anna Matusewicz, Sean Hawkins, Sophie Debs, Abigail Chen



## Acknowledgments
* [Lists Tutorial](https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation)
* [File Download Tutorial](https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started)
* [SWXMLHash documentation](https://github.com/drmohundro/SWXMLHash)
* The songs being used are for educational purposes and not commercial use
* Special thanks to our professor Tim Tregubov!!!
