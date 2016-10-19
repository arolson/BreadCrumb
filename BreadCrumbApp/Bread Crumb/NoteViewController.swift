//
//  NoteViewController.swift
//  Bread Crumb
//
//  Created by Andrew Olson on 10/5/16.
//  Copyright © 2016 Valhalla Applications. All rights reserved.
//

import UIKit

class NoteViewController: CoreDataViewController, UITextViewDelegate {
    @IBOutlet weak var noteTextView: UITextView!
    var pin: Pin?
    let startingText = "Take Notes Here."
    var viewHeight: CGFloat!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Notes"
        setupTextView()
        addNote()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewHeight = self.view.frame.height
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        let text = noteTextView.text
        if text != "" && text != startingText || pin?.notes != nil
        {
            saveNote()
            {
                self.save()
            }
        }
        unsubscribeToKeyboardNotifications()
    }
    func addNote()
    {
        //fetch the note
        
        let notes = fetchNotes(pin: pin!)
//        check for existing note
        if !(notes.isEmpty)
        {
            //if the note has text then set the color back to black
            //and view text = the note
            if let note = notes[0].text
            {
                pin?.notes = notes[0]
                noteTextView.textColor = UIColor.black
                noteTextView.text = note
                print("Note Found")
            }
        }
        else
        {
            print("No Notes")
        }
    }
    func setupTextView()
    {
        let font = UIFont(name: "Avenir",size: 24)
        noteTextView.font = font
        
        if noteTextView.text == ""
        {
            noteTextView.text = startingText
            noteTextView.textColor = UIColor.lightGray
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == startingText
        {
            textView.text = ""
        }
        textView.textColor = UIColor.black
    }

    func saveNote(handler: ((Void)->Void)?)
    {
        let text = noteTextView.text
        performInBackGround()
        {
           if self.pin?.notes == nil
           {
//            create a new note
                let note = Note(text: text!,context: self.context)
                note.pin = self.pin!
                self.pin?.notes = note
                print("New Note: \(note)")
           }
           else
           {
//            a note exists so we can change the text
                self.pin?.notes?.text = text
                let note = self.pin?.notes
                print("Old Note: \(note)")
           }
            handler?()
        }
        
    }
    /*MARK: KeyBoard Delegate*/
    func subscribeToKeyboardNotifications()
    {
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide,object: nil)
    }
    
    func unsubscribeToKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillHide,object: nil)
    }
    /*Mark: Keyboard Functionality */
    func keyboardWillShow(notification: NSNotification)
    {
        if self.view.frame.height == viewHeight
        {
            let height = self.view.frame.height - getKeyboardHeight(notification: notification)
            self.view.frame = newFrame(height: height)
        }
        else
        {
            let height = viewHeight - getKeyboardHeight(notification: notification)
            self.view.frame = newFrame(height: height)
        }
    }
    func keyboardWillHide(notification: NSNotification)
    {
        self.view.frame = newFrame(height: viewHeight)
    }
    func getKeyboardHeight(notification: NSNotification)-> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    func newFrame(height: CGFloat)->CGRect
    {
        let x = self.view.frame.origin.x
        let y = self.view.frame.origin.y
        let height = height
        let width = self.view.frame.width
        let frame = CGRect(x: x,y: y,width: width,height: height)
        return frame
    }
}
