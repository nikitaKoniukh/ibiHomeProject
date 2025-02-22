//
//  SwiftDataService.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//
import SwiftData

class SwiftDataService {
    static var shared = SwiftDataService()
    var container: ModelContainer?
    var context: ModelContext?
    var productModels: [ProductModel] = []
    
    init() {
        
        do {
            let schema = Schema([ProductModel.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try? ModelContainer(for: ProductModel.self, configurations: modelConfiguration)
            
            if let container {
                context = ModelContext(container)
            }
            
            let fetchDescriptor = FetchDescriptor<ProductModel>()
            productModels = try context?.fetch(fetchDescriptor) ?? []
        } catch {
            print("Error initializing database container:", error)
        }
    }
    
    func fetchAllProducts() {
        do {
            let fetchDescriptor = FetchDescriptor<ProductModel>()
            productModels = try context?.fetch(fetchDescriptor) ?? []
        } catch {
            print("Error initializing database container:", error)
        }
    }
    
    func updateProduct(_ productModel: ProductModel?) {
        guard let productModel else {
            return
        }
        
        context?.insert(productModel)
        do {
            try context?.save()
            fetchAllProducts()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func deleteProduct(_ product: Product?) {
        guard let product else {
            return
        }
        
        let productToDeleteId = product.id
        guard let productModel = productModels.first(where: { $0.id == productToDeleteId }) else {
            return
        }
        context?.delete(productModel)
        
        do {
            try context?.save()
            fetchAllProducts()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
    func deleteProduct(_ productModel: ProductModel?) {
        guard let productModel else {
            return
        }
        
        let productToDeleteId = productModel.id
        guard let productModel = productModels.first(where: { $0.id == productToDeleteId }) else {
            return
        }
        
        context?.delete(productModel)
        
        do {
            try context?.save()
            fetchAllProducts()
        } catch {
            print("Failed to delete trip: \(error)")
        }
    }
    
    
    func saveProduct(_ product: Product?) {
        guard let product else {
            return
        }
        
        let newProduct = ProductModel(id: product.id,
                                      title: product.title,
                                      description: product.description,
                                      price: product.price,
                                      brand: product.brand,
                                      thumbnail: product.thumbnail)
        context?.insert(newProduct)
        
        do {
            try context?.save()
            fetchAllProducts()
        } catch {
            print("Failed to save: \(error)")
        }
    }
}
