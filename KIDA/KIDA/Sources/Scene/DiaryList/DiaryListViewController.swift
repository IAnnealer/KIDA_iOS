//
//  DiaryListViewController.swift
//  KIDA
//
//  Created by choidam on 2022/01/17.
//

import UIKit
import RxDataSources

final class DiaryListViewController: BaseViewController, ServiceDependency {

    fileprivate struct Reuse {
        static let diaryListCell = ReuseCell<DiaryListCell>()
    }
    
    // MARK: UI
    
    private lazy var tableView = UITableView()
    
    // MARK: Property
    
    private static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<DiaryListSection>{
        return .init(configureCell: { dataSource, tableView, indexPath, sectionItem in
            switch sectionItem {
            case .item(let reactor):
                let cell = tableView.dequeue(Reuse.diaryListCell, for: indexPath)
                cell.reactor = reactor
                return cell
            }
        })
    }
    
    fileprivate var dataSource = DiaryListViewController.dataSourceFactory()
    
    var reactor: DiaryListViewReactor?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupNavigationBar() {
        self.setupNavigationBarTitle(title: KIDA_String.DiaryList.navigationTitle)
    }

    override func setupViews() {
        tableView.register(Reuse.diaryListCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .KIDA_background()
//        tableView.allowsSelection = false
        
        view.addSubview(tableView)
    }

    override func setupLayoutConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind(reactor: DiaryListViewReactor) {
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
}

extension DiaryListViewController {
    func reloadDiaryList() {
        reactor?.action
            .onNext(.loadDiaryList)
    }
}

private extension DiaryListViewController {

    func bindState(reactor: DiaryListViewReactor){
        
        reactor.state
            .map { $0.sections }
            .filter { !$0.isEmpty }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.errorMsg }
            .filter { $0 != nil }
        
    }

    func bindAction(reactor: DiaryListViewReactor){
        
        tableView.rx.modelSelected(DiaryListSectionItem.self)
            .map { item -> DiaryListCellReactor in
                switch item {
                case .item(let reactor):
                    return reactor
                }
            }
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                
                let diary: DiaryModel = model.initialState.diary
                print("@@@ diary: \(diary)")
                
                let okButtonAction: Notifier.AlertButtonAction = ("OK",
                                                                  action: { print("okbuttonaction") },
                                                                  style: .default)
                Notifier.alert(on: self,
                               title: "타이틀",
                               message: "메세지",
                               buttons: [okButtonAction])
                
            })
            .disposed(by: disposeBag)
        
    }
}
