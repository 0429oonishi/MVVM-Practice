//
//  StopWatchViewModel.swift
//  MVVM-Practice
//
//  Created by 大西玲音 on 2021/06/27.
//

import Foundation
import RxSwift
import RxCocoa

protocol StopWatchViewModelInput {
    var isTimerPaused: PublishRelay<Bool> { get }
    var isResetButtonDidTapped: PublishRelay<Void> { get }
}

protocol StopWatchViewModelOutput: AnyObject {
    var isTimerWorked: Driver<Bool> { get }
    var timerText: Driver<String> { get }
    var isResetButtonHidden: Driver<Bool> { get }
}

protocol StopWatchViewModelType {
    var inputs: StopWatchViewModelInput { get }
    var outputs: StopWatchViewModelOutput { get }
}

final class StopWatchViewModel: StopWatchViewModelInput,
                                StopWatchViewModelOutput {
    
    // input
    var isTimerPaused = PublishRelay<Bool>()
    var isResetButtonDidTapped = PublishRelay<Void>()
    
    // output
    var isTimerWorked: Driver<Bool>
    var timerText: Driver<String>
    var isResetButtonHidden: Driver<Bool>
    
    private let disposeBag = DisposeBag()
    private let totalTimeDuration = BehaviorRelay<Int>(value: 0)
    
    init() {
        isTimerWorked = isTimerPaused.asDriver(onErrorDriveWith: .empty())
        
        timerText = totalTimeDuration
            .map { String("\($0)") }
            .asDriver(onErrorDriveWith: .empty())
        
        isResetButtonHidden = Observable.merge(isTimerWorked.asObservable(), isResetButtonDidTapped.map { true }.asObservable())
            .skip(1)
            .asDriver(onErrorDriveWith: .empty())
        
        isTimerWorked.asObservable()
            .flatMapLatest { [weak self] isWorked -> Observable<Int> in
                if isWorked {
                    return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                        .withLatestFrom(Observable<Int>.just(self?.totalTimeDuration.value ?? 0)) { $0 + $1 }
                } else {
                    return Observable<Int>.just(self?.totalTimeDuration.value ?? 0)
                }
            }
            .bind(to: totalTimeDuration)
            .disposed(by: disposeBag)
        
        isResetButtonDidTapped.map { 0 }
            .bind(to: totalTimeDuration)
            .disposed(by: disposeBag)
        
    }
    
}

extension StopWatchViewModel: StopWatchViewModelType {
    var inputs: StopWatchViewModelInput {
        return self
    }
    var outputs: StopWatchViewModelOutput {
        return self
    }
}
