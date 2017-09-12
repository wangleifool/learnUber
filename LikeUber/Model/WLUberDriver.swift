//
//  WLUberDriver.swift
//  LikeUber
//
//  Created by lei wang on 2017/8/31.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit



class WLUberDriver: NSObject {
    
    var driverName: String!
    var driverPhone: String!
    var driverCarNumber: String!
    var driverCarBrand: String!
    var driverCarColor: String?
    
    var driverCarAnnotation: WLAnnotation!
    var driverCarAnnotationView: WLCarAnnotationView!
    var driverCarAddress: String?
    
    var state: driverState = .driveToAnywhere
    var driverRoute: BMKPolyline?
}
