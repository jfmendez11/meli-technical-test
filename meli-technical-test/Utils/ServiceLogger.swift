//
//  ServiceLogger.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation
import os.log

func log(_ type: OSLogType, _ message: String) {
    #if DEBUG
        os_log(type, "")
        print(message)
    #endif
}
