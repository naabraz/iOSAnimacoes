import UIKit

class AnimacaoTransicaoPersonalizada: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Atributos
    
    private var duracao: TimeInterval
    private var imagem: UIImage
    private var frameInicial: CGRect
    private var apresentarViewController: Bool
    
    // MARK: - Inicializador
    
    init(duracao: TimeInterval, imagem: UIImage, frameInicial: CGRect, apresentarViewController: Bool) {
        self.duracao = duracao
        self.imagem = imagem
        self.frameInicial = frameInicial
        self.apresentarViewController = apresentarViewController
    }
    
    // MARK: - Metodos
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duracao
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let viewInicial = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let viewFinal = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        let contexto = transitionContext.containerView
        
        if apresentarViewController {
            contexto.addSubview(viewFinal)
        } else {
            contexto.insertSubview(viewFinal, belowSubview: viewInicial)
        }
        
        let viewAtual = apresentarViewController ? viewFinal : viewInicial
        
        guard let imagemDaViagem = viewAtual.viewWithTag(1) as? UIImageView else { return }
        imagemDaViagem.image = imagem
        
        let imagemDeTransicao = UIImageView(frame: frameInicial)
        imagemDeTransicao.image = imagem
        
        contexto.addSubview(imagemDeTransicao)
        
        viewAtual.frame = apresentarViewController ? CGRect(
            x: viewInicial.frame.width,
            y: 0,
            width: viewFinal.frame.width,
            height: viewFinal.frame.height) : viewInicial.frame
        
        viewAtual.layoutIfNeeded()
        
        UIView.animate(withDuration: duracao, animations: {
            imagemDeTransicao.frame = self.apresentarViewController ? imagemDaViagem.frame : self.frameInicial
            viewAtual.frame = self.apresentarViewController ? viewInicial.frame : CGRect(
                x: viewInicial.frame.width, y: 0,
                width: viewFinal.frame.width,
                height: viewFinal.frame.height)
        }) { (_ ) in
            imagemDeTransicao.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
