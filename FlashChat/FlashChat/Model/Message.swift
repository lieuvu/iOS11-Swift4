//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message

struct Message {
    /// The sender of a message.
    var sender: String = ""
    
    /// The message content.
    var messageBody: String = ""
    
    /// The reference of a message from the database.
    var ref: String!
}
