//
//  GlobalParams.swift
//  FivePastNine Alarm App
// 
//  Hasan Özdemir
// 

/*
When importing the Foundation framework, 
the Swift overlay provides value types 
for many bridged reference types.
*/
import Foundation

class Global
{
    static var indexOfCell = -1
    static var isEditMode: Bool = false
    static var label: String = "Alarm"
    static var weekdays: [Int] = [Int]()
    static var mediaLabel: String = "bell"
    static var snoozeEnabled: Bool = false
}
