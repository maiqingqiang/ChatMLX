//
//  MessageItemView.swift
//  ChatMLX
//
//  Created by John Mai on 2024/3/1.
//

import MarkdownUI
import SwiftUI

struct MessageView: View {
    let message: Message

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if message.role == .assistant {
                    Image(nsImage: NSImage(resource: ImageResource(name: "logo", bundle: .main)))
                        .resizable()
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray.opacity(0.3), radius: 1)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .padding(5)
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(color: .gray.opacity(0.3), radius: 1)
                }
                
                Text(message.role.rawValue)
                    .font(.title3.weight(.semibold))
                    
            }.foregroundColor(.primary)
            
            Markdown(message.content)
            Spacer()
        }
    }
}

#Preview {
    MessageView(message: Message(
        role: .user,
        content: """
        # MLX
        
        MLX is an array framework for machine learning research on Apple silicon,
        brought to you by Apple machine learning research.
        
        Some key features of MLX include:
        
         - **Familiar APIs**: MLX has a Python API that closely follows NumPy.  MLX
           also has fully featured C++, [C](https://github.com/ml-explore/mlx-c), and
           [Swift](https://github.com/ml-explore/mlx-swift/) APIs, which closely mirror
           the Python API.  MLX has higher-level packages like `mlx.nn` and
           `mlx.optimizers` with APIs that closely follow PyTorch to simplify building
           more complex models.
        
         - **Composable function transformations**: MLX supports composable function
           transformations for automatic differentiation, automatic vectorization,
           and computation graph optimization.
        
         - **Lazy computation**: Computations in MLX are lazy. Arrays are only
           materialized when needed.
        
         - **Dynamic graph construction**: Computation graphs in MLX are constructed
           dynamically. Changing the shapes of function arguments does not trigger
           slow compilations, and debugging is simple and intuitive.
        
         - **Multi-device**: Operations can run on any of the supported devices
           (currently the CPU and the GPU).
        
         - **Unified memory**: A notable difference from MLX and other frameworks
           is the *unified memory model*. Arrays in MLX live in shared memory.
           Operations on MLX arrays can be performed on any of the supported
           device types without transferring data.
        
        MLX is designed by machine learning researchers for machine learning
        researchers. The framework is intended to be user-friendly, but still efficient
        to train and deploy models. The design of the framework itself is also
        conceptually simple. We intend to make it easy for researchers to extend and
        improve MLX with the goal of quickly exploring new ideas.
        """))
}
