//
//  SettingViewModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/4.
//

import Foundation
import os
import SwiftUI

@Observable
class SettingViewModel {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "SettingViewModel")
    
    var modelDirectory: URL?{
        didSet {
            if let modelDirectory = modelDirectory {
                UserDefaults.standard.setValue(modelDirectory.absoluteString, forKey: "modelDirectory")
            } else {
                UserDefaults.standard.setValue(nil, forKey: "modelDirectory")
            }
        }
    }
    
    var selecting:Bool = false

//    var huggingFaceToken: String {
//        didSet {
//            UserDefaults.standard.set(huggingFaceToken, forKey: "huggingFaceToken")
//        }
//    }
//
//    var modelDirectory: URL
//
//    var models: [Model] = []
//
//    init() {
//        self.huggingFaceToken = UserDefaults.standard.value(forKey: "huggingFaceToken") as? String ?? ""
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        self.modelDirectory = documents.appending(component: "huggingface").appending(component: "models")
//
//        loadFromModelDirectory()
//    }

//    func loadFromModelDirectory() {
//        do {
//            let repoDirectories = try FileManager.default.contentsOfDirectory(
//                at: modelDirectory,
//                includingPropertiesForKeys: nil,
//                options: .skipsHiddenFiles
//            )
//
//            for repoDirectory in repoDirectories {
//                let modelDirectories = try FileManager.default.contentsOfDirectory(
//                    at: repoDirectory,
//                    includingPropertiesForKeys: nil,
//                    options: .skipsHiddenFiles
//                )
//
//                for modelDirectory in modelDirectories {
//                    models.append(Model(name: "\(repoDirectory.lastPathComponent)/\(modelDirectory.lastPathComponent)", url: modelDirectory))
//                }
//            }
//        } catch {
//            logger.error("\(error.localizedDescription)")
//        }
//    }
//    
    //    func download(){
//
//    }
}
