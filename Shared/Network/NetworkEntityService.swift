//
//  NetworkEntityService.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 28/02/21.
//

import Foundation

extension CodingUserInfoKey {
  static let context = CodingUserInfoKey(rawValue: "context")!
}

public enum NetworkEntityServiceError: Error {
    case missingManagedObjectContext
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkDataServiceError)
    case resolvedNetworkFailure(Error)
}

public protocol NetworkEntityServiceProtocol {
    typealias CompletionHandler<T> = (Result<T, NetworkEntityServiceError>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: EntityAPIRequest>(with endpoint: E,
                                                       completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T
    @discardableResult
    func request<E: EntityAPIRequest>(with endpoint: E,
                                         completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E.Response == Void
}

public final class NetworkEntityService {
    private let networkService: NetworkDataService
    private let errorResolver: NetworkEntityServiceErrorResolverProtocol
    private let errorLogger: NetworkEntityServiceErrorLoggerProtocol
    
    public init(with networkService: NetworkDataService,
                errorResolver: NetworkEntityServiceErrorResolverProtocol = NetworkEntityServiceErrorResolver(),
                errorLogger: NetworkEntityServiceErrorLoggerProtocol = NetworkEntityServiceErrorLogger()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension NetworkEntityService: NetworkEntityServiceProtocol {
    public func request<T: Decodable, E: EntityAPIRequest>(with endpoint: E,
                                                              completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {

        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, NetworkEntityServiceError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async { return completion(result) }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async { return completion(.failure(error)) }
            }
        }
    }

    public func request<E>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E : EntityAPIRequest, E.Response == Void {
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                DispatchQueue.main.async { return completion(.success(())) }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async { return completion(.failure(error)) }
            }
        }
    }

    // MARK: - Private
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, NetworkEntityServiceError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkDataServiceError) -> NetworkEntityServiceError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkDataServiceError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

// MARK: - Response Decoders
public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoder {
    public init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}

// MARK: - Error Resolver

public protocol NetworkEntityServiceErrorResolverProtocol {
    func resolve(error: NetworkDataServiceError) -> Error
}

public class NetworkEntityServiceErrorResolver: NetworkEntityServiceErrorResolverProtocol {
    public init() { }
    public func resolve(error: NetworkDataServiceError) -> Error {
        return error
    }
}

// MARK: - Logger

public protocol NetworkEntityServiceErrorLoggerProtocol {
    func log(error: Error)
}

public final class NetworkEntityServiceErrorLogger: NetworkEntityServiceErrorLoggerProtocol {
    public init() { }
    
    public func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}


