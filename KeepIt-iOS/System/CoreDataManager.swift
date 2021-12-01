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
    var selecFilterIndex = 1
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

    private var productEntity: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "Product", in: context)
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        do {
            print("저장함 ㅇㅇ")
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // MARK: - Core Data CRUD

    func createProduct(productModel: ProductModel) {
        guard let entity = productEntity else { return }
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue(productModel.productName, forKey: "productName")
        managedObject.setValue(productModel.productPrice, forKey: "productPrice")
        managedObject.setValue(productModel.productLink, forKey: "productLink")
        managedObject.setValue(productModel.productMemo, forKey: "productMemo")
        managedObject.setValue(productModel.productRatingStar, forKey: "productRatingStar")
        managedObject.setValue(productModel.addDate, forKey: "addDate")
        managedObject.setValue(productModel.productImage, forKey: "productImage")
        saveContext()
    }

    func readAllProductList() -> [Product] {
        do {
            let request: NSFetchRequest<Product> = Product.fetchRequest()
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }


    func readProductList(tag: Int) -> [Product] {
        let readProducts: NSFetchRequest<Product> = Product.fetchRequest()
        var productList = [Product]()
        if tag == 1 {
            let sortByLatest = NSSortDescriptor(key: "addDate", ascending: false)
            readProducts.sortDescriptors = [sortByLatest]
        } else if tag == 2 {
            let sortByPriority = NSSortDescriptor(key: "productRatingStar", ascending: false)
            readProducts.sortDescriptors = [sortByPriority]
        } else if tag == 3 {
            let sortByPrice = NSSortDescriptor(key: "productPrice", ascending: false)
            readProducts.sortDescriptors = [sortByPrice]
        }

        context.performAndWait {
            do {
                productList = try context.fetch(readProducts)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return productList
    }

    func editProduct(_ product: Product, productModel: ProductModel) {
        product.productImage = productModel.productImage
        product.productName = productModel.productName
        product.productPrice = productModel.productPrice
        product.productLink = productModel.productLink
        product.productMemo = productModel.productMemo
        product.productRatingStar = productModel.productRatingStar

        saveContext()
    }

    func deleteProduct(_ product: Product) {
        context.delete(product)
        saveContext()
    }

    public func clearAllData() {
        let entities = self.persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(deleteAll)
    }

    private func deleteAll(entity: String) {
        let reqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteAll = NSBatchDeleteRequest(fetchRequest: reqVar)
        do { try context.execute(deleteAll)
            try context.save()
        } catch {
            print("에러 발생")
        }
    }
}
