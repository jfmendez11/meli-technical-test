//
//  ServiceLogger.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation
import os.log

/// Logger used across the prject. Only functions in DEBUG mode
/// Implementation of os_log and print
/// - Parameter type: Type of the log (.error, .debug, etc.)
/// - Parameter message: Message to debug in the console
func log(_ type: OSLogType, _ message: String) {
    #if DEBUG
        os_log(type, "")
        print(message)
    #endif
}
