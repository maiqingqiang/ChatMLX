//
//  LoadState.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/17.
//

import Foundation
import Tokenizers

enum LoadState {
    case idle
    case loaded(LLMModel, Tokenizer)
}
