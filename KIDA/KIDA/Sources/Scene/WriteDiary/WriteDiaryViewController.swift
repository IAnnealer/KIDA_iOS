//
//  WriteDiaryViewController.swift
//  KIDA
//
//  Created by Ian on 2022/01/17.
//

import Foundation
import UIKit

final class WriteDiaryViewController: BaseViewController, ServiceDependency {

    // MARK: - Properties

    private weak var containerView: UIView!
    private weak var headerView: UIView!
    private weak var todayKeywordLabel: UILabel!
    private weak var selectedKeywordLabel: UILabel!
    private weak var emojiImageView: UIImageView!
    private weak var titleTextField: UITextField!
    private weak var dividerView: UIView!
    private weak var textView: UITextView!
    private weak var writeButton: UIButton!
    private var tapGestureRecognizer: UITapGestureRecognizer!

    private var reactor: WriteDiaryReactor
    private let textViewPlaceholderString = "공백 포함 150자 이내로 써주세요."

    // MARK: - Initializer
    init(reactor: WriteDiaryReactor) {
        self.reactor = reactor

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.rx.didBeginEditing
            .asDriver()
            .do(onNext: { [weak self] _ in
                self?.textVieweditingAnimation(.didBegin)
            })
            .compactMap { [weak self] _ in self?.textView.text }
            .filter(isPlaceHolderString(_:))
            .drive(onNext: { [weak self] _ in
                self?.textView.text = nil
                self?.textView.textColor = .black
            })
            .disposed(by: disposeBag)

        textView.rx.didEndEditing
            .asDriver()
            .do(onNext: { [weak self] _ in
                self?.textVieweditingAnimation(.didEnd)
            })
            .compactMap { [weak self] _ in self?.textView.text }
            .filter(isEmptyTextView(_:))
            .drive(onNext: { [weak self] _ in
                self?.textView.text = self?.textViewPlaceholderString
                self?.textView.textColor = .lightGray
            })
            .disposed(by: disposeBag)

        tapGestureRecognizer.rx.event
            .asDriver()
            .map { $0.state == .recognized }
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }

    override func setupViews() {
        self.tapGestureRecognizer = UITapGestureRecognizer()
        view.backgroundColor = .systemGray5
        view.addGestureRecognizer(tapGestureRecognizer)

        self.containerView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            view.addSubview($0)
        }

        self.headerView = UIView().then {
            $0.backgroundColor = .white
            containerView.addSubview($0)
        }

        self.todayKeywordLabel = UILabel().then {
            $0.text = "오늘의 키워드"
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            headerView.addSubview($0)
        }

        self.selectedKeywordLabel = UILabel().then {
            $0.text = "쿠쿠루삥뽕"
            $0.font = .systemFont(ofSize: 40, weight: .bold)
            $0.textColor = .kida_orange()
            headerView.addSubview($0)
        }

        self.emojiImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .white
            headerView.addSubview($0)
        }

        self.titleTextField = UITextField().then {
            $0.placeholder = "제목"
            $0.font = .systemFont(ofSize: 20, weight: .semibold)
            containerView.addSubview($0)
        }

        self.dividerView = UIView().then {
            $0.backgroundColor = .systemGray2
            containerView.addSubview($0)
        }

        self.textView = UITextView().then {
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.text = textViewPlaceholderString
            $0.textColor = .lightGray
            containerView.addSubview($0)
        }

        self.writeButton = UIButton().then {
            $0.setTitle("작성하기", for: .normal)
            $0.backgroundColor = .black
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 10
            containerView.addSubview($0)
        }
    }

    override func setupLayoutConstraints() {
        let sideMargin: CGFloat = 20
        let writeButtonHeight: CGFloat = 60

        writeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(55)
            $0.trailing.equalToSuperview().offset(-55)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            $0.height.equalTo(writeButtonHeight)
        }

        containerView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(sideMargin)
            $0.trailing.equalToSuperview().offset(-sideMargin)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(sideMargin)
            $0.bottom.equalTo(writeButton.snp.top).offset(-24)
        }

        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(sideMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }

        todayKeywordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.equalToSuperview().offset(sideMargin)
        }

        selectedKeywordLabel.snp.makeConstraints {
            $0.top.equalTo(todayKeywordLabel.snp.bottom).offset(12)
            $0.leading.equalTo(todayKeywordLabel)
        }

        emojiImageView.snp.makeConstraints {
            $0.top.equalTo(todayKeywordLabel)
            $0.trailing.equalToSuperview().offset(-sideMargin)
        }

        titleTextField.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(60)
            $0.leading.equalTo(todayKeywordLabel)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(18)
            $0.leading.equalTo(titleTextField)
            $0.trailing.equalToSuperview().offset(-sideMargin)
            $0.height.equalTo(1)
        }

        textView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(sideMargin)
            $0.trailing.equalToSuperview().offset(-sideMargin)
            $0.top.equalTo(dividerView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-(writeButtonHeight + 20))
        }
    }

    func bind(reactor: WriteDiaryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
}

private extension WriteDiaryViewController {
    enum TextViewEditingStatus {
        case didBegin
        case didEnd
    }

    func bindAction(reactor: WriteDiaryReactor) {
        writeButton.rx.tap
            .map { WriteDiaryReactor.Action.didTapWriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindState(reactor: WriteDiaryReactor) {
        reactor.state
            .subscribe()
            .disposed(by: disposeBag)
    }

    func isPlaceHolderString(_ string: String) -> Bool {
        return string == textViewPlaceholderString
    }

    func isEmptyTextView(_ string: String) -> Bool {
        return string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func textVieweditingAnimation(_ status: TextViewEditingStatus) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            let yPosition: CGFloat
            switch status {
            case .didBegin:
                yPosition = -100
            case .didEnd:
                yPosition = 0
            }

            self?.view.frame.origin.y = yPosition
        })
    }
}
