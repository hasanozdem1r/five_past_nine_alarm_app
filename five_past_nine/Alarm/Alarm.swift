//
//  Alarm.swift
//  FivePastNine Alarm App
//
//  Hasan Özdemir
// 

import Foundation
import MediaPlayer

// a struct is used to store variables of different data types
struct Alarm
{
    //using member wise initializer for struct
    var label: String
    var timeStr: String
    var date: Date
    var enabled: Bool
    var snoozeEnabled: Bool
    var UUID: String
    var mediaID: String
    var mediaLabel: String
    var repeatWeekdays: [Int]

}

// for-in loop supporting
// A sequence is a list of values that you can step through one at a time.
class Alarms: Sequence
{
    fileprivate let ud:UserDefaults
    fileprivate let alarmKey:String
    fileprivate var alarms:[Alarm] = [Alarm]()
    
    //ensure can not be instantiated outside
    fileprivate init()
    {
        ud = UserDefaults.standard

        alarmKey = "myAlarmKey"
        alarms = getAllAlarm()
    }
    
    static let sharedInstance = Alarms()
    
    //setObject only support "property list objects",so we cannot persist alarms directly
    func append(_ alarm: Alarm)
    {
        alarms.append(alarm)
        PersistAlarm(alarm, index: alarms.count-1)
    }
    // persisting alarm
    func PersistAlarm(_ alarm: Alarm, index: Int)
    {
        var alarmArray = ud.array(forKey: alarmKey) ?? []
            alarmArray.append(["label": alarm.label, "timeStr": alarm.timeStr, "date": alarm.date, "enabled": alarm.enabled, "snoozeEnabled": alarm.snoozeEnabled, "UUID": alarm.UUID, "mediaID": alarm.mediaID, "mediaLabel": Alarms.sharedInstance[index].mediaLabel, "repeatWeekdays": alarm.repeatWeekdays])
        
        ud.set(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    // overloading persist alarm
    func PersistAlarm(_ index: Int)
    {
        var alarmArray = ud.array(forKey: alarmKey) ?? []
        alarmArray[index] = ["label": Alarms.sharedInstance[index].label, "timeStr": Alarms.sharedInstance[index].timeStr, "date": Alarms.sharedInstance[index].date, "enabled": Alarms.sharedInstance[index].enabled, "snoozeEnabled": Alarms.sharedInstance[index].snoozeEnabled, "UUID": Alarms.sharedInstance[index].UUID, "mediaID": Alarms.sharedInstance[index].mediaID, "mediaLabel": Alarms.sharedInstance[index].mediaLabel, "repeatWeekdays": Alarms.sharedInstance[index].repeatWeekdays]
        ud.set(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    // deleting alarm
    func deleteAlarm(_ index: Int)
    {
        var alarmArray = ud.array(forKey: alarmKey) ?? []
        alarmArray.remove(at: index)
        ud.set(alarmArray, forKey: alarmKey)
        ud.synchronize()
    }
    
    //helper, convert dictionary to [Alarm]
    fileprivate func getAllAlarm() -> [Alarm]
    {
        let alarmArray = UserDefaults.standard.array(forKey: alarmKey)
        
        if alarmArray != nil{
            let items = alarmArray!
            return (items as! Array<Dictionary<String, AnyObject>>).map(){item in Alarm(label: item["label"] as! String, timeStr: item["timeStr"] as! String, date: item["date"] as! Date, enabled: item["enabled"] as! Bool, snoozeEnabled: item["snoozeEnabled"] as! Bool, UUID: item["UUID"] as! String, mediaID: item["mediaID"] as! String, mediaLabel: item["mediaLabel"] as! String, repeatWeekdays: item["repeatWeekdays"] as! [Int])}
        }
        else
        {
            return [Alarm]()
        }
    }
    // alarm.count getter
    var count:Int
    {
        return alarms.count
    }
    // delete alarm from given index
    func removeAtIndex(_ index: Int)
    {
        alarms.remove(at: index)
    }
    // subscript  are shortcuts for accessing the member elements of a iterators
    subscript(index: Int) -> Alarm{
        get{
            assert((index < alarms.count && index >= 0), "Index out of range")
            return alarms[index]
        }
        set{
            assert((index < alarms.count && index >= 0), "Index out of range")
            alarms[index] = newValue
        }

    }
    // label getter
    func labelAtIndex(_ index: Int) -> String
    {
        return alarms[index].label
    }
    // time getter
    func timeStrAtIndex(_ index: Int) -> String
    {
        return alarms[index].timeStr
    }
    // date getter
    func dateAtIndex(_ index: Int) -> Date
    {
        return alarms[index].date
    }
    // UUID getter
    func UUIDAtIndex(_ index: Int) -> String
    {
        return alarms[index].UUID
    }
    // enable alarm for given index
    func enabledAtIndex(_ index: Int) -> Bool
    {
        return alarms[index].enabled
    }
    // mediaID getter
    func mediaIDAtIndex(_ index: Int) -> String
    {
        return alarms[index].mediaID
    }
    // label setter
    func setLabel(_ label: String, AtIndex index: Int)
    {
        alarms[index].label = label
    }
    // date setter
    func setDate(_ date: Date, AtIndex index: Int)
    {
        alarms[index].date = date
    }
    // time setter
    func setTimeStr(_ timeStr: String, AtIndex index: Int)
    {
        alarms[index].timeStr = timeStr
    }
    // mediaID setter
    func setMediaID(_ mediaID: String, AtIndex index: Int)
    {
        alarms[index].mediaID = mediaID
    }
    // mediaLabel setter
    func setMediaLabel(_ mediaLabel: String, AtIndex index: Int)
    {
        alarms[index].mediaLabel = mediaLabel
    }
    // enable/disable alarm
    func setEnabled(_ enabled: Bool, AtIndex index: Int)
    {
        alarms[index].enabled = enabled
    }
    // enable/disable snooze
    func setSnooze(_ snoozeEnabled: Bool, AtIndex index: Int)
    {
        alarms[index].snoozeEnabled = snoozeEnabled
    }
    // weekdays setter
    func setWeekdays(_ weekdays: [Int], AtIndex index: Int)
    {
        alarms[index].repeatWeekdays = weekdays
    }
    // check whether alarms empty or not
    var isEmpty: Bool
    {
        return alarms.isEmpty
    }
    
    //SequenceType Protocol
    fileprivate var currentIndex = 0
    func makeIterator() -> AnyIterator<Alarm> {
        let anyIter = AnyIterator(){self.currentIndex < self.alarms.count ? self.alarms[self.currentIndex] : nil}
        self.currentIndex = self.currentIndex + 1
        return anyIter
    }
    
    
}
