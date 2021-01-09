//
//  DBHelper.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//

import UIKit
import CoreData
import RxRelay


public class DBHelper : NSObject {
    
    let frameworkBundleID   = "com.abbas.PokemonSDK"
    let pokemonEntityName   = "PokemonItem"
    let dataModelName       = "Pokemon"
    
    static let instance = DBHelper()
    
    public override init() {
        super.init()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        
            let frameworkBundle = Bundle(identifier: self.frameworkBundleID)
            let modelURL = frameworkBundle!.url(forResource: self.dataModelName, withExtension: "momd")!
            let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
            
            let container = NSPersistentContainer(name: self.pokemonEntityName, managedObjectModel: managedObjectModel!)
            container.loadPersistentStores { storeDescription, error in
                
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            
            return container
        }()
    
    lazy var context : NSManagedObjectContext? = persistentContainer.viewContext
    
    // MARK: Variables declearations
    
    var pokemons : BehaviorRelay<[PokemonModel]> = BehaviorRelay(value: [])
    
    // MARK: Methods to Open, Store and Fetch data
    class func savePokemon(item: PokemonModel)
    {
        guard let context = DBHelper.instance.context else {return}
        let entityName = DBHelper.instance.pokemonEntityName
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        saveData(UserDBObj:newUser,item: item)
        fetchEvents()
    }
    
    class func togglePokemon(item: PokemonModel){
        if DBHelper.instance.pokemons.value.contains(where: {$0.id == item.id}){
            removePokemon(item: item)
        }else{
            savePokemon(item: item)
        }
    }
    
    
    class func saveData(UserDBObj:NSManagedObject,item: PokemonModel)
    {
        guard let context = DBHelper.instance.context else {return}
        
        if (DBHelper.instance.context == nil) {return}
        UserDBObj.setValue(item.id, forKey: "id")
        UserDBObj.setValue(item.name, forKey: "name")
        UserDBObj.setValue(item.sprites.frontDefault, forKey: "defaultFront")
        UserDBObj.setValue(item.sprites.backDefault, forKey: "defaultBack")
        UserDBObj.setValue(item.sprites.frontShiny, forKey: "shinyFront")
        UserDBObj.setValue(item.sprites.backShiny, forKey: "shinyBack")
        UserDBObj.setValue(item.shakespeare?.contents.translated ?? "", forKey: "shakespeareTranslations")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
    }
    
    static func containsItem(keyword: String) -> PokemonModel?{
        return instance.pokemons.value.first(where: {$0.id == Int(keyword) || $0.name == keyword})
    }
    
    static func fetchEvents()
    {
        guard let context = DBHelper.instance.context else {return}
        let itemsRelay = DBHelper.instance.pokemons
        let entityName = DBHelper.instance.pokemonEntityName

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            var items : [PokemonModel] = []
            for data in result as! [NSManagedObject] {
                let sprites = [data.value(forKey: "defaultFront") as? String,
                               data.value(forKey: "defaultBack") as? String,
                               data.value(forKey: "shinyFront") as? String,
                               data.value(forKey: "shinyBack") as? String].compactMap({$0})
                let item = PokemonModel(id: data.value(forKey: "id") as? Int ?? 0,
                                        name: data.value(forKey: "name") as? String ?? "", sprites: sprites, translation: data.value(forKey: "shakespeareTranslations") as? String ?? "")
                items.append(item)
            }
            itemsRelay.accept(items)
            print ("pokemons are",items)
        } catch {
            print("Fetching data Failed")
        }
    }
    
    static func removePokemon(item: PokemonModel)
    {
        guard let context = DBHelper.instance.context else {return}
        let entityName = DBHelper.instance.pokemonEntityName
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let itemId = data.value(forKey: "id") as! Int
                if itemId == item.id {
                    context.delete(data)
                }
            }
        } catch {
            print("Removing data Failed")
        }
        
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
        
        fetchEvents()
    }
    
    static func cleanData(){
        guard let context = DBHelper.instance.context else {return}
        let entityName = DBHelper.instance.pokemonEntityName
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("error : \(error) \(error.userInfo)")
        }
    }
}
