-- ==========================
-- Tabela de filiais
-- ==========================
CREATE TABLE branch (
    id BIGSERIAL PRIMARY KEY,          -- Identificador único da filial, autoincrementável
    nome VARCHAR(255) NOT NULL,        -- Nome da filial
    bairro VARCHAR(255) NOT NULL,      -- Bairro onde a filial está localizada
    cnpj VARCHAR(20) NOT NULL          -- CNPJ da filial
);

-- ==========================
-- Tabela de pátios
-- ==========================
CREATE TABLE patio (
    id BIGSERIAL PRIMARY KEY,          -- Identificador único do pátio
    nome VARCHAR(255) NOT NULL,        -- Nome do pátio
    branch_id BIGINT NOT NULL,         -- Referência à filial a qual o pátio pertence

    -- Cria chave estrangeira para branch, deletando pátios caso a filial seja removida
    CONSTRAINT fk_patio_branch FOREIGN KEY (branch_id) REFERENCES branch (id) ON DELETE CASCADE
);

-- ==========================
-- Tabela de motocicletas
-- ==========================
CREATE TABLE motorcycle (
    id BIGSERIAL PRIMARY KEY,          -- Identificador único da motocicleta
    placa VARCHAR(7) NOT NULL UNIQUE,  -- Placa da moto (única)
    chassi VARCHAR(17) NOT NULL UNIQUE,-- Número do chassi (único)
    numeracao_motor VARCHAR(17) NOT NULL, -- Número do motor (único)
    motorcycle_models VARCHAR(255) NOT NULL, -- Modelo da motocicleta
    patio_id BIGINT,                   -- Referência ao pátio onde a moto está
    situacao VARCHAR(255) NOT NULL,    -- Situação da moto (ex: manutenção, triagem)

    -- Cria chave estrangeira para patio, setando patio_id como NULL caso o pátio seja removido
    CONSTRAINT fk_motorcycle_patio FOREIGN KEY (patio_id) REFERENCES patio (id) ON DELETE SET NULL
);

-- ==========================
-- Tabela de grupos de motocicletas
-- ==========================
CREATE TABLE motorcycle_groups (
    motorcycle_id BIGINT NOT NULL,     -- Referência à motocicleta
    model VARCHAR(50) NOT NULL,        -- Modelo do grupo

    -- Chave estrangeira para motocicleta, deletando grupos caso a moto seja removida
    CONSTRAINT fk_motorcycle_groups FOREIGN KEY (motorcycle_id) REFERENCES motorcycle (id) ON DELETE CASCADE
);

-- ==========================
-- Inserindo filiais
-- ==========================
INSERT INTO branch (nome, bairro, cnpj) VALUES
    ('Filial Paulista', 'Paulista', '12345678901234'),
    ('Filial Vila Mariana', 'Vila Mariana', '23456789012345'),
    ('Filial Pinheiros', 'Pinheiros', '34567890123456');

-- ==========================
-- Inserindo pátios
-- ==========================
INSERT INTO patio (nome, branch_id) VALUES
    ('Pátio Aguardo Peças', 1),
    ('Pátio Emplacamento', 2),
    ('Pátio Triagem', 3);

-- ==========================
-- Inserindo motocicletas
-- ==========================
INSERT INTO motorcycle (placa, chassi, numeracao_motor, motorcycle_models, situacao, patio_id) VALUES
    ('BRA2E19', '1HGCM82633A123456', 'MTR123456', 'MottuSport', 'Troca de relação', 1),
    ('XYZ5D87', '2HGCM82633A654321', 'MTR654321', 'MottuE', 'Emplacamento', 2),
    ('JKL9A01', '3HGCM82633A789012', 'MTR789012', 'MottuPop', 'Aguardando triagem', 3);

-- ==========================
-- Tabela de usuários
-- ==========================
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,          -- Identificador único do usuário
    username VARCHAR(50) NOT NULL UNIQUE, -- Nome de usuário (único)
    password VARCHAR(255) NOT NULL     -- Senha criptografada
);

-- ==========================
-- Tabela de papéis (roles) de usuários
-- ==========================
CREATE TABLE user_roles (
    user_id BIGINT NOT NULL,           -- Referência ao usuário
    roles VARCHAR(20) NOT NULL,        -- Papel do usuário (ex: ADMIN, OPERADOR)
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ==========================
-- Inserindo usuários
-- ==========================
INSERT INTO users (id, username, password)
VALUES (1,'adminCM', '$2a$12$kfv6IHAZeoMJvqKCjaOCruqY71AQE8H3GaQFjdQFAYtw0g43utoeS'); 
-- Senha: admin123 (hash bcrypt)

INSERT INTO user_roles (user_id, roles)
VALUES (1, 'ROLE_ADMIN');            -- Papel do usuário admin

INSERT INTO users (id, username, password)
VALUES (2, 'operadorCM', '$2a$12$yqipcxXd4bZFTxTqkxw7uOIhvCvnfUSK554cS5k.IOhMYlHRH2quu'); 
-- Senha: operador123 (hash bcrypt)

INSERT INTO user_roles (user_id, roles)
VALUES (2, 'ROLE_OPERADOR');         -- Papel do usuário operador
