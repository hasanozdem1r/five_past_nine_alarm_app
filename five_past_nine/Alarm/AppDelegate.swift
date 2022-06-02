//
//  AppDelegate.swift
//  WeatherAlarm
//
//  Hasan Özdemir
// 

import UIKit
import Foundation
import AudioToolbox
import AVFoundation

protocol AlarmApplicationDelegate
{

    func playAlarmSound(_ soundName: String)
   
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate{

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    var alarmScheduler: AlarmSchedulerDelegate = Scheduler()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        alarmScheduler.setupNotificationSettings()
        window?.tintColor = UIColor.red
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        //if app is in foreground, show a alert
        let storageController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .alert)
        var isSnooze: Bool = false
        var soundName: String = ""
        var index: Int = -1
        if let userInfo = notification.userInfo {
            isSnooze = userInfo["snooze"] as! Bool
            soundName = userInfo["soundName"] as! String
            index = userInfo["index"] as! Int
        }
        
        playAlarmSound(soundName)
        

       
        if isSnooze  == true
        {
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let now = Date()
            //snooze 5 minutes later
            let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 5, to: now, options:.matchStrictly)!
            
            let snoozeOption = UIAlertAction(title: "Snooze", style: .default) {
                (action:UIAlertAction)->Void in self.audioPlayer?.stop()
                
                self.alarmScheduler.setNotificationWithDate(snoozeTime, onWeekdaysForNotify: [Int](), snooze: true, soundName: soundName, index: index)
            }
            storageController.addAction(snoozeOption)
        }
        let stopOption = UIAlertAction(title: "OK", style: .default) {
            (action:UIAlertAction)->Void in self.audioPlayer?.stop()
            Alarms.sharedInstance.setEnabled(false, AtIndex: index)
            let vc = self.window?.rootViewController! as! UINavigationController
            let cells = (vc.topViewController as! MainAlarmViewController).tableView.visibleCells 
            for cell in cells
            {
                if cell.tag == index{
                    let sw = cell.accessoryView as! UISwitch
                    sw.setOn(false, animated: false)
                }
            }}
        
        storageController.addAction(stopOption)
        window?.rootViewController!.present(storageController, animated: true, completion: nil)
  
        
    }
    //notification handler, snooze
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void)
    {
        if identifier == "mySnooze"
        {
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let now = Date()
            let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 9, to: now, options:.matchStrictly)!
            var soundName: String = ""
            var index: Int = -1
            if let userInfo = notification.userInfo {
                soundName = userInfo["soundName"] as! String
                index = userInfo["index"] as! Int
            self.alarmScheduler.setNotificationWithDate(snoozeTime, onWeekdaysForNotify: [Int](), snooze: true, soundName: soundName, index: index)
        }
        }
        completionHandler()
    }
    //print out all registered NSNotification for debug
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        print(notificationSettings.types.rawValue)
    }
    
    //AlarmApplicationDelegate protocol
    func playAlarmSound(_ soundName: String) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        let url = URL(
            fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
}

