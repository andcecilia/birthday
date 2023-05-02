//
//  Download.swift
//  Birthday
//
//  Created by Cecilia Andrea Pesce on 30/04/23.
//

import Foundation

class Download: NSObject {
  var url: URL
  var task: URLSessionDownloadTask?
  
  init(url: URL) {
    self.url = url
  }
}
