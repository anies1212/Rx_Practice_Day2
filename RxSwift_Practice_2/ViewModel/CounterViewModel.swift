//
//  CounterViewModel.swift
//  RxSwift_Practice_2
//
//  Created by anies1212 on 2022/07/24.
//

import Foundation
import RxSwift
import RxCocoa

struct CounterInputViewModel {
    let plusButton: Observable<Void>
    let minusButton: Observable<Void>
    let resetButton: Observable<Void>
}

protocol CounterOutputViewModel {
    var counterText: Driver<String?> { get }
}

protocol CounterTypeViewModel {
    var output: CounterOutputViewModel? { get }
    func setup(input: CounterInputViewModel)
}

class CounterViewModel: CounterTypeViewModel, CounterOutputViewModel {
    var output: CounterOutputViewModel?
    var counterRelay = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    private let initalCounter = 0
    
    init(){
        self.output = self
        reset()
    }
    
    func setup(input: CounterInputViewModel) {
        input.plusButton
            .subscribe(onNext: {[weak self] _ in
                self?.plus()
            })
            .disposed(by: disposeBag)
        input.minusButton
            .subscribe(onNext: {[weak self] _ in
                self?.minus()
            })
            .disposed(by: disposeBag)
        input.resetButton
            .subscribe(onNext: {[weak self] _ in
                self?.reset()
            })
            .disposed(by: disposeBag)
    }
    
    private func reset(){
        counterRelay.accept(0)
    }
    
    private func plus(){
        let count = counterRelay.value + 1
        counterRelay.accept(count)
    }
    
    private func minus(){
        let count = counterRelay.value - 1
        counterRelay.accept(count)
    }
    
}
extension CounterViewModel {
    var counterText: Driver<String?> {
        return counterRelay
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: nil)
    }
}
