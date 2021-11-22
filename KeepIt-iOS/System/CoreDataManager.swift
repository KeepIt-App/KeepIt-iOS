//
//  CoreDataManager.swift
//  KeepIt-iOS
//
//  Created by 인병윤 on 2021/11/19.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KeepIt_iOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Core Data CRUD

    func createProduct(productImage: Data, productName: String, productPrice: String, productLink: String, productMemo: String, productRatingStar: Float, addDate: Date) {
        let product = Product(context: context)

        product.productImage = productImage
        product.productName = productName
        product.productPrice = productPrice
        product.productLink = productLink
        product.productMemo = productMemo
        product.productRatingStar = productRatingStar
        product.addDate = addDate

        do {
            try product.validateForInsert()
        } catch let error as NSError {
            context.rollback()
            print(error)
            return
        }
        saveContext()
    }
    
    func readProductList(tag: Int) -> [Product] {
        let readProducts: NSFetchRequest<Product> = Product.fetchRequest()
        var productList = [Product]()
        if tag == 1 {
            let sortByLatest = NSSortDescriptor(key: #keyPath(Product.addDate), ascending: false)
            readProducts.sortDescriptors = [sortByLatest]
        } else if tag == 2 {
            let sortByPriority = NSSortDescriptor(key: #keyPath(Product.productRatingStar), ascending: false)
            readProducts.sortDescriptors = [sortByPriority]
        } else if tag == 3 {
            let sortByPrice = NSSortDescriptor(key: #keyPath(Product.productPrice), ascending: false)
            readProducts.sortDescriptors = [sortByPrice]
        }

        DispatchQueue.global().async {
            self.context.performAndWait {
                do {
                    productList = try self.context.fetch(readProducts)
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }

        return productList
    }

    func editProduct(_ product: Product, productImage: Data, productName: String, productPrice: String, productLink: String, productMemo: String, productRatingStar: Float) {
        product.productImage = productImage
        product.productName = productName
        product.productPrice = productPrice
        product.productLink = productLink
        product.productMemo = productMemo
        product.productRatingStar = productRatingStar

        saveContext()
    }

    func deleteProduct(_ product: Product) {
        context.delete(product)
        saveContext()
    }
}
