//
//  SiteWorker.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

protocol SiteWorkerDelegate {
    func didLoadSites(sites: [Site])
    func didFailWithError(error: Error)
}

class SiteWorker {
}
