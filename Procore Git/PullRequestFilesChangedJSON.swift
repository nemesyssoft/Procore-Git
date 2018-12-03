//
//  PullRequestFilesChangedJSON.swift
//  Procore Git
//
//  Created by Laurent Daudelin on 12/3/18.
//  Copyright © 2018 Nemesys Software. All rights reserved.
//

import Foundation

typealias PullRequestFilesChangedJSON = [PullRequestFilesChangedJSONElement]

struct PullRequestFilesChangedJSONElement: Codable {
    let sha, filename, status: String?
    let additions, deletions, changes: Int?
    let blobURL, rawURL, contentsURL: String?
    let patch: String?
    
    enum CodingKeys: String, CodingKey {
        case sha, filename, status, additions, deletions, changes
        case blobURL = "blob_url"
        case rawURL = "raw_url"
        case contentsURL = "contents_url"
        case patch
    }
}

func newPullRequestFilesChangedJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newPullRequestFilesChangedJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newPullRequestFilesChangedJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func pullRequestFilesChangedJSONTask(with url: URL, completionHandler: @escaping (PullRequestFilesChangedJSON?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
