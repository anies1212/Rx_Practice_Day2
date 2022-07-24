//
//  ViewController.swift
//  RxSwift_Practice_2
//
//  Created by anies1212 on 2022/07/24.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet var counterLabel: UILabel! {
        didSet {
            counterLabel.text = "0"
        }
    }
    @IBOutlet var plusButton: UIButton! {
        didSet {
            plusButton.setTitle("Plus", for: .normal)
        }
    }
    @IBOutlet var minusButton: UIButton! {
        didSet {
            minusButton.setTitle("Minus", for: .normal)
        }
    }
    @IBOutlet var resetButton: UIButton! {
        didSet {
            resetButton.setTitle("Reset", for: .normal)
        }
    }
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.setTitle("Next", for: .normal)
        }
    }
    private let disposeBag = DisposeBag()
    var viewModel = CounterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addRxObserver()
    }
    
    private func addRxObserver(){
        let input = CounterInputViewModel(
            plusButton: plusButton.rx.tap.asObservable(),
            minusButton: minusButton.rx.tap.asObservable(),
            resetButton: resetButton.rx.tap.asObservable()
        )
        nextButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.toNext()
            })
            .disposed(by: disposeBag)
        viewModel.setup(input: input)
        viewModel.output?.counterText
            .drive(counterLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func toNext(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "nextVC") as! NextViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

