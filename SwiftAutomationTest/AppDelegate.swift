//
//  AppDelegate.swift
//

import UIKit
import AppleEvents


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        appleEventHandlers[eventOpenDocuments] = { (event: AppleEventDescriptor) throws -> Descriptor? in
            guard let desc = event.parameter(keyDirectObject) else { throw AppleEventError.missingParameter }
            print("open", try unpackAsArray(desc, using: unpackAsFileURL))
            return RootSpecifierDescriptor.app.elements(cDocument).byIndex(packAsInt32(1)) // return [list of] specifier identifying opened document[s]
        }
        appleEventHandlers[coreEventGetData] = { (event: AppleEventDescriptor) throws -> Descriptor? in
            guard let desc = event.parameter(keyDirectObject) else { throw AppleEventError.missingParameter }
            print("get", desc)
            return packAsString("Hello")
        }
        appleEventHandlers[coreEventClose] = { (event: AppleEventDescriptor) throws -> Descriptor? in
            guard let desc = event.parameter(keyDirectObject) else { throw AppleEventError.missingParameter }
            // TO DO: optional `saving` parameter
            print("close", desc)
            return nil
        }
        appleEventHandlers[eventQuitApplication] = { (event: AppleEventDescriptor) throws -> Descriptor? in
            print("quit")
            //CFRunLoopStop(CFRunLoopGetCurrent())
            return nil
        }
        let source = CFMachPortCreateRunLoopSource(nil, AppleEvents.createMachPort(), 1)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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


}

