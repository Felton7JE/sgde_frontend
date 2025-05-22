# CETIC SGDE Frontend

Este projeto é o frontend do Sistema de Gestão de Equipamentos (SGDE) do CETIC, desenvolvido em Flutter para web e desktop. O sistema permite o controle, requisição, alocação, manutenção, empréstimo e avaria de equipamentos de forma centralizada, moderna e responsiva.

## Funcionalidades Principais

- **Gestão de Equipamentos:** Cadastro, edição, remoção e visualização de equipamentos, com campos detalhados (número de série, nome, categoria, marca, modelo, status, etc).
- **Requisição de Equipamentos:** Solicitação de equipamentos por usuários, com controle de status, justificativa e quantidade.
- **Alocação de Equipamentos:** Alocação de equipamentos a usuários ou setores, com histórico e controle de devolução.
- **Empréstimo de Equipamentos:** Controle de empréstimos temporários, datas de devolução, status e responsável.
- **Manutenção de Equipamentos:** Registro de manutenções, tipos, datas, responsáveis, status e tempo de inatividade.
- **Avaria de Equipamentos:** Registro de avarias, tipos, gravidade, status e histórico de resolução.
- **Dashboard:** Visão geral com cards de totais, pendências e status dos equipamentos.
- **Exportação para PDF:** Todas as tabelas possuem botão de exportação para PDF (ao lado do campo de pesquisa), com layout profissional, sem a coluna de ações.
- **Pesquisa e Paginação:** Todas as tabelas possuem campo de pesquisa e paginação customizada.
- **Interface Responsiva:** Layout adaptável para diferentes tamanhos de tela, com visual moderno e profissional.

## Estrutura do Projeto

```
lib/
  main.dart                  # Ponto de entrada do app
  auth/                      # Autenticação e cadastro de usuários
    models/                  # Modelos de autenticação
    pages/                   # Telas de login, cadastro, redefinição de senha
    service/                 # Serviços de autenticação
  restrict/
    models/                  # Modelos de dados do domínio (equipamento, requisição, etc)
    pages/                   # Telas principais do sistema (dashboard, tabelas, formulários)
      componets/             # Componentes reutilizáveis (tabelas, cards, formulários)
    service/                 # Providers e serviços de dados
  src/                       # Temas, utilitários e widgets auxiliares
assets/                      # Imagens e recursos estáticos
```

## Como Executar

1. **Pré-requisitos:**
   - Flutter SDK instalado ([instale aqui](https://docs.flutter.dev/get-started/install))
   - Dependências do projeto instaladas (`flutter pub get`)

2. **Rodando o projeto:**
   - Para web: `flutter run -d chrome`
   - Para desktop: `flutter run -d windows` (ou outro SO suportado)

3. **Build para produção:**
   - Web: `flutter build web`
   - Desktop: `flutter build windows`

## Padrões e Tecnologias Utilizadas

- **Flutter**: Framework principal para UI multiplataforma
- **Provider**: Gerenciamento de estado
- **pdf / printing**: Geração e exportação de relatórios em PDF
- **Material Design**: Interface moderna e responsiva

## Observações Importantes

- O botão "Exportar PDF" está presente em todas as tabelas, ao lado do campo de pesquisa, e exporta os dados sem a coluna de ações.
- O layout das tabelas é compacto, com header azul e visual profissional.
- O projeto segue boas práticas de organização de código, separação de responsabilidades e uso de componentes reutilizáveis.

## Contribuição

Pull requests são bem-vindos! Para sugestões, correções ou melhorias, abra uma issue ou envie seu PR.

