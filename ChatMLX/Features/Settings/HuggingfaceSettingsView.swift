//
//  HuggingfaceSettingsView.swift
//
//
//  Created by John Mai on 2024/3/16.
//

import SwiftUI

struct HuggingfaceSettingsView: View {
    @AppStorage(Preferences.huggingfaceToken.rawValue) private var token: String = ""
    @AppStorage(Preferences.huggingfaceEdpoint.rawValue) private var endpoint: String = ""
    @AppStorage(Preferences.huggingfaceEdpointType.rawValue) private var endpointType:
        HuggingfaceEndpoint = .official

    var body: some View {
        SettingsForm {
            Section {
                SecureField(text: $token, prompt: Text("Enter Huggingface Token")) {
                    Text("Token")
                }

                Picker("Endpoint", selection: $endpointType) {
                    ForEach(HuggingfaceEndpoint.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }

                if endpointType == .custom {
                    TextField(text: $endpoint, prompt: Text("Enter Huggingface Endpoint")) {}
                }
            }
        }
    }
}

#Preview {
    HuggingfaceSettingsView()
}
