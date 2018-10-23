//
//  NumberViewModel.swift
//  callblocker
//
//  Created by Ivo Valcic on 10/19/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import Foundation

protocol NumberViewModel {
    var numberFormatted: String { get }
    var phNumber: Int64 { get }
    var descStr: String? { get }
    var imageStr: String { get }
}

extension PhoneNumber: NumberViewModel {

    var numberFormatted: String {
        return "+\(self.number)"
    }

    var phNumber: Int64 {
        return self.number
    }
    
    var descStr: String? {
        return self.desc
    }
    
    var imageStr: String {
        switch type {
        case .normal:
            return "regular"
        case .blocked:
            return "block"
        case .suspicious:
            return "warning"
        }
    }
}
