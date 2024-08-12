//
//  DownloadManagerView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import SwiftUI

struct DownloadManagerView: View {
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension DownloadManagerView {
    @Observable
    class ViewModel {
        var tasks: [DownloadTask] = []
    }
}

#Preview {
    DownloadManagerView()
}
