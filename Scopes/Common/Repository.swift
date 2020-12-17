//
//  Repository.swift
//  Scopes
//
//  Created by Ricardo Carvalho on 16/12/20.
//

import Foundation

typealias ValueResult<T> = Result<T, Error>
typealias EmptyResult = Result<Void, Error>

struct IdentifiableItem<T>: Identifiable {
    let id: String
    let path: String
    let item: T
}

protocol Repository {
    associatedtype Element
    typealias IdentifiableElement = IdentifiableItem<Element>
    
    func create(new element: Element,
                completion: @escaping (ValueResult<IdentifiableElement>) -> Void)
    
    func obtain(first elements: Int,
                after element: IdentifiableElement?,
                completion: @escaping (ValueResult<[IdentifiableElement]>) -> Void)
    
    func update(_ element: IdentifiableElement, completion: @escaping (EmptyResult) -> Void)
    
    func delete(_ element: IdentifiableElement, completion: @escaping (EmptyResult) -> Void)
}

struct AnyRepository<E>: Repository {
    typealias IdentifiableElement = IdentifiableItem<E>
    
    private let create: (E, @escaping (ValueResult<IdentifiableElement>) -> Void) -> Void
    private let obtain: (Int, IdentifiableElement?, @escaping (ValueResult<[IdentifiableElement]>) -> Void) -> Void
    private let update: (IdentifiableElement, @escaping (EmptyResult) -> Void) -> Void
    private let delete: (IdentifiableElement, @escaping (EmptyResult) -> Void) -> Void
    
    init<R: Repository>(_ repository: R) where R.Element == E {
        create = repository.create
        obtain = repository.obtain
        update = repository.update
        delete = repository.delete
    }
    
    func create(
        new element: E,
        completion: @escaping (ValueResult<IdentifiableElement>) -> Void
    ) {
        create(element, completion)
    }
    
    func obtain(
        first elements: Int = 10,
        after element: IdentifiableElement? = nil,
        completion: @escaping (ValueResult<[IdentifiableElement]>) -> Void
    ) {
        obtain(elements, element, completion)
    }
    
    func update(_ element: IdentifiableElement, completion: @escaping (EmptyResult) -> Void) {
        update(element, completion)
    }
    
    func delete(_ element: IdentifiableElement, completion: @escaping (EmptyResult) -> Void) {
        delete(element, completion)
    }
}
