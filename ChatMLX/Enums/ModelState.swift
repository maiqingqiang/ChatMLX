//
//  LoadState.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/17.
//

import Foundation
import Tokenizers
import MLXLLM

enum ModelState {
    case idle
    case loaded(String, LLMModel, Tokenizer)
}
