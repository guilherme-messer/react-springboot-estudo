-- Script de inicialização do banco de dados
-- Este arquivo será executado automaticamente quando o container PostgreSQL for criado

-- Criar extensões úteis
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Criar schema da aplicação (opcional)
-- CREATE SCHEMA IF NOT EXISTS app_schema;

-- Exemplo de tabela de usuários
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Exemplo de tabela de posts/artigos
CREATE TABLE IF NOT EXISTS posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    content TEXT,
    author_id UUID REFERENCES users(id) ON DELETE CASCADE,
    published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_posts_author ON posts(author_id);
CREATE INDEX IF NOT EXISTS idx_posts_published ON posts(published);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at);

-- Inserir dados de exemplo (opcional)
INSERT INTO users (username, email, password_hash) 
VALUES 
    ('admin', 'admin@example.com', crypt('admin123', gen_salt('bf'))),
    ('user1', 'user1@example.com', crypt('user123', gen_salt('bf')))
ON CONFLICT (email) DO NOTHING;

-- Inserir posts de exemplo
INSERT INTO posts (title, content, author_id, published)
SELECT 
    'Post de Exemplo',
    'Este é um post de exemplo criado durante a inicialização do banco.',
    u.id,
    true
FROM users u 
WHERE u.username = 'admin'
ON CONFLICT DO NOTHING;

