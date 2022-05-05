import Foundation
import NablaUtils
import UIKit

enum UploadClientError: Error {
    case noSelf
    case noAccessToken
    case impossibleToBuildFormData
    case noValidData
    case failedToSerializePurpose
}

struct UploadData {
    let purpose: String
    let content: Data
    let fileName: String
    let mimeType: MimeType
}

class UploadClient {
    // MARK: - Public
    
    func upload(_ data: UploadData, completion: @escaping (Result<UUID, UploadClientError>) -> Void) {
        authenticator.getAccessToken { [weak self] result in
            guard let state = result.value else {
                completion(.failure(UploadClientError.noAccessToken))
                return
            }
            switch state {
            case let .authenticated(accessToken: token):
                self?.doUpload(authToken: token, data: data, completion: completion)
            case .unauthenticated:
                completion(.failure(.noSelf))
            }
        }
    }
    
    // MARK: - Private
    
    @Inject private var httpManager: HTTPManager
    @Inject private var authenticator: Authenticator
    
    private func makeHeaders(authToken: String) -> [String: String] {
        [
            HTTPHeaders.Accept: "application/json",
            HTTPHeaders.NablaAuthorization: "Bearer \(authToken)",
        ]
    }
    
    private func makeMultipartFormData(data: UploadData) -> Result<MultipartFormData.BuildResult, UploadClientError> {
        guard
            let purpose = data.purpose.data(using: .utf8)
        else {
            return .failure(UploadClientError.failedToSerializePurpose)
        }
        do {
            let multipartFormData = try MultipartFormData.Builder.build(
                with: [
                    (
                        name: "purpose",
                        filename: nil,
                        mimeType: nil,
                        data: purpose
                    ),
                    (
                        name: "file",
                        filename: data.fileName,
                        mimeType: Self.makeMimeType(from: data.mimeType),
                        data: data.content
                    ),
                ],
                willSeparateBy: RandomBoundaryGenerator.generate()
            )
            return .success(multipartFormData)
        } catch {
            return .failure(.impossibleToBuildFormData)
        }
    }
    
    private func doUpload(authToken: String, data: UploadData, completion: @escaping (Result<UUID, UploadClientError>) -> Void) {
        var request = UploadEndpoint.request()
        var headers = makeHeaders(authToken: authToken)
        var body: Data?
        
        switch makeMultipartFormData(data: data) {
        case let .success(multipartFormData):
            headers[HTTPHeaders.ContentType] = multipartFormData.contentType
            body = multipartFormData.body
        case .failure:
            completion(.failure(.impossibleToBuildFormData))
            return
        }
        
        request = request.headers(headers)
        request = request.body(body)
        
        httpManager.fetch(UploadEndpoint.Result.self, associatedTo: request) { result in
            guard
                let uuidString = result.value?.first,
                let uuid = UUID(uuidString: uuidString)
            else {
                completion(.failure(.noValidData))
                return
            }
            completion(.success(uuid))
        }
    }
    
    private static func makeMimeType(from mimeType: MimeType) -> MIMEType {
        switch mimeType {
        case .png:
            return .imagePng
        case .jpg:
            return .imageJpeg
        case .heic:
            return MIMEType(text: "image/heic")
        case .heif:
            return MIMEType(text: "image/heif")
        case .mov:
            return .videoWebm
        case .mpeg:
            return .audioMpeg
        case .pdf:
            return MIMEType(text: "application/pdf")
        }
    }
}