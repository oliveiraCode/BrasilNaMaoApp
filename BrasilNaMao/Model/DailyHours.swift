//
//  DailyHours.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-02-05.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

//information for 1 day
class DailyHours:Codable{
    let is_overnight:Bool?
    let start:String?
    let end:String?
    let day:Int?
}
