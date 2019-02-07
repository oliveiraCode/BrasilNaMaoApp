//
//  Constants.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2019-01-25.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

enum LocalizationKeys {
    //Menu
    static let menuHome = "Página inicial"
    static let menuSettings = "Configuração"
    
    //Settings
    static let settingsAccount = "Perfil"
    static let settingsShare = "Compartilhar"
    static let settingsContactUs = "Fale conosco"
    static let settingsTermsOfUse = "Termos de uso"
    static let settingsPrivacy = "Política de privacidade"
    static let settingsAbout = "Sobre"
    
    //Account
    static let buttonLogin = "Entrar"
    static let buttonLogout = "Sair"
    static let accountName = "Visitante"
    static let accountEditProfile = "Editar Perfil"
    static let accountDeleteProfile = "Deletar Minha Conta"
    static let imageUserDefault = "user"
    static let accessProfile = "É necessário estar conectado para ter acesso ao Perfil."
    static let updateProfile = "Os dados foram atualizados com sucesso."
    
    //ButtonsDefault
    static let buttonCancel = "Cancelar"
    static let buttonSave = "Salvar"
    static let buttonDone = "Finalizar"
    static let buttonContinue = "Continuar"
    static let buttonOK = "OK"
    
    //PickImage
    static let buttonCamera = "Câmera"
    static let buttonPhotoLibrary = "Galeria"
    
    //MyBusinessViewController
    static let buttonSelectCategory = "Selectionar categoria"
    
    //Activity Indicator
    static let pleaseWait = "Por favor, aguarde um momento..."
    
    
}

enum periodOfDay {
    //set the values to show into menu-profile
    static let goodMorging = "Bom dia,"
    static let goodAfternoon = "Boa tarde,"
    static let goodEvening = "Boa noite,"
}

enum Coordinates {
    //set coordinates from Montreal - approximate
    static let latitude = 45.5576996
    static let longitude = -74.0104841
}

enum Placeholders {
    static let placeholder_photo = "placeholder_photo"
    static let placeholder_descricao = "Escreva aqui a descrição do seu anúncio."
}


enum General {
    static let congratulations = "Parabéns!"
    static let successfully = "A sua conta foi criada com sucesso!"
    static let OK = "OK"
    static let warning = "Aviso"
    static let errorSigingUp = "Ocorreu um erro para logar, tente novamente."
    static let warningPhotoCameraDenied = "O acesso a sua biblioteca de fotos e/ou a câmera foi negado anteriormente, por favor, vá no menu configurações do seu celular e habilite novamente."
    static let businessCreated = "Anúncio criado com sucesso."
    static let removeAccount = "Essa operação não poderá ser desfeita e os dados serão perdidos. Deseja continuar ?"

}

enum CoreDataConstants{
    static let CDUser = "CDUser"
}


enum FirebaseAuthErrors {
    static let invalidEmail = "E-mail inválido."
    static let wrongPassword = "Senha incorreta."
    static let emailAlreadyInUse = "Este e-mail já está sendo usado."
    static let weakPassword = "A senha precisa ter no mínimo 6 caracteres"
    static let warning = "Atenção!"
    static let errorDefault = "É necessário preencher os campos obrigatórios."
    static let userNotFound = "Usuário não encontrado. Por favor, tente novamente!"
    static let userDisabled = "A sua conta esta desabilitada. \nEntre em contato com o administrador do sistema."
    static let networkError = "A conexão com a internet esta indisponível. \n\nVerifique e tente novamente."
}

enum CommonWarning {
    static let  passwordDontMatch = "As senhas precisam ser iguais."
    static let  passwordEmpty = "O campo senha esta vazio."
    static let  emailEmpty = "O campo e-mail esta vazio."
    static let  emailResetPassword = "Informe o e-mail da conta que deseja trocar senha."
    static let  generalError = "Ocorreu um erro, tente novamente."
    static let  emailSentResetPassword = "Um e-mail com as instruções para redefinir a senha foi enviado com sucesso. \n\nVerifique a sua caixa de entrada."
    static let  errorMessageInvalidPhone = "Telefone inválido"
    static let  errorEmail = "E-mail inválido"
    static let  errorWebSite = "URL inválida"
    static let  errorNewBusiness = "Você precisa estar conectado para cadastrar um anúncio."
}






