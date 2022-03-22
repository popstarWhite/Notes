//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Максим Шмидт on 15.03.2022.
//

import UIKit

final class NoteDetailViewController: UIViewController {
    
    private let storageManager: StorageManagerProtocol
    private let note: Note?
    private let noteIndex: Int?
    private lazy var titleTextView = makeTextView(font: .boldSystemFont(ofSize: 35))
    private lazy var textView = makeTextView(font: .systemFont(ofSize: 23))
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(titleTextView)
        makeConstraint()
        titleTextView.textContainer.maximumNumberOfLines = 2
        setupNavigationBar()
    }
    
    init(
        storageManager: StorageManagerProtocol,
        note: Note? = nil,
        noteIndex: Int? = nil
    ) {
        self.note = note
        self.noteIndex = noteIndex
        self.storageManager = storageManager
        super.init(nibName: nil, bundle: nil)
        textView.text = note?.text
        titleTextView.text = note?.title
        title = note?.title ?? "Новая заметка"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NoteDetailViewController {
    
    func makeTextView(font: UIFont) -> UITextView {
        let view = UITextView(frame: .zero)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = font
        return view
    }
    
    func setupNavigationBar() {
        let saveButton = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(onSaveButtonTapped)
        )
        saveButton.tintColor = .black
        navigationItem.rightBarButtonItem = saveButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    func makeConstraint() {
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 3),
            titleTextView.heightAnchor.constraint(equalToConstant: 100),
            
            textView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 3)
        ])
    }
    
    @objc
    func onSaveButtonTapped() {
        let note = Note(text: textView.text, title: getNoteTitle(text: titleTextView.text))
        if let noteIndex = noteIndex {
            storageManager.saveNote(note, index: noteIndex)
        } else {
            storageManager.saveNewNote(note)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func getNoteTitle(text: String) -> String {
        guard text.count > 15 else { return text }
        var title = ""
        for (index, element) in text.enumerated() {
            guard index < 15 else { break }
            title.append(element)
        }
        return title + "..."
    }
}
