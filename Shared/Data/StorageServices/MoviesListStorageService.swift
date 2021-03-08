//
//  MoviesListStorageService.swift
//  Clean Architechure MVVM
//
//  Created by Vidhyadharan on 05/03/21.
//

import Foundation
import CoreData

protocol MoviesListStorageServiceProtocol {
    func getResponse(for request: MoviesListRequest, completion: @escaping (Result<MoviesListResponseEntity?, PersistanceError>) -> Void)
    func save(response: MoviesListResponse, for request: MoviesListRequest)
}

final class MoviesListStorageService {

    private let persistenceManager: PersistenceManager

    init(persistenceManager: PersistenceManager = PersistenceManager.shared) {
        self.persistenceManager = persistenceManager
    }

    // MARK: - Private

    private func getFetchRequest(for request: MoviesListRequest) -> NSFetchRequest<MoviesListRequestEntity> {
        let fetchRequest: NSFetchRequest = MoviesListRequestEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(MoviesListRequestEntity.category), request.category.rawValue,
                                        #keyPath(MoviesListRequestEntity.page), request.page)
        return fetchRequest
    }

    private func deleteResponse(for request: MoviesListRequest, in context: NSManagedObjectContext) {
        let fetchRequest = getFetchRequest(for: request)

        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension MoviesListStorageService: MoviesListStorageServiceProtocol {

    func getResponse(for request: MoviesListRequest, completion: @escaping (Result<MoviesListResponseEntity?, PersistanceError>) -> Void) {
        let context = persistenceManager.viewContext
        context.perform {
            do {
                let fetchRequest = self.getFetchRequest(for: request)
                let requestEntity = try context.fetch(fetchRequest).first

                completion(.success(requestEntity?.response))
            } catch {
                completion(.failure(PersistanceError.readError(error)))
            }
        }
    }
    
    func save(response: MoviesListResponse, for request: MoviesListRequest) {
        let context = persistenceManager.backgroundContext
        context.performAndWait {
            do {
                self.deleteResponse(for: request, in: context)

                let requestEntity = MoviesListRequestEntity(moviesRequest: request, insertInto: context)
                let responseEntity = MoviesListResponseEntity(moviesListResponse: response, insertInto: context)
                requestEntity.response = responseEntity
                
                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
