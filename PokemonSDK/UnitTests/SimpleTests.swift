//
//  PokemonSDKTests.swift
//  PokemonSDKTests
//
//  Created by Abbas on 1/6/21.
//

import XCTest
@testable import PokemonSDK

class PokemonSDKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testIfDatabaseCanAddNewElements(){
        let initialCount = DBHelper.instance.pokemons.value.count
        let pokemon1 = PokemonModel(id: 1001, name: "TestCase1", sprites: ["https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"], translation: "TestCase1")
        DBHelper.savePokemon(item: pokemon1)
        let newCount = DBHelper.instance.pokemons.value.count
        XCTAssert(newCount - initialCount == 1, "Issue in Saving New Pokemon")
        DBHelper.removePokemon(item: pokemon1)
        let lastCount = DBHelper.instance.pokemons.value.count
        XCTAssert(lastCount - initialCount == 0, "Issue in Saving New Pokemon")
    }

    func testIfManualGettingPokemonWorks(){
        PokemonSDK.findPokemon(name: "131") { (item) in
            XCTAssert(item != nil, "Pokemon 131 not found")
        }
    }

    func testIfManualGettingShakespeareWorks(){
        PokemonSDK.findPokemonShakespeare(name: "131", view: nil) { (shakespeare, error) in
            XCTAssert(shakespeare != nil || error?.code != 429, "There is something wrong with shakespeare translation")
        }
    }

    func testIfManualGettingSpriteWorks(){
        PokemonSDK.findPokemonSprite(name: "132", completion: { (sprites) in
            let frontDef = sprites?.frontDefault.count ?? 0 > 0
            let backDef = sprites?.backDefault.count ?? 0 > 0
            let frontShiny = sprites?.frontShiny.count ?? 0 > 0
            let backShiny = sprites?.backShiny.count ?? 0 > 0
            XCTAssert( frontDef && backDef && frontShiny && backShiny
                , "There is something wrong with sprites")
        })
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

