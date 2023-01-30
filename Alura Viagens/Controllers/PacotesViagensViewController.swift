//
//  PacotesViagensViewController.swift
//  Alura Viagens
//
//  Created by Alura on 25/06/18.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit

class PacotesViagensViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var colecaoPacotesViagens: UICollectionView!
    @IBOutlet weak var pesquisarViagens: UISearchBar!
    @IBOutlet weak var labelContadorPacotes: UILabel!
    
    // MARK: - Atributos
    
    let listaComTodasViagens: [PacoteViagem] = PacoteViagemDao().retornaTodasAsViagens()
    var listaViagens: [PacoteViagem] = []
    var pacoteSelecionado: PacoteViagem?
    var frameSelecionado: CGRect?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pesquisarViagens.delegate = self
        navigationController?.delegate = self
        listaViagens = listaComTodasViagens
        labelContadorPacotes.text = atualizaContadorLabel()
    }
    
    // MARK: - Métodos
    
    func atualizaContadorLabel() -> String {
        return listaViagens.count == 1 ? "1 pacote encontrado" : "\(listaViagens.count) pacotes encontrados"
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listaViagens = listaComTodasViagens
        if searchText != "" {
            listaViagens = listaViagens.filter({ $0.viagem.titulo.contains(searchText) })
        }
        labelContadorPacotes.text = atualizaContadorLabel()
        colecaoPacotesViagens.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaViagens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celulaPacote = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaPacote", for: indexPath) as! PacotesCollectionViewCell
        let pacoteAtual = listaViagens[indexPath.item]
        celulaPacote.configuraCelula(pacoteAtual)
        
        return celulaPacote
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pacote = listaViagens[indexPath.item]
        pacoteSelecionado = pacote
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "detalhes") as! DetalhesViagemViewController
        controller.pacoteSelecionado = pacote
        
        let atributosItemSelecionado = collectionView.layoutAttributesForItem(at: indexPath)
        frameSelecionado = atributosItemSelecionado?.frame
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UICollectionViewLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: collectionView.bounds.width/2-20, height: 160) : CGSize(width: collectionView.bounds.width/3-20, height: 250)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let caminhoDaImagem = pacoteSelecionado?.viagem.caminhoDaImagem else { return nil }
        guard let imagem = UIImage(named: caminhoDaImagem) else { return nil }
        guard let frame = frameSelecionado else { return nil }
        
        switch operation {
        case .push:
            return AnimacaoTransicaoPersonalizada(
                duracao: TimeInterval(UINavigationControllerHideShowBarDuration),
                imagem: imagem, frameInicial: frame,
                apresentarViewController: true)
        default:
            return AnimacaoTransicaoPersonalizada(
                duracao: TimeInterval(UINavigationControllerHideShowBarDuration),
                imagem: imagem,
                frameInicial: frame,
                apresentarViewController: false)
        }
    }
}
