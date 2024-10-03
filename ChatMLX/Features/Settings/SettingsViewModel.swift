//
//  SettingsViewModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/10/3.
//
import SwiftUI

@Observable
class SettingsViewModel {
    var tasks: [DownloadTask] = []
    var sidebarWidth: CGFloat = 250
    var activeTabID: SettingsTab.ID = .general
    var remoteModels: [RemoteModel] = []

    var error: Error?
    var errorTitle: String?
    var showErrorAlert = false

    func throwError(_ error: Error, title: String? = nil) {
        logger.error("\(error.localizedDescription)")
        self.error = error
        errorTitle = title
        showErrorAlert = true
    }

}
