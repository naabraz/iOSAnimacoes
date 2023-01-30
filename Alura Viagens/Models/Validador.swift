//
//  Validador.swift
//  Alura Viagens
//
//  Created by Alura on 05/01/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class Validador: NSObject {
    func validaTextFields(_ textFields: [UITextField?]) -> Bool {
        for textField in textFields {
            if textField?.text == "" {
                chacoalhar(textField)
                return false
            }
        }
        return true
    }
    
    func chacoalhar(_ textField: UITextField?) {
        guard let textField = textField else { return }
        let chacoalhar = CABasicAnimation(keyPath: "position")
        
        chacoalhar.duration = 0.1
        chacoalhar.repeatCount = 2
        chacoalhar.autoreverses = true
        
        let posicaoInicial = CGPoint(x: textField.center.x + 5, y: textField.center.y)
        chacoalhar.fromValue = posicaoInicial
        
        let posicaoFinal = CGPoint(x: textField.center.x - 5, y: textField.center.y)
        chacoalhar.toValue = posicaoFinal
        
        textField.layer.add(chacoalhar, forKey: nil)
    }
}
