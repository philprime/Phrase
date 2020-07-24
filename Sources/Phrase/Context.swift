//
//  Context.swift
//  Phrase
//
//  Created by Philip Niedertscheider on 05.07.20.
//  Copyright © Philip Niedertscheider. All rights reserved.
//

/// Type of values which are allowed to be set in the context
public typealias ContextValue = AnyHashable
/// A context holds a list of named values
public typealias Context = [String: ContextValue]
