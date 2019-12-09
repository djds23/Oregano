//
//  PhotoAnalysis.swift
//  Oregano
//
//  Created by Dean Silfen on 12/8/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import UIKit
import Vision

class PhotoAnalysis: NSObject {
    private let handler: VNImageRequestHandler
    func analysis(resultHandler: @escaping (String?) -> Void) throws {
        let completion: VNRequestCompletionHandler = { [weak self] (request, error) in
            resultHandler(self?.constructString(request: request, error: error))
        }
        let request = VNRecognizeTextRequest(completionHandler: completion)
        request.recognitionLevel = .accurate
        request.revision = VNRecognizeTextRequestRevision1
        try handler.perform([request as VNRequest])
    }
    
    private func constructString(request: VNRequest, error: Error?) -> String? {
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return nil
        }
        
        return results.compactMap { visionResult -> String? in
            let maxCandidates = 1
            guard let candidate = visionResult.topCandidates(maxCandidates).first else {
                return nil
            }
            return candidate.string
        }.joined(separator: "\n")
    }

    init(fileURL: URL) {
        handler = VNImageRequestHandler(url: fileURL, options: [:])
    }
}
