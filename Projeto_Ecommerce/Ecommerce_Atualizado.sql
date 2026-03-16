CREATE DATABASE ecommerce;
USE ecommerce;

-- ALTERTABLE
-- Região Sudeste (10 clientes)
UPDATE customer SET UF = 'SP' WHERE idCustomer BETWEEN 21 AND 25;
UPDATE customer SET UF = 'RJ' WHERE idCustomer BETWEEN 26 AND 30;

-- Região Nordeste (10 clientes)
UPDATE customer SET UF = 'BA' WHERE idCustomer BETWEEN 31 AND 35;
UPDATE customer SET UF = 'PE' WHERE idCustomer BETWEEN 36 AND 40;

-- Região Sul (10 clientes)
UPDATE customer SET UF = 'PR' WHERE idCustomer BETWEEN 41 AND 45;
UPDATE customer SET UF = 'RS' WHERE idCustomer BETWEEN 46 AND 50;

-- Região Centro-Oeste e Norte (10 clientes)
UPDATE customer SET UF = 'MT' WHERE idCustomer BETWEEN 51 AND 55;
UPDATE customer SET UF = 'AM' WHERE idCustomer BETWEEN 56 AND 60;

UPDATE customer SET UF = 'SP' WHERE idCustomer IN (1, 6);
UPDATE customer SET UF = 'RJ' WHERE idCustomer IN (2, 7);
UPDATE customer SET UF = 'MG' WHERE idCustomer IN (3, 8);
UPDATE customer SET UF = 'BA' WHERE idCustomer IN (4, 9);
UPDATE customer SET UF = 'CE' WHERE idCustomer IN (5, 10);
alter table Customer
ADD UF VARCHAR (2);
ALTER TABLE ORDERS 
ADD Tracking_Number VARCHAR(50);
ALTER TABLE customer AUTO_INCREMENT = 1;
ALTER TABLE supplier AUTO_INCREMENT = 1;
ALTER TABLE seller AUTO_INCREMENT = 1;
ALTER TABLE product AUTO_INCREMENT = 1;
ALTER TABLE stock AUTO_INCREMENT = 1;
ALTER TABLE payments AUTO_INCREMENT = 1;
ALTER TABLE orders AUTO_INCREMENT = 1;
ALTER TABLE customer MODIFY Email VARCHAR(50);
ALTER TABLE customer MODIFY CPF VARCHAR(20) NULL;
ALTER TABLE seller MODIFY CNPJ CHAR(14) NULL;
ALTER TABLE seller 
ADD CONSTRAINT check_documento_unico 
CHECK (
    (CNPJ IS NOT NULL AND CPF IS NULL) OR 
    (CNPJ IS NULL AND CPF IS NOT NULL)
);
-- RECUPERANDO A TABELA 
CREATE TABLE customer (
    idCustomer INT NOT NULL AUTO_INCREMENT,
    Fname VARCHAR(20),
    Minit VARCHAR(20),
    Lname VARCHAR(20),
    Email VARCHAR(20),
    Address VARCHAR(45),
    Birthday DATE,
    Phone VARCHAR(20),
    CPF VARCHAR(20),
    PRIMARY KEY (idCustomer),
    UNIQUE KEY UNIQUE_CPF_CUSTOMER (CPF)
);
CREATE TABLE supplier (
    Id_Supplier INT NOT NULL AUTO_INCREMENT,
    Legal_Name VARCHAR(45) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    Lead_Time FLOAT,
    PRIMARY KEY (Id_Supplier),
    UNIQUE KEY UNIQUE_CNPJ_Supplier (CNPJ)
);

CREATE TABLE seller (
    Id_Seller INT NOT NULL AUTO_INCREMENT,
    Legal_Name VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Address VARCHAR(45),
    Location VARCHAR(45),
    Phone VARCHAR(20) NOT NULL,
    Pessoa_Juridica TINYINT(1) GENERATED ALWAYS AS (
        CASE 
            WHEN CNPJ IS NOT NULL THEN TRUE
            WHEN CPF IS NOT NULL THEN FALSE
            ELSE NULL
        END
    ) STORED,
    PRIMARY KEY (Id_Seller),
    UNIQUE KEY UNIQUE_CNPJ_Seller (CNPJ),
    UNIQUE KEY UNIQUE_CPF_Seller (CPF)
);

CREATE TABLE product (
    IdProduct INT NOT NULL AUTO_INCREMENT,
    Pname VARCHAR(20) NOT NULL,
    Children_Classification TINYINT(1),
    Category ENUM(
        'Electronics','Clothing','Food','Furniture',
        'Books','Toys','Beauty','Sports','Office','Other'
    ) NOT NULL,
    Price FLOAT,
    Revenue FLOAT,
    Sale_Price FLOAT,
    Cost_Price FLOAT,
    Rate FLOAT DEFAULT 0,
    Size VARCHAR(20),
    BRAND VARCHAR(20),
    PRIMARY KEY (IdProduct)
);

CREATE TABLE stock (
    Id_Stock INT NOT NULL AUTO_INCREMENT,
    Location VARCHAR(45),
    Minimum_Stock INT NOT NULL,
    Stock_Status ENUM(
        'in_stock','out_of_stock','pre_order','discontinued'
    ) NOT NULL,
    Quantity INT NOT NULL,
    Id_Product INT NOT NULL,
    PRIMARY KEY (Id_Stock)
);

CREATE TABLE storage_location (
    Id_stock INT NOT NULL,
    Id_Product INT NOT NULL,
    Location VARCHAR(45),
    Quantity INT DEFAULT 1,
    PRIMARY KEY (Id_stock, Id_Product),
    KEY FK_Id_Product_Location (Id_Product),
    CONSTRAINT FK_Id_Product_Location 
        FOREIGN KEY (Id_Product) REFERENCES product(IdProduct),
    CONSTRAINT FK_Id_Stock_Location 
        FOREIGN KEY (Id_stock) REFERENCES stock(Id_Stock)
);

CREATE TABLE payments (
    IdPayment INT NOT NULL AUTO_INCREMENT,
    Id_PaymentCustomer INT NOT NULL,
    Payment_Value DECIMAL(10,2) NOT NULL,
    Fees DECIMAL(10,2) NOT NULL,
    Payment_Type ENUM('CARD','BANK TRANSFER'),
    Payment_Status ENUM('Pending','Processing','Approved'),
    LimitAvailable DECIMAL(10,2),
    PRIMARY KEY (IdPayment),
    KEY fk_payment_customer (Id_PaymentCustomer),
    CONSTRAINT fk_payment_customer 
        FOREIGN KEY (Id_PaymentCustomer) 
        REFERENCES customer(idCustomer)
);

CREATE TABLE orders (
    Id_Orders INT NOT NULL AUTO_INCREMENT,
    Orders_Status ENUM(
        'Placed','Confirmed','Processing','Invoiced',
        'Shipped','Out for delivery','Delivered'
    ) DEFAULT 'Processing',
    idOrders_Customer INT,
    Delivery_Fee FLOAT NOT NULL,
    Product_Description VARCHAR(45),
    SendValue FLOAT DEFAULT 10,
    IdOrders_Payment INT,
   Payment BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (Id_Orders),
    KEY fk_orders_customer (idOrders_Customer),
    KEY fk_Orders_Payment (IdOrders_Payment),
    CONSTRAINT fk_orders_customer 
        FOREIGN KEY (idOrders_Customer) 
        REFERENCES customer(idCustomer),
    CONSTRAINT fk_Orders_Payment 
        FOREIGN KEY (IdOrders_Payment) 
        REFERENCES payments(IdPayment)
			on update cascade
);

CREATE TABLE product_seller (
    Id_Seller INT NOT NULL,
    Id_Product INT NOT NULL,
    QUANTITY INT DEFAULT 1,
    PRIMARY KEY (Id_Seller, Id_Product),
    KEY FK_Id_Product (Id_Product),
    CONSTRAINT FK_Id_Product 
        FOREIGN KEY (Id_Product) REFERENCES product(IdProduct),
    CONSTRAINT FK_Id_Seller 
        FOREIGN KEY (Id_Seller) REFERENCES seller(Id_Seller)
);

CREATE TABLE order_product (
    Id_ProductOrder INT NOT NULL,
    Id_Order INT NOT NULL,
    Quantity INT,
    PRIMARY KEY (Id_ProductOrder, Id_Order),
    KEY FK_Id_Order (Id_Order),
    CONSTRAINT FK_Id_Order 
        FOREIGN KEY (Id_Order) REFERENCES orders(Id_Orders),
    CONSTRAINT FK_Id_Product_Order 
        FOREIGN KEY (Id_ProductOrder) REFERENCES product(IdProduct)
);
-- Populando o Ecommerce  


-- TABELA CUSTOMER
INSERT INTO customer (Fname, Minit, Lname, Email, Address, Birthday, Phone, CPF) VALUES
('Ricardo', 'A', 'Silva', 'ricardo@email.com', 'Rua das Flores, 123', '1985-05-12', '11988887777', '12345678901'),
('Maria', 'B', 'Oliveira', 'maria@email.com', 'Av. Paulista, 1500', '1990-07-22', '11977776666', '23456789012'),
('Roberto', 'C', 'Santos', 'roberto@email.com', 'Rua Bahia, 789', '1978-03-15', '21966665555', '34567890123'),
('Patrícia', 'D', 'Souza', 'patricia@email.com', 'Av. Brasil, 321', '1982-11-30', '31955554444', '45678901234'),
('Marcelo', 'E', 'Costa', 'marcelo@email.com', 'Rua Amazonas, 654', '1995-01-20', '41944443333', '56789012345'),
('Juliana', 'F', 'Pereira', 'juliana@email.com', 'Travessa Sol, 987', '1988-09-05', '51933332222', '67890123456'),
('Wilson', 'G', 'Ferreira', 'wilson@email.com', 'Rua do Porto, 147', '1975-06-18', '61922221111', '78901234567'),
('Elizabeth', 'H', 'Alves', 'elizabeth@email.com', 'Rua XV de Novembro', '1992-04-10', '71911110000', '89012345678'),
('Davi', 'I', 'Rocha', 'davi@email.com', 'Alameda Santos, 369', '1983-12-25', '81900009999', '90123456789'),
('Luciana', 'J', 'Mendes', 'luciana@email.com', 'Rua da Paz, 159', '1970-08-14', '91999998888', '01234567890'),
('Ricardo', 'K', 'Nunes', 'nunes@email.com', 'Av. Central, 753', '1998-02-28', '11988776655', '11234567891'),
('Bárbara', 'L', 'Lopes', 'barbara@email.com', 'Rua Direita, 951', '1993-10-15', '21977665544', '22345678912'),
('José', 'M', 'Gonçalves', 'jose@email.com', 'Praça da Sé, 357', '1987-07-07', '31966554433', '33456789123'),
('Sônia', 'N', 'Barbosa', 'sonia@email.com', 'Rua do Comércio, 486', '1981-05-19', '41955443322', '44567891234'),
('Thiago', 'O', 'Antunes', 'thiago@email.com', 'Av. Getúlio Vargas', '1976-11-03', '51944332211', '55678912345'),
('Jéssica', 'P', 'Teixeira', 'jessica@email.com', 'Rua das Palmeiras', '1994-12-12', '61933221100', '66789123456'),
('Carlos', 'Q', 'Tavares', 'carlos@email.com', 'Av. Independência', '1980-03-30', '71922110099', '77890123456'),
('Sandra', 'R', 'Moraes', 'sandra@email.com', 'Rua da Aurora, 741', '1991-09-21', '81911009988', '88901234567'),
('Cristovão','S', 'Jacó', 'cris@email.com', 'Rua da Guia, 369', '1984-06-02', '91900998877', '99012345678'),
('Kátia', 'T', 'Branco', 'katia@email.com', 'Rua Nova, 258', '1972-01-11', '11999112233', '10123456789'),
('Felipe', 'R', 'Nascimento', 'felipe.nasc@email.com', 'Av. Beira Mar, 500', '1990-03-12', '85988881111', '10293847561'),
('Renata', 'M', 'Cavalcante', 'renata.cav@email.com', 'Rua das Hortênsias, 22', '1987-11-25', '81977772222', '21304958672'),
('Bruno', 'S', 'Gomes', 'bruno.gomes@email.com', 'Rua Chile, 101', '1995-06-30', '71966663333', '32415069783'),
('Carla', 'T', 'Menezes', 'carla.mene@email.com', 'Av. Getúlio Vargas, 88', '1982-01-15', '31955554444', '43526170894'),
('Eduardo', 'V', 'Freitas', 'edu.freitas@email.com', 'Rua do Ouvidor, 45', '1979-09-05', '21944445555', '54637281905'),
('Fernanda', 'L', 'Bastos', 'fer.bastos@email.com', 'Rua XV de Novembro, 300', '1993-04-20', '41933336666', '65748392016'),
('Gustavo', 'H', 'Miranda', 'gus.miranda@email.com', 'Av. Afonso Pena, 1500', '1988-12-10', '67922227777', '76859403127'),
('Helena', 'P', 'Sampaio', 'helena.sam@email.com', 'Rua da Aurora, 12', '1991-07-18', '81911118888', '87960514238'),
('Igor', 'F', 'Lacerda', 'igor.lacerda@email.com', 'Travessa da Paz, 99', '1984-02-28', '92900009999', '98071625349'),
('Julia', 'B', 'Assis', 'julia.assis@email.com', 'Rua das Palmeiras, 77', '1996-10-02', '11999990000', '09182736450'),
('Leonardo', 'A', 'Vieira', 'leo.vieira@email.com', 'Av. Ipiranga, 200', '1983-05-14', '51988776655', '19283746501'),
('Monica', 'E', 'Duarte', 'monica.d@email.com', 'Rua Amazonas, 55', '1975-08-22', '62977665544', '20314253647'),
('Nathan', 'C', 'Cardoso', 'nathan.c@email.com', 'Av. Brasil, 1010', '1998-11-11', '61966554433', '31425364758'),
('Olivia', 'G', 'Campos', 'olivia.campos@email.com', 'Rua da Bahia, 33', '1992-03-03', '31955443322', '42536475869'),
('Paulo', 'D', 'Ribeiro', 'paulo.rib@email.com', 'Rua dos Pinheiros, 444', '1980-06-19', '11944332211', '53647586970'),
('Queila', 'S', 'Moreira', 'queila.m@email.com', 'Av. Industrial, 21', '1989-12-30', '47933221100', '64758697081'),
('Rodrigo', 'J', 'Moura', 'rodrigo.moura@email.com', 'Rua do Comércio, 5', '1986-02-14', '27922110099', '75869708192'),
('Simone', 'K', 'Leal', 'simone.leal@email.com', 'Praça da Sé, 1', '1977-07-07', '11911009988', '86970819203'),
('Tiago', 'N', 'Fogaça', 'tiago.fog@email.com', 'Rua da Guia, 88', '1994-01-25', '84900998877', '97081920314'),
('Ursula', 'P', 'Viana', 'ursula.v@email.com', 'Av. Sete de Setembro', '1990-09-09', '71999112233', '08192031425');
-- TABELA SUPPLIER
INSERT INTO supplier (Legal_Name, CNPJ, Lead_Time) VALUES
('TechBrasil Ltda', '12345678000101', 5.0),
('Têxtil Global S.A.', '23456789000102', 10.0),
('Alimentos Frescos ME', '34567890000103', 2.0),
('Móveis Design BR', '45678901000104', 15.0),
('Livraria do Saber', '56789012000105', 7.0),
('Brinquedos Alegria', '67890123000106', 12.0),
('Beleza Pura EIRELI', '78901234000107', 4.0),
('Esporte Radical', '89012345000108', 8.0),
('Escritório Pro', '90123456000109', 3.0),
('Geral de Gadgets', '01234567000110', 6.0),
('Mestre da Cozinha', '11234567000111', 5.0),
('Produtos Eco', '22345678000112', 14.0),
('Auto Peças Silva', '33456789000113', 9.0),
('Relógios de Luxo', '44567890000114', 20.0),
('Mídia Digital', '55678901000115', 3.0),
('Ferramentas Fortes', '66789012000116', 7.0),
('Paraíso dos Pets', '77890123000117', 4.0),
('Aventura ao Ar Livre', '88901234000118', 11.0),
('Som & Tom Co.', '99012345000119', 6.0),
('Saúde em Dia', '10123456000120', 2.0);

-- TABELA SELLER 
-- Location preenchida apenas com a UF
INSERT INTO seller (Legal_Name, CNPJ, CPF, Address, Location, Phone) VALUES
-- PESSOAS JURÍDICAS (Apenas CNPJ)
('Eletro Silva S.A.', '10101010000101', NULL, 'Rua Direita, 10', 'SP', '1140028922'),
('Tech Sul Ltda', '20202020000102', NULL, 'Distrito Industrial', 'RS', '5133334444'),
('Mercado Central EIRELI', '30303030000103', NULL, 'Setor Comercial', 'DF', '6130001000'),
('Livraria Express Ltda', '40404040000104', NULL, 'Rua das Letras', 'PR', '4130002000'),
('Estilo Urbano ME', '50505050000105', NULL, 'Av. Getúlio Vargas', 'CE', '8532001000'),
('Papelaria Brasil S.A.', '60606060000106', NULL, 'Rua das Flores', 'GO', '6232006600'),
('Manaus Tech Import', '70707070000107', NULL, 'Polo Industrial', 'AM', '9236008800'),
('Varejo Total S.A.', '80808080000108', NULL, 'Centro Cívico', 'MS', '6733001122'),
('Alagoas Celulares Ltda', '90909090000109', NULL, 'Rua do Comércio', 'AL', '8233005566'),
('Ferragens Maranhão ME', '01010101000110', NULL, 'Zona Norte', 'MA', '9832009900'),

-- PESSOAS FÍSICAS (Apenas CPF)
('João do Frete', NULL, '11122233344', 'Av. das Nações', 'RJ', '2199999888'),
('Ana Modas', NULL, '22233344455', 'Rua da Moda', 'MG', '3198888777'),
('Pedro Carpinteiro', NULL, '33344455566', 'Via das Oficinas', 'SC', '4832221111'),
('Maria Brinquedos', NULL, '44455566677', 'Shopping Norte', 'BA', '7133004400'),
('Carlos Sports', NULL, '55566677788', 'Vila Olímpica', 'PE', '8134005500'),
('Horta da Dana', NULL, '66677788899', 'Estrada Velha', 'ES', '2733007700'),
('Eduardo Móveis', NULL, '77788899900', 'Av. Afonso Pena', 'MT', '6536009900'),
('Fiona Floricultura', NULL, '88899900011', 'Rua das Rosas', 'RN', '8432003344'),
('Jorge Mercearia', NULL, '99900011122', 'Rua da Balsa', 'PA', '9132007788'),
('Artesanato da Ana', NULL, '10111213141', 'Orla de Atalaia', 'SE', '7932001122');
INSERT INTO seller (Legal_Name, CNPJ, CPF, Address, Location, Phone) VALUES
-- PESSOAS JURÍDICAS (CNPJ)
('Logística Norte S.A.', '11223344000101', NULL, 'Porto Velho', 'RO', '6932211000'),
('Variedades Gaúchas', '22334455000102', NULL, 'Rua da Praia', 'RS', '5132224444'),
('Floripa Tech Ltda', '33445566000103', NULL, 'Centro', 'SC', '4833335555'),
('Cuiabá Mix ME', '44556677000104', NULL, 'Av. Historiador Rubens', 'MT', '6536211111'),
('Eletro Nordeste S.A.', '55667788000105', NULL, 'Orla', 'PB', '8332227777'),
('Mineirão Atacado', '66778899000106', NULL, 'Contorno', 'MG', '3134448888'),
('Amazonas Store', '77889900000107', NULL, 'Adrianópolis', 'AM', '9236669999'),
('Potiguar Vendas', '88990011000108', NULL, 'Pontal', 'RN', '8432220000'),
('Capixaba Ferragens', '99001122000109', NULL, 'Vila Velha', 'ES', '2733221111'),
('Goias Fashion Ltda', '10203040000110', NULL, 'Setor Marista', 'GO', '6232223333'),

-- PESSOAS FÍSICAS (CPF)
('Beto das Ferramentas', NULL, '12123234354', 'Rua das Pedras', 'RJ', '21988881111'),
('Dona Neide Bolos', NULL, '23234345465', 'Rua do Sol', 'PI', '86977772222'),
('Sérgio da Informática', NULL, '34345456576', 'Av. Central', 'PR', '41966663333'),
('Carla Maquiagens', NULL, '45456567687', 'Rua da Paz', 'MS', '67955554444'),
('Zezinho do Som', NULL, '56567678798', 'Av. das Torres', 'TO', '63944445555'),
('Amanda Doces', NULL, '67678789809', 'Rua das Palmeiras', 'AL', '82933336666'),
('Paulo do Artesanato', NULL, '78789890910', 'Beira Mar', 'CE', '85922227777'),
('Lucia Costuras', NULL, '89890901021', 'Rua Nova', 'PE', '81911118888'),
('Marcos do Queijo', NULL, '90901012132', 'Serra da Canastra', 'MG', '37900009999'),
('Tiago Assistência', NULL, '01012123243', 'Centro', 'AC', '68999990000');

-- TABELA PAGAMENTO 
INSERT INTO payments (Id_PaymentCustomer, Payment_Value, Fees, Payment_Type, Payment_Status, LimitAvailable) VALUES
(1, 1500.00, 45.00, 'CARD', 'Approved', 5000.00),
(2, 50.00, 0.00, 'BANK TRANSFER', 'Approved', 1200.00),
(3, 89.90, 2.70, 'CARD', 'Approved', 3000.00),
(4, 2500.00, 0.00, 'BANK TRANSFER', 'Pending', 1000.00),
(5, 120.00, 3.60, 'CARD', 'Approved', 2500.00),
(6, 45.00, 0.00, 'BANK TRANSFER', 'Approved', 800.00),
(7, 300.00, 9.00, 'CARD', 'Processing', 4500.00),
(8, 150.00, 4.50, 'CARD', 'Approved', 1500.00),
(9, 25.00, 0.00, 'BANK TRANSFER', 'Approved', 2000.00),
(10, 900.00, 27.00, 'CARD', 'Approved', 6000.00),
(11, 55.00, 1.65, 'CARD', 'Approved', 1100.00),
(12, 10.00, 0.00, 'BANK TRANSFER', 'Approved', 500.00),
(13, 1200.00, 36.00, 'CARD', 'Approved', 7000.00),
(14, 75.00, 2.25, 'CARD', 'Approved', 2200.00),
(15, 450.00, 0.00, 'BANK TRANSFER', 'Approved', 3000.00),
(16, 35.00, 1.05, 'CARD', 'Approved', 1500.00),
(17, 200.00, 6.00, 'CARD', 'Approved', 2800.00),
(18, 15.00, 0.00, 'BANK TRANSFER', 'Approved', 1000.00),
(19, 600.00, 18.00, 'CARD', 'Approved', 4000.00),
(20, 95.00, 2.85, 'CARD', 'Approved', 3500.00);

-- TABELA ORDENS 
INSERT INTO orders (Orders_Status, idOrders_Customer, Delivery_Fee, Product_Description, SendValue, IdOrders_Payment, Payment) VALUES
('Shipped', 1, 25.0, 'Compra de Smartphone', 10.0, 1, TRUE),
('Delivered', 2, 12.0, 'Camiseta Algodão', 10.0, 2, TRUE),
('Confirmed', 3, 15.0, 'Livros Variados', 10.0, 3, TRUE),
('Processing', 4, 80.0, 'Cadeira de Escritório', 10.0, 4, FALSE),
('Invoiced', 5, 10.0, 'Fone de Ouvido', 10.0, 5, TRUE),
('Shipped', 6, 20.0, 'Brinquedo Lego', 10.0, 6, TRUE),
('Placed', 7, 18.0, 'Kit Maquilhagem', 10.0, 7, FALSE),
('Delivered', 8, 0.0, 'Ténis Corrida', 10.0, 8, TRUE),
('Delivered', 9, 7.0, 'Material de Papelaria', 10.0, 9, TRUE),
('Processing', 10, 30.0, 'Monitor Gamer', 10.0, 10, TRUE),
('Shipped', 11, 15.0, 'Roupas Infantil', 10.0, 11, TRUE),
('Delivered', 12, 5.0, 'Suplementos', 10.0, 12, TRUE),
('Invoiced', 13, 45.0, 'Mesa de Jantar', 10.0, 13, TRUE),
('Confirmed', 14, 12.0, 'Romance Literário', 10.0, 14, TRUE),
('Shipped', 15, 22.0, 'Smartwatch', 10.0, 15, TRUE),
('Delivered', 16, 8.0, 'Creme Facial', 10.0, 16, TRUE),
('Processing', 17, 14.0, 'Bola de Futebol', 10.0, 17, TRUE),
('Delivered', 18, 5.0, 'Calculadora', 10.0, 18, TRUE),
('Invoiced', 19, 20.0, 'Caixa de Som BT', 10.0, 19, TRUE),
('Shipped', 20, 15.0, 'Calça Jeans', 10.0, 20, TRUE);
INSERT INTO orders (Id_Orders, Orders_Status, idOrders_Customer, Delivery_Fee, Product_Description, IdOrders_Payment) VALUES
(21, 'Processing', 1, 15.50, 'Smartphone X e Capinha', 1),
(22, 'Shipped', 2, 20.00, 'Cadeira de Escritório', 2),
(23, 'Delivered', 3, 0.00, 'Guia de Python', 3),
(24, 'Confirmed', 4, 10.00, 'Batom Vermelho', 1),
(25, 'Processing', 5, 8.50, 'Caneta Esferográfica', 2),
(26, 'Shipped', 6, 25.00, 'Moletom de Algodão', 3),
(27, 'Delivered', 7, 30.00, 'Estante de Livros', 1),
(28, 'Confirmed', 8, 15.00, 'Conjunto LEGO', 2),
(29, 'Processing', 9, 12.00, 'Bola de Basquete', 3),
(30, 'Shipped', 10, 18.00, 'Caixa de Som Bluetooth', 1),
(31, 'Delivered', 11, 0.00, 'T-Shirt Blue', 2),
(32, 'Confirmed', 12, 22.00, 'Cadeira de Escritório Premium', 3),
(33, 'Processing', 13, 9.00, 'Action Figure Colecionável', 1),
(34, 'Shipped', 14, 11.00, 'Tapete de Yoga Profissional', 2),
(35, 'Delivered', 15, 5.00, 'Mouse Sem Fio', 3),
(36, 'Confirmed', 16, 7.50, 'Caixa de Cereal Matinal', 1),
(37, 'Processing', 17, 6.00, 'Livro de Ficção Científica', 2),
(38, 'Shipped', 18, 13.00, 'Creme Facial Hidratante', 3),
(39, 'Delivered', 19, 4.00, 'Grampeador de Mesa', 1),
(40, 'Confirmed', 20, 19.00, 'Calça Jeans Denim', 2);

-- TABELA ESTOQUE 
INSERT INTO stock (Location, Minimum_Stock, Stock_Status, Quantity, Id_Product) VALUES
('SP', 5, 'in_stock', 100, 1),
('RJ', 10, 'in_stock', 200, 2),
('MG', 50, 'in_stock', 1000, 3),
('SC', 2, 'in_stock', 10, 4),
('PR', 10, 'in_stock', 45, 5),
('BA', 15, 'in_stock', 60, 6),
('CE', 20, 'in_stock', 85, 7),
('PE', 10, 'in_stock', 30, 8),
('GO', 100, 'in_stock', 500, 9),
('AM', 5, 'in_stock', 25, 10),
('RS', 10, 'in_stock', 40, 11),
('ES', 30, 'in_stock', 150, 12),
('MT', 2, 'in_stock', 8, 13),
('MS', 5, 'in_stock', 20, 14),
('RN', 10, 'out_of_stock', 0, 15),
('PB', 15, 'in_stock', 55, 16),
('AL', 10, 'in_stock', 40, 17),
('MA', 50, 'in_stock', 200, 18),
('DF', 10, 'in_stock', 35, 19),
('SE', 10, 'in_stock', 70, 20);

-- TABELA PRODUTO 


INSERT INTO product (IdProduct, Pname, Children_Classification, Category, Price, Revenue, Sale_Price, Cost_Price, Rate, Size, BRAND) VALUES
(1, 'Smartphone X', 0, 'Electronics', 800, 300, 750, 500, 4.5, 'M', 'TechCo'),
(2, 'T-Shirt Blue', 1, 'Clothing', 25, 10, 20, 15, 4.0, 'G', 'Threads'),
(3, 'Organic Apple', 0, 'Food', 2.5, 1, 2.0, 1.5, 4.8, 'S', 'Nature'),
(4, 'Office Chair', 0, 'Furniture', 150, 50, 130, 100, 4.2, 'XL', 'Comfort'),
(5, 'Python Guide', 0, 'Books', 45, 20, 40, 25, 4.9, 'S', 'StudyPress'),
(6, 'Action Figure', 1, 'Toys', 30, 12, 28, 18, 4.3, 'S', 'Heroic'),
(7, 'Lipstick Red', 0, 'Beauty', 15, 7, 14, 8, 4.6, 'XS', 'Glow'),
(8, 'Yoga Mat', 0, 'Sports', 40, 15, 35, 25, 4.7, 'G', 'Zen'),
(9, 'Ballpoint Pen', 0, 'Office', 1.5, 0.5, 1.2, 1, 4.1, 'S', 'WriteRight'),
(10, 'Wireless Mouse', 0, 'Electronics', 25, 10, 22, 15, 4.4, 'S', 'Click'),
(11, 'Cotton Hoodie', 1, 'Clothing', 55, 20, 50, 35, 4.5, 'M', 'Threads'),
(12, 'Cereal Box', 1, 'Food', 5, 2, 4.5, 3, 4.0, 'G', 'Crispy'),
(13, 'Bookshelf', 0, 'Furniture', 120, 40, 110, 80, 4.3, 'G', 'OakHome'),
(14, 'Sci-Fi Novel', 0, 'Books', 18, 8, 16, 10, 4.8, 'S', 'PaperBack'),
(15, 'LEGO Set', 1, 'Toys', 100, 30, 95, 70, 4.9, 'M', 'BuildIt'),
(16, 'Face Cream', 0, 'Beauty', 35, 15, 32, 20, 4.4, 'S', 'Glow'),
(17, 'Basketball', 0, 'Sports', 25, 10, 22, 15, 4.6, 'M', 'Peak'),
(18, 'Stapler', 0, 'Office', 12, 4, 10, 8, 4.2, 'S', 'OfficeX'),
(19, 'Bluetooth Speaker', 0, 'Electronics', 60, 25, 55, 35, 4.5, 'M', 'SoundMax'),
(20, 'Denim Jeans', 0, 'Clothing', 70, 25, 65, 45, 4.3, '40', 'DenimCo');

-- TABELA PRODUTO_PEDIDO 
INSERT INTO order_product (Id_ProductOrder, Id_Order, Quantity) VALUES
(1, 1, 1), (5, 2, 1), (10, 3, 1), (3, 4, 5), 
(4, 5, 1), (15, 6, 1), (20, 7, 2), (7, 8, 3), 
(11, 9, 1), (9, 10, 10), (1, 11, 1), (19, 12, 1), 
(12, 13, 4), (13, 14, 1), (14, 15, 2), (19, 16, 1), 
(16, 17, 1), (17, 18, 1), (18, 19, 2), (20, 20, 1);
INSERT INTO order_product (Id_ProductOrder, Id_Order, Quantity) VALUES
(1, 21, 1), (10, 21, 1), -- Pedido 21 tem Smartphone e Mouse
(4, 22, 1),             -- Pedido 22 tem Cadeira
(5, 23, 2),             -- Pedido 23 tem 2 Livros de Python
(7, 24, 1),             -- Pedido 24 tem Batom
(9, 25, 10),            -- Pedido 25 tem 10 Canetas
(11, 26, 1),            -- Pedido 26 tem Moletom
(13, 27, 1),            -- Pedido 27 tem Estante
(15, 28, 1),            -- Pedido 28 tem LEGO
(17, 29, 1),            -- Pedido 29 tem Bola
(19, 30, 1),            -- Pedido 30 tem Caixa de Som
(2, 31, 2),             -- Pedido 31 tem 2 Camisetas
(13, 32, 1),            -- Pedido 32 tem Estante Premium
(6, 33, 1),             -- Pedido 33 tem Action Figure
(8, 34, 1),             -- Pedido 34 tem Tapete Yoga
(10, 35, 1),            -- Pedido 35 tem Mouse
(12, 36, 3),            -- Pedido 36 tem 3 Cereais
(14, 37, 1),            -- Pedido 37 tem Livro Ficção
(16, 38, 1),            -- Pedido 38 tem Creme Facial
(18, 39, 2),            -- Pedido 39 tem 2 Grampeadores
(20, 40, 1);            -- Pedido 40 tem Jeans

-- TABELA PRODUTO_VENDEDOR 
INSERT INTO product_seller (Id_Seller, Id_Product, QUANTITY) VALUES
-- Vendedores 1 a 20 (Mix de CNPJ e CPF)
(1, 1, 50), (2, 5, 20), (3, 10, 15), (4, 15, 10), (5, 2, 30),
(6, 4, 12), (7, 18, 50), (8, 6, 8), (9, 3, 100), (10, 20, 25),
(11, 1, 15), (12, 19, 10), (13, 12, 45), (14, 8, 22), (15, 14, 30),
(16, 7, 12), (17, 2, 15), (18, 9, 200), (19, 11, 40), (20, 13, 5),

-- Vendedores 21 a 40 (Os novos que você adicionou por último)
(21, 1, 5), (22, 16, 20), (23, 17, 15), (24, 10, 8), (25, 5, 12),
(26, 3, 80), (27, 15, 3), (28, 19, 10), (29, 4, 7), (30, 20, 15),
(31, 2, 25), (32, 6, 14), (33, 18, 9), (34, 12, 200), (35, 13, 4),
(36, 7, 35), (37, 12, 150), (38, 8, 18), (39, 11, 10), (40, 1, 12);


-- TABELA LOCALIZACAO DOS ARMAZENS 

INSERT INTO storage_location (Id_stock, Id_Product, Location, Quantity) VALUES
(1, 1, 'SP', 150),
(2, 2, 'RJ', 200),
(3, 3, 'MG', 500),
(4, 4, 'SP', 40),
(5, 5, 'PR', 85),
(6, 6, 'RJ', 120),
(7, 7, 'SC', 95),
(8, 8, 'MG', 60),
(9, 9, 'SP', 1000),
(10, 10, 'RS', 35);

-- INICIANDO AS QUERIES 

-- VERIFICANDO TIPO DE PAGAMENTO POR ESTADO (GROUP BY, INNER JOIN)

SELECT 
    c.UF, 
    p.Payment_Type, 
    COUNT(o.Id_Orders) AS Qtd_Pedidos
FROM customer c
INNER JOIN orders o ON c.idCustomer = o.idOrders_Customer
INNER JOIN payments p ON o.IdOrders_Payment = p.idPayment
GROUP BY c.UF, p.Payment_Type
ORDER BY c.UF; 

-- LOCALIZACAO DOS ESTOQUES E QUANTIDADE POR ESTADO (WHERE)
SELECT Location, Quantity AS Quantidade_Por_Estado
	FROM storage_location 
	WHERE Location = 'SP'; 
    
-- Categorias com mais produtos (Having)
SELECT Category AS Categoria, COUNT(Pname) AS Total_Produtos
FROM Product
GROUP BY Category
HAVING COUNT(*)> 2
ORDER BY Total_Produtos DESC;
