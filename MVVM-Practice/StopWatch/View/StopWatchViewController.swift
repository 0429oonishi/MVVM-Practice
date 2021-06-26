//
//  StopWatchViewController.swift
//  MVVM-Practice
//
//  Created by 大西玲音 on 2021/06/27.
//

import UIKit
import RxSwift
import RxCocoa

final class StopWatchViewController: UIViewController {
    
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var startStopButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    
    private let viewModel: StopWatchViewModelType = StopWatchViewModel()
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        viewModel.inputs.isTimerPaused.accept(false)
        
    }
    
    private func setupBindings() {
        startStopButton.rx.tap.asSignal()
            .withLatestFrom(viewModel.outputs.isTimerWorked)
            .emit(onNext: { [weak self] isTimerStoped in
                self?.viewModel.inputs.isTimerPaused.accept(!isTimerStoped)
            })
            .disposed(by: disposeBag)
        
        resetButton.rx.tap.asSignal()
            .emit(to: viewModel.inputs.isResetButtonDidTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isTimerWorked
            .drive(onNext: { [weak self] isWorked in
                if isWorked {
                    self?.startStopButton.backgroundColor = .red
                    self?.startStopButton.setTitle("Stop", for: .normal)
                } else {
                    self?.startStopButton.backgroundColor = .green
                    self?.startStopButton.setTitle("Start", for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.timerText
            .drive(timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isResetButtonHidden
            .drive(resetButton.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    
}
