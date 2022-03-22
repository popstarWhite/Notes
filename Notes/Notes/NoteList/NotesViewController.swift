//
//  ViewController.swift
//  Notes
//
//  Created by Максим Шмидт on 15.03.2022.
//

import UIKit

final class NotesViewController: UIViewController {
    private lazy var tableView = makeTableView()
    private let storageManager: StorageManagerProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    init(storageManager: StorageManagerProtocol) {
        self.storageManager = storageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        storageManager.getNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = storageManager.getNotes()[indexPath.row]
        cell.textLabel?.text = note.title
        cell.backgroundColor = .systemGray5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = storageManager.getNotes()[indexPath.row]
        let viewController = NoteDetailViewController(storageManager: storageManager, note: note, noteIndex: indexPath.item)
        navigationController?.pushViewController(viewController, animated: true)
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipe = UISwipeActionsConfiguration(
            actions: [
                .init(
                    style: .destructive,
                    title: "Удалить",
                    handler: { [weak self] _, _, _ in
                        guard let note = self?.storageManager.getNotes()[indexPath.row] else { return }
                        self?.onDeletingNote(
                            note: note,
                            index: indexPath.item
                        )
        })]
        )
        return swipe
    }
    
    private func onDeletingNote(note: Note, index: Int) {
        storageManager.removeNote(note, index: index)
        UIView.animate(withDuration: 0.1) {
            self.tableView.reloadSections(.init(integer: 0), with: .automatic)
        }
    }
}

private extension NotesViewController {
    func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .lightGray
        tableView.tintColor = .darkText
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
        return tableView
    }
    
    func setupNavigationBar() {
        title = "Заметки"
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onAddButtonTapped)
        )
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    func onAddButtonTapped() {
        let noteDetailVC = NoteDetailViewController(storageManager: storageManager)
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
}
