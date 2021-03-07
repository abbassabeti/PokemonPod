//
//  ViewController.swift
//  PokemonSDK
//
//  Created by Abbas on 01/09/2021.
//  Copyright (c) 2021 Abbas. All rights reserved.
//

import UIKit
import PokemonSDK
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var txtField1: UITextField!
    @IBOutlet weak var txtField2: UITextField!
    
    @IBOutlet weak var btnOk: UIButton!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var tap1 : BehaviorRelay<()> = BehaviorRelay(value: ())
    var tap2 : BehaviorRelay<()> = BehaviorRelay(value: ())
    var edit1 : BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var edit2 : BehaviorRelay<String?> = BehaviorRelay(value: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        txtField1.rx.controlEvent([.editingDidBegin]).asObservable().bind(to: tap1).disposed(by: disposeBag)
        txtField2.rx.controlEvent([.editingDidBegin]).asObservable().bind(to: tap2).disposed(by: disposeBag)
        txtField1.rx.text.asObservable().bind(to: edit1).disposed(by: disposeBag)
        txtField2.rx.text.asObservable().bind(to: edit2).disposed(by: disposeBag)
        
        Observable.combineLatest(tap1, tap2,edit1,edit2).subscribe {[weak self] (_, _, str1, str2) in
            guard let self = self else {return}
            print("yo")
            if self.txtField1.isFirstResponder {
                self.btnOk.isEnabled = (str1?.count ?? 0) > 0
            }
            if self.txtField2.isFirstResponder {
                self.btnOk.isEnabled = (str2?.count ?? 0) > 0
            }
        }.disposed(by: disposeBag)

    }
    
    func checkState(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

