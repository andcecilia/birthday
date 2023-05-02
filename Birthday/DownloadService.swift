//
//  DownloadService.swift
//  Birthday
//
//  Created by Cecilia Andrea Pesce on 30/04/23.
//

import Foundation

class DownloadService {

  var downloadsSession: URLSession!
  var activeDownloads: [URL: Download] = [:]

  func startDownload(_ track: URL) {
    let download = Download(url: track)
    download.task = downloadsSession.downloadTask(with: track)
    download.task!.resume()
    activeDownloads[download.url] = download
  }
}
