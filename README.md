# Indexador de Perfis do GitHub

Uma aplicação Ruby on Rails completa para indexar e gerenciar perfis do GitHub com webscrapping automático, encurtamento de URLs e interface moderna.

## 🚀 Funcionalidades

- **Cadastro de Perfis**: Interface para cadastrar nome e URL do perfil do GitHub
- **Webscrapping Automático**: Extração automática de dados do perfil (followers, following, stars, contribuições, avatar, organização, localização)
- **Encurtamento de URLs**: Sistema próprio de encurtamento de URLs do GitHub
- **Busca Avançada**: Busca por nome, usuário, organização ou localização
- **Re-escaneamento**: Atualização manual dos dados do perfil
- **Interface Responsiva**: Design moderno com Bootstrap 5
- **Testes Automatizados**: Suite completa de testes com Minitest (Rails padrão)
- **Cobertura de Testes**: Relatórios detalhados com SimpleCov

## 🛠 Tecnologias Utilizadas

### Backend
- **Ruby on Rails 8.0.2**: Framework web principal (atualizado)
- **Ruby 3.2.0**: Versão mais recente compatível
- **SQLite3**: Banco de dados para desenvolvimento
- **HTTParty**: Cliente HTTP para webscrapping
- **Nokogiri**: Parser HTML para extração de dados
- **ActiveJob**: Processamento em background assíncrono
- **Whenever**: Agendamento de tarefas assíncronas

### Frontend
- **Bootstrap 5**: Framework CSS para interface responsiva
- **Bootstrap icons**: Ícones
- **HTML5/CSS3**: Estrutura e estilização
- **JavaScript**: Interatividade
### Testes e Qualidade
- **Minitest**: Framework de testes padrão do Rails
- **Minitest Reporters**: Relatórios coloridos e detalhados
- **SimpleCov**: Cobertura de código
- **Mocha**: Mocking e stubbing para testes
- **Fixtures**: Dados de teste consistentes

### Arquitetura e Padrões
- **MVC (Model-View-Controller)**: Arquitetura principal do Rails
- **Service Objects**: Lógica de negócio isolada
- **SOLID**: Princípios de design aplicados
- **DRY**: Evitar repetição de código

## 📋 Pré-requisitos

- Ruby 3.4+
- Rails 8.0+
- SQLite3
- Git

## 🔧 Instalação

### 1. Clone o repositório
```bash
git clone <repository-url>
cd coderhub
```

### 2. Instale as dependências
```bash
bundle install
```

### 3. Configure o banco de dados
```bash
rails db:create
rails db:migrate
```

### 4. Crie o arquivo `.env` na raiz do projeto, baseado no .env.example.
```bash
APP_URL=http://localhost:3000
```

### 5. Execute os testes (opcional)
```bash
rails test
```

### 6. Execute a rake para atualizar os perfis já cadastrados (opcional)
```bash
rake profiles:update_github_info
```

### 7. Inicie o servidor
```bash
rails server
```

A aplicação estará disponível em `http://localhost:3000`

## 📖 Como Usar

### Cadastrar um Perfil
1. Acesse a página principal
2. Preencha o nome e a URL do GitHub no formulário "Cadastrar Novo Perfil"
3. Clique em "Cadastrar"
4. Os dados do perfil serão extraídos automaticamente

### Buscar Perfis
1. Use o campo de busca na página principal
2. Digite qualquer informação (nome, usuário, organização, localização)
3. Os resultados serão filtrados automaticamente

### Visualizar Perfil
1. Clique em "Ver Perfil" em qualquer card de resultado
2. Visualize todas as informações detalhadas
3. Use os botões de ação para editar, re-escanear ou remover

### Re-escanear Dados
1. Na página do perfil, clique em "Re-escanear Dados"
2. Os dados serão atualizados com as informações mais recentes do GitHub

## 🏗 Arquitetura da Aplicação

### Models
- **Profile**: Modelo principal que representa um perfil do GitHub
  - Validações de dados
  - Callbacks para extração automática
  - Scopes para busca

### Controllers
- **ProfilesController**: Controlador principal com ações CRUD completas
  - `index`: Listagem e busca de perfis
  - `show`: Visualização detalhada
  - `new/create`: Cadastro de novos perfis
  - `edit/update`: Edição de perfis existentes
  - `destroy`: Remoção de perfis
  - `search`: Busca personalizada
  - `rescan`: Re-escaneamento de dados

### Parser Mapping
- Mapeamento dos seletores CSS para extração de dados do GitHub
- Facilita manutenção e atualização dos seletores
- Quando houver mudanças no layout do GitHub, basta atualizar o arquivo config/github_map.yml

### Services
- **GithubService**: Modulo responsável pelo webscrapping
  - Scrapper: Extração de dados do HTML do GitHub
  - Errors: Tratamento de erros e timeouts
  - Contributions: Cálculo de contribuições anuais que é buscado via webscrapping da API pública
  - ParsedProfile: Estrutura de dados retornada

- **UrlShortenerService**: Sistema de encurtamento de URLs
  - Geração de códigos únicos
  - URLs encurtadas consistentes

### Views
- Interface responsiva com Bootstrap
- Componentes reutilizáveis
- Formulários com validação
- Cards informativos para listagem

## 🧪 Testes

A aplicação possui uma suite completa de testes:

```bash
# Executar todos os testes
rails test

# Ver relatório de cobertura
open coverage/index.html
```

### Cobertura Atual
- **83.96%** de cobertura de código
- Testes de models, controllers, services e integração
- Mocks e stubs para dependências externas

### Tipos de Teste
- **Unit Tests**: Models e Services
- **Controller Tests**: Ações e responses
- **Integration Tests**: Fluxos completos
- **Request Tests**: APIs e rotas

## 🔍 Detalhes Técnicos

### Webscrapping
O sistema utiliza seletores CSS específicos para extrair dados do GitHub:
- Nome: `.p-name`
- Followers/Following: Links com contadores
- Avatar: `.avatar-user`
- Organização: `.p-org`
- Localização: `[data-test-selector="profile-location"]`

### Encurtamento de URLs
- Algoritmo baseado em hash MD5 dos primeiros 8 caracteres
- URLs no formato: `https://coderhub.app/s/{code}`
- Geração determinística para mesma URL


## 🚧 Limitações e Pontos de Melhoria

### Limitações Atuais
1. **Rate Limiting**: Não há controle de taxa para requisições ao GitHub
2. **Cache**: Dados não são cacheados, sempre fazem nova requisição
3. **Async Processing**: Webscrapping é síncrono, pode ser lento
4. **Error Handling**: Tratamento básico de erros de rede
5. **Database**: SQLite não é ideal para produção
6. **Authentication**: Não há autenticação de usuários

### Melhorias Sugeridas
1. **Background Jobs**: Usar Sidekiq/Resque para webscrapping assíncrono
2. **Cache System**: Implementar cache Redis para dados frequentes
3. **Rate Limiting**: Controlar requisições para evitar bloqueios
4. **Database**: Migrar para PostgreSQL em produção
5. **API Integration**: Usar GitHub API em vez de webscrapping
6. **User System**: Adicionar autenticação e perfis de usuário
7. **Monitoring**: Logs estruturados e métricas de performance
8. **Docker**: Containerização para deployment
9. **CI/CD**: Pipeline automatizado de testes e deploy
10. **Internationalization**: Suporte a múltiplos idiomas


## 📊 Métricas de Qualidade

- **Cobertura de Testes**: 83.96%
- **Complexidade**: Baixa (métodos pequenos e focados)
- **Manutenibilidade**: Alta (código bem estruturado)
- **Performance**: Adequada para escala pequena/média
- **Segurança**: Validações básicas implementadas

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Autor

@rpossan

---

**Nota**: Esta aplicação foi desenvolvida para fins educacionais e de demonstração. Para uso em produção, implemente as melhorias de segurança e performance sugeridas.


