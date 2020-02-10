//
//  AppDelegate.swift
//  PracticePerfect
//
//  Created by Abigail Chen on 11/3/19.
//  Copyright © 2019 CS98PracticePerfect. All rights reserved.
//

import UIKit
import GoogleSignIn
public var userData: [String:String] = [:]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          // Initialize sign-in
          GIDSignIn.sharedInstance().clientID = "379100583609-kjmvkoo9dl6v2i0mah3fuib337f8c77o.apps.googleusercontent.com"
          GIDSignIn.sharedInstance().delegate = self

          return true
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        print("here")
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
            print("\(error.localizedDescription)")
        }
        return
        }
      // Perform any operations on signed in user here.
        print("here without errors")
        print(user)
        userData["username"] = user.userID;                  // For client-side use only!
        userData["id"] = user.authentication.idToken // Safe to send to the server
        userData["name"] = user.profile.name
        //      let givenName = user.profile.givenName
        //      let familyName = user.profile.familyName
        userData["email"] = user.profile.email
      // ...
    }


}

