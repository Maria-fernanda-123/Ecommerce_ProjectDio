#  DATABASE ECOMMERCE | DIO 

Este projeto consiste na concepção de um modelo **EER (Enhanced Entity-Relationship)** e na implementação de um banco de dados SQL para um cenário de E-commerce. O objetivo foi estruturar um ambiente robusto que suporte desde o cadastro de fornecedores e produtos até o rastreamento de pedidos e pagamentos.

Além da modelagem, foram desenvolvidas queries complexas para extrair **insights estratégicos**, simulando a tomada de decisão baseada em dados para otimização de processos do negócio.
___
## Requerimentos 

* MySQL

___
## MODELO EER

Primeiro inciei pela criacao do modelo relacional, na qual defini as entidades da tabela e seus atributos. Apos esta etapa inciei a criacao das tabelas. 
  As entidades foram dividas em: 
### 1. Entidades Principais e Atributos

#### **Customer (Cliente)**

Armazena as informações dos usuários, suportando identificação por CPF ou CNPJ.

-   **idCustomer (PK):** Identificador único.
    
-   **Fname / Lname:** Nome e sobrenome.
    
-   **CPF / CNPJ:** Documento de identificação.
    
-   **Address / UF:** Localização para entrega.
    

#### **Product (Produto)**

Catálogo de itens disponíveis na plataforma.

-   **idProduct (PK):** Identificador do produto.
    
-   **Pname:** Nome do produto.
    
-   **Category:** Categoria (Eletrônicos, Moda, Brinquedos, etc).
    
-   **Evaluation:** Nota de avaliação dos usuários.
    

#### **Orders (Pedidos)**

Registro das intenções de compra realizadas pelos clientes.

-   **idOrder (PK):** Código do pedido.
    
-   **idOrderCustomer (FK):** Referência ao cliente.
    
-   **StatusOrder:** Status (Pendente, Processando, Enviado, Entregue).
    
-   **SendValue:** Valor do frete calculado.
    

#### **Payments (Pagamentos)**

Gerencia as transações financeiras vinculadas aos pedidos.

-   **idPayment (PK):** Identificador da transação.
    
-   **idPayOrder (FK):** Vinculação com o Pedido.
    
-   **TypePayment:** Método (Cartão, Boleto, PIX).
    

#### **Seller (Vendedor / Terceiro)**

Vendedores que utilizam a plataforma para anunciar produtos (Marketplace).

-   **idSeller (PK):** Identificador do vendedor.
    
-   **SocialName:** Razão social ou nome fantasia.
    
-   **AbstLocation:** Localização base.
    

#### **Supplier (Fornecedor)**

Origem primária dos produtos para o estoque.

-   **idSupplier (PK):** Identificador do fornecedor.
    
-   **SocialName:** Nome da empresa fornecedora.
    
-   **CNPJ:** Registro nacional da empresa.
    

#### **Stock (Estoque)**

Controle de volumes e quantidades disponíveis.

-   **idStock (PK):** Identificador do centro de estoque.
    
-   **Local:** Endereço físico do armazém.

### 2. Tabelas de Relacionamento (M:N)

Estas tabelas conectam as entidades principais, permitindo relações complexas como um pedido com vários produtos.

-   **Order_Product:** Conecta **Orders** e **Product**.
    
    -   _Atributos:_ `idPOproduct (FK)`, `idPOorder (FK)`, `poQuantity` (Quantidade).
        
-   **Product_Seller:** Conecta **Product** e **Seller**.
    
    -   _Atributos:_ `idPseller (FK)`, `idPproduct (FK)`, `prodQuantity` (Disponibilidade).
        
-   **Storage_Location:** Conecta **Product** e **Stock**.
    
    -   _Atributos:_ `idLproduct (FK)`, `idLstorage (FK)`, `location` (Corredor/Prateleira).

### 🚀 Como utilizar

1.  O diagrama visual está disponível na pasta `/diagrams`.
    
2.  O script de criação das tabelas e das queries estão em `Ecommerce_Atualizado.sql`.
