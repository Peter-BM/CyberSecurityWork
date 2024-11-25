
# Blog Avaliação A1/3 Cyber Security

## Descrição
Esta aplicação é uma API para gerenciar um blog com autenticação baseada em JWT, autorização com Pundit, e gerenciamento de tokens. Você pode realizar operações CRUD em posts, testar autenticação, autorização e manuseio de tokens usando o **Postman**.

## Requisitos
- **Ruby**: Versão 3.1 ou superior.
- **Rails**: Versão 7 ou superior.

## Instalação

1. **Clone o Repositório**
   ```bash
   git clone https://github.com/Peter-BM/CyberSecurityWork.git
   cd <Local onde o projeto foi clonado>
   ```

2. **Instale as Dependências**
   Certifique-se de que você está com a versão correta do Ruby configurada e instale as gems:
   ```bash
   bundle install
   ```

3. **Configure o Banco de Dados**
   - Como não será feito deploy da aplicação, não é necessário a criação de um banco de dados do zero, apenas execute as migrações.
   
     ```bash
     rails db:create db:migrate
     ```

4. **Inicie o Servidor**
   Execute o servidor Rails:
   ```bash
   rails server
   ```

## Testando no Postman

### 1. Criar um Usuário
Crie um usuário para autenticação.
- **Método**: `POST`
- **URL**: `http://localhost:3000/signup`
- **Body** (JSON):
  ```json
  {
    "user": {
      "name": "Usuário Teste",
      "email": "teste@example.com",
      "password": "senha123",
      "password_confirmation": "senha123"
    }
  }
  ```
- **Resposta Esperada**:
  ```json
  {
      "message": "User created successfully",
      "user": {
          "id": 4,
          "name": "Usuário Teste",
          "email": "teste@example.com",
          "password_digest": "<hash>",
          "created_at": "<current_date>",
          "updated_at": "<current_date>"
      }
  }
  ```

### 2. Login
Autentique o usuário e receba o token JWT.
- **Método**: `POST`
- **URL**: `http://localhost:3000/login`
- **Body** (JSON):
  ```json
  {
    "email": "teste@example.com",
    "password": "senha123"
  }
  ```
- **Resposta Esperada**:
  ```json
  {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
  ```

### 3. Criar um Post
Use o token JWT para criar um post.
- **Método**: `POST`
- **URL**: `http://localhost:3000/posts`
- **Headers**:
  - `Authorization`: `Bearer <seu_token>`
- **Body** (JSON):
  ```json
  {
    "title": "Meu Primeiro Post",
    "body": "Este é o conteúdo do post."
  }
  ```
- **Resposta Esperada**:
  ```json
  {
    "id": 1,
    "title": "Meu Primeiro Post",
    "body": "Este é o conteúdo do post.",
    "user_id": 1
  }
  ```

### 4. Listar Posts
Liste todos os posts.
- **Método**: `GET`
- **URL**: `http://localhost:3000/posts`
- **Headers**:
  - `Authorization`: `Bearer <seu_token>`
- **Resposta Esperada**:
  ```json
  
  {
    "title": "Meu Primeiro Post",
    "user_id": 1, 
    "id": 1,
    "body": "Este é o conteúdo do post.",
    "created_at": "<current_date>",
    "updated_at": "<current_date>"
  }
  
  ```

### 5. Atualizar um Post
Atualize um post criado por você.
- **Método**: `PATCH`
- **URL**: `http://localhost:3000/posts/1`
- **Headers**:
  - `Authorization`: `Bearer <seu_token>`
- **Body** (JSON):
  ```json
  {
    "title": "Post Atualizado"
  }
  ```
- **Resposta Esperada**:
  ```json
  {
    "title": "Post Atualizado",
    "user_id": 1,
    "id": 1,
    "body": "Este é o conteúdo do post.",
    "created_at": "<current_date>",
    "updated_at": "<current_date>"
  }


  ```

### 6. Excluir um Post
Exclua um post criado por você.
- **Método**: `DELETE`
- **URL**: `http://localhost:3000/posts/1`
- **Headers**:
  - `Authorization`: `Bearer <seu_token>`
- **Resposta Esperada**:
  ```json
  {
    "message": "Post deleted successfully"
  }
  ```

### 7. Tentar Editar um Post de Outro Usuário
- **Método**: `PATCH`
- **URL**: `http://localhost:3000/posts/1`
- **Headers**:
  - `Authorization`: `Bearer <token_de_outro_usuario>`
- **Resposta Esperada**:
  ```json
  {
    "errors": "not allowed to PostPolicy#update? this Post"
  }
  ```

### 8. Revogar Token
- **Método**: `POST`
- **URL**: `http://localhost:3000/revoke`
- **Headers**:
  - `Authorization`: `Bearer <seu_token>`
- **Resposta Esperada**:
  ```json
  {
    "message": "Token revoked successfully"
  }
  ```

## Testando Validade e Revogação de Tokens
1. Gere um token pelo login.
2. Acesse endpoints protegidos com o token antes do tempo de expiração (5 min, podendo ser alterado em **/app/controllers/auth_controller.rb**).
3. Revogue o token usando o endpoint `/revoke`.
4. Tente acessar endpoints protegidos novamente com o token revogado (espera-se um erro `401 Unauthorized`).

