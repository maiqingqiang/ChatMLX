//
//  MLXCommunityView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import SwiftUI

struct MLXCommunityView: View {
    @State var models: [HubModelInfo] = []
    @State private var searchQuery = ""
    @State var isFetching = false
    @State var next: String?

    @State var status: Status = .isLoading

    enum Status {
        case isLoading
        case idle
        case error(String)
    }

    var body: some View {
        VStack {
            TextField("Search models", text: $searchQuery, onCommit: {
                Task {
                    await fetchModels(search: searchQuery)
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            List {
                ForEach($models) {
                    model in
                    VStack(alignment: .leading) {
                        Text(model.modelId.wrappedValue.deletingPrefix("mlx-community/"))
                            .font(.headline)
                    }
                }
                lastRowView
            }
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            Task {
                await fetchModels()
            }
        }
    }

    var lastRowView: some View {
        ZStack(alignment: .center) {
            switch status {
            case .isLoading:
                ProgressView()
            case .idle:
                EmptyView()
            case .error(let error):
                EmptyView()
//                ErrorView(error)
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .onAppear {
            Task {
                await loadMoreModelsIfNeeded()
            }
        }
    }

    func parseLinks(_ links: String?) -> [String: String] {
        guard let links else { return [:] }

        var linkDict = [String: String]()
        let linkComponents = links.split(separator: ",")

        for component in linkComponents {
            let parts = component.split(separator: ";")
            if parts.count == 2 {
                let urlPart = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let relPart = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)

                let url = urlPart.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                let rel = relPart.replacingOccurrences(of: "rel=", with: "").trimmingCharacters(in: CharacterSet(charactersIn: "\""))

                linkDict[rel] = url
            }
        }

        return linkDict
    }

    func fetchModels(search: String? = nil) async {
        guard !isFetching else { return }
        isFetching = true

        var urlComponents = URLComponents(string: "https://huggingface.co/api/models")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "author", value: "mlx-community"),
            URLQueryItem(name: "sort", value: "downloads"),
        ]

        if let search {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            let links = httpResponse.value(forHTTPHeaderField: "Link")

            if let next = parseLinks(links)["next"] {
                self.next = next
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedResponse = try decoder.decode([HubModelInfo].self, from: data)
            models = decodedResponse
            status = .idle
//            print("decodedResponse \(decodedResponse)")
        } catch {
            print("Failed to fetch models: \(error)")
            status = .error(error.localizedDescription)
        }

        isFetching = false
    }

    func loadMoreModelsIfNeeded() async {
        guard !isFetching else { return }
        isFetching = true
        status = .isLoading

        let urlComponents = URLComponents(string: next!)!

        guard let url = urlComponents.url else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            let links = httpResponse.value(forHTTPHeaderField: "Link")

            if let next = parseLinks(links)["next"] {
                self.next = next
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decodedResponse = try decoder.decode([HubModelInfo].self, from: data)
            models.append(contentsOf: decodedResponse)
            print("decodedResponse \(decodedResponse)")
            status = .idle
        } catch {
            print("Failed to fetch models: \(error)")
            status = .error(error.localizedDescription)
        }

        isFetching = false
    }
}

// #Preview {
//    MLXCommunityView()
// }
