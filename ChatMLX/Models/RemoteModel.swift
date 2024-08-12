//
//  RemoteModel.swift
//  ChatMLX
//
//  Created by John Mai on 2024/8/11.
//

import Foundation

struct RemoteModel: Codable, Identifiable {
    let id: String
    let repoId: String
    let modelId: String
    let likes: Int
    let trendingScore: Int?
    let isPrivate: Bool
    let downloads: Int
    let tags: [String]
    let pipelineTag: String?
    let libraryName: String?
    let createdAt: Date

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case repoId = "id"
        case likes
        case trendingScore
        case isPrivate = "private"
        case downloads
        case tags
        case pipelineTag = "pipeline_tag"
        case libraryName = "library_name"
        case createdAt
        case modelId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        repoId = try container.decode(String.self, forKey: .repoId)
        modelId = try container.decode(String.self, forKey: .modelId)
        likes = try container.decode(Int.self, forKey: .likes)
        trendingScore = try container.decodeIfPresent(Int.self, forKey: .trendingScore) ?? 0
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        downloads = try container.decode(Int.self, forKey: .downloads)
        tags = try container.decode([String].self, forKey: .tags)
        pipelineTag = try container.decodeIfPresent(String.self, forKey: .pipelineTag)
        libraryName = try container.decodeIfPresent(String.self, forKey: .libraryName)

        let dateString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            createdAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string does not match expected format")
        }
    }
}
